//
// ThirdWebRPC.swift
// 24HZ
// 
// Created by jin on 2023-09-24
// 


import Foundation
import web3

/// An implementation of ``RPCProtocol``
/// This implementation uses RPC endpoints provided by Third Web
/// Dependencies: web3.swift (to encode ABI functions)
/// References:
/// Third Web: https://thirdweb.com/dashboard/infrastructure/rpc-edge
/// web3.swift: https://github.com/argentlabs/web3.swift
struct ThirdWebRPC : RPCProtocol {
    var url: URL
    
    static let maxBatchSize = 1000  // Max batch size limit is 1000 for Third Web RPC Edge
    
    init(chainName: String) {
        guard let url = URL(string: "https://\(chainName).rpc.thirdweb.com") else {
            fatalError("Invalid URL for RPC client")
        }
        self.url = url
    }
}

extension ThirdWebRPC {
    // MARK: Errors
    enum ThirdWebRPCError : Error {
        case exceedsMaxBatchSizeError
        case rpcRequestSerializationError
        case httpResponseError(message: String)
        case responseDataDecodeError(message: String)
        case abiDecodeError(message: String)
        case dictionarySaveError
    }
}

extension ThirdWebRPC {
    // MARK: Protocol method implementation/s
    
    /// Get block headers for a given block range to access transactions and look for contract creation transactions
    func getBlocksInRange(fromBlock: Int, toBlock: Int) async throws -> [BlockObject] {
        /// Make sure block range is valid
        guard toBlock - fromBlock + 1 <= ThirdWebRPC.maxBatchSize else {
            throw ThirdWebRPCError.exceedsMaxBatchSizeError
        }
        /// Form JSON-RPC request body
        let jsonRpcRequests: [[String: Any]] = (fromBlock...toBlock).map { blockNumber in
            [
                "jsonrpc": "2.0",
                "method": "eth_getBlockByNumber",
                "params": ["0x" + String(blockNumber, radix: 16), true] as [Any],   /// `true` means include full transaction objects in response. This is necessary to access the `to` field to determine whether the transaction was for a new contract creation
                "id": Int(blockNumber) // Use a unique ID based on the block number
            ]
        }
        // FIXME: Debugging
        print("getBlocksInRange jsonRpcRequests count: \(jsonRpcRequests.count)")
        /// Serialize request body
        guard let requestData = try? JSONSerialization.data(withJSONObject: jsonRpcRequests) else {
            throw ThirdWebRPCError.rpcRequestSerializationError
        }
        /// Create URLRequest
        var request = URLRequest(url: self.url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = requestData
        /// Try download data
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ThirdWebRPCError.httpResponseError(message: "No HTTP URL Response.\nReceived response: \(response)")
        }
        if httpResponse.statusCode != 200 {
            throw ThirdWebRPCError.httpResponseError(message: "Not 200. Status code: \(httpResponse.statusCode). data: \(String(describing: String(data: data, encoding: .utf8)))")
        }
        /// Decode downloaded data
        guard let decodedData = try? JSONDecoder().decode([BlockObject].self, from: data) else {
            print("data: \(String(describing: String(data: data, encoding: .utf8)))")
            throw ThirdWebRPCError.responseDataDecodeError(message: "Failed to decode BlockObject in ThirdWebRPC.getBlocksInRange")
        }
        /// Return data as [BlockObject]
        return decodedData
    }
    
    /// To get the **contract address** of new contract deployments:
    /// - after filtering `BlockObject`s for new contract deployments; any transaction in a block whose `to` field is `nil`, we need to get the **transaction receipts** of every transaction to get the **contract address** of these new contract deployments
    func getTransactionReceipts(txHashes: [String]) async throws -> [TransactionReceiptObject] {
        /// Form JSON-RPC request body
        let jsonRpcRequests: [[String: Any]] = txHashes.map { txHash in
            [
                "jsonrpc": "2.0",
                "method": "eth_getTransactionReceipt",
                /// Parameters:
                /// 1. DATA, 32 Bytes - hash of a transaction
                "params": [txHash],
                "id": txHash
            ]
        }
        // FIXME: Debugging
        print("getTransactionReceipts jsonRpcRequests count: \(jsonRpcRequests.count)")
        /// Serialize request body
        guard let requestData = try? JSONSerialization.data(withJSONObject: jsonRpcRequests) else {
            throw ThirdWebRPCError.rpcRequestSerializationError
        }
        /// Create URLRequest
        var request = URLRequest(url: self.url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = requestData
        /// Try download data
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ThirdWebRPCError.httpResponseError(message: "No HTTP URL Response.\nReceived response: \(response)")
        }
        if httpResponse.statusCode != 200 {
            throw ThirdWebRPCError.httpResponseError(message: "Not 200. Status code: \(httpResponse.statusCode). data: \(String(describing: String(data: data, encoding: .utf8)))")
        }
        /// Decode downloaded data
        guard let decodedData = try? JSONDecoder().decode([TransactionReceiptObject].self, from: data) else {
            throw ThirdWebRPCError.responseDataDecodeError(message: "Failed to decode TransactionReceiptObject in ThirdWebRPC.getTransactionReceipts")
        }
        /// Return data as [TransactionReceiptObject]
        return decodedData
    }

    
    // TODO: Need to filter for contracts that supports erc-20/721/1155 interface
    func getTokenInfos(contractAddresses: [String]) async throws -> [String: TokenInfo] {
        /// return empty array if no contractAddresses given
        if contractAddresses.isEmpty {
            return [:]
        }
        /// Create encoder to encode name function
        let nameEncoder = ABIFunctionEncoder("name")
        /// Encode ABI function to encoder
        /// Note: For name and symbol functions:
        /// - These have the same ABI signatures for 20s, 721s, and 1155s
        /// Note: Here, we're just using the web3.swift library for convenience encoding/decoding so it does not matter what contract address we pass in but we need to pass in something for the sake of initializing the struct
        let nameFunc = ERC721MetadataFunctions.name(contract: EthereumAddress(contractAddresses.first!))    // contractName doens't matter here, so just passing in any value
        try nameFunc.encode(to: nameEncoder)
        /// Store encodedData to variable
        let nameData = try nameEncoder.encoded()
        /// Create encoder to encode symbol function
        let symbolEncoder = ABIFunctionEncoder("symbol")
        /// Encode ABI function to encoder
        let symbolFunc = ERC721MetadataFunctions.symbol(contract: EthereumAddress(contractAddresses.first!))    // contractName doens't matter here, so just passing in any value
        try symbolFunc.encode(to: symbolEncoder)
        /// Store encodedData to variable
        let symbolData = try symbolEncoder.encoded()
        /// Form batch JSON-RPC request body
        let jsonRpcRequests: [[String: Any]] = contractAddresses.flatMap({ contractAddress in
            return [
                [
                    "jsonrpc": "2.0",
                    "method": "eth_call",
                    "params": [
                        [
                            "to": contractAddress,
                            "data": nameData.web3.hexString
                        ] as [String: Any],
                        "latest"
                    ] as [Any],
                    "id": contractAddress + "_name"
                ],
                [
                    "jsonrpc": "2.0",
                    "method": "eth_call",
                    "params": [
                        [
                            "to": contractAddress,
                            "data": symbolData.web3.hexString
                        ] as [String: Any],
                        "latest"
                    ] as [Any],
                    "id": contractAddress + "_symbol"
                ],
            ]
        })
        /// Serialize request body
        guard let requestData = try? JSONSerialization.data(withJSONObject: jsonRpcRequests) else {
            throw ThirdWebRPCError.rpcRequestSerializationError
        }
        /// Create URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = requestData
        /// Try download data
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ThirdWebRPCError.httpResponseError(message: "No HTTP URL Response.\nReceived response: \(response)")
        }
        if httpResponse.statusCode != 200 {
            throw ThirdWebRPCError.httpResponseError(message: "Not 200. Status code: \(httpResponse.statusCode). data: \(String(describing: String(data: data, encoding: .utf8)))")
        }
        /// Decode data to RPC Response data
        guard let decodedData = try? JSONDecoder().decode([RPCResponseData].self, from: data) else {
            print(String(describing: String(data: data, encoding: .utf8)))
            throw ThirdWebRPCError.responseDataDecodeError(message: "Failed to decode [RPCResponseData] in ThirdWebRPC.getTokenInfos")
        }
        var tokenInfos: [String: TokenInfo] = [:]
        contractAddresses.forEach { contractAddress in
            tokenInfos[contractAddress] = TokenInfo(contractAddress: contractAddress)
        }
        /// Decode each result
        try decodedData.forEach { rpcResponseData in
            /// Determine which contract it's for
            let contractAddress = rpcResponseData.id.components(separatedBy: "_")[0]
            let function = rpcResponseData.id.components(separatedBy: "_")[1]
            var tokenInfo = tokenInfos[contractAddress]
            switch function {
            case "name":
                if rpcResponseData.result != nil {
                    guard let nameResponse = (try? ERC20Responses.nameResponse(data: rpcResponseData.result!)) else {
                        throw ThirdWebRPCError.abiDecodeError(message: "Failed to decode hex string result to String.")
                    }
                    tokenInfo?.name = nameResponse.value
                    tokenInfos[contractAddress] = tokenInfo
                }
            case "symbol":
                if rpcResponseData.result != nil {
                    guard let symbolResponse = (try? ERC20Responses.symbolResponse(data: rpcResponseData.result!)) else {
                        throw ThirdWebRPCError.abiDecodeError(message: "Failed to decode hex string result to String.")
                    }
                    tokenInfo?.symbol = symbolResponse.value
                    tokenInfos[contractAddress] = tokenInfo
                }
            default:
                throw ThirdWebRPCError.dictionarySaveError
            }
        }
        return tokenInfos
    }
}

extension ThirdWebRPC {
    
    // MARK: Private method/s
    func filterContractsWithInterfaceSupport(contractAddresses: [String], interfaceIds: [Data]) async throws -> [String: InterfaceInfo] {
        // TODO: For each contract, check for interface support on 20/721/1155. Aggregate responses by true results and return a dictionary keyed by contract address for object with contract address and its ERCType/ERCInterfaceId
        let jsonRpcRequests: [[String: Any]] = contractAddresses.flatMap { contractAddress -> [[String: Any]] in
            /// Create encoder to encode supportsInterface function for ERc-20
            return interfaceIds.compactMap { interfaceId -> [String: Any]? in
                do {
                    let encoder = ABIFunctionEncoder("supportsInterface")
                    /// Encode ABI function to encoder
                    let supportsInterfaceFunc = ERC165Functions.supportsInterface(contract: EthereumAddress(contractAddress), interfaceId: interfaceId)
                    try supportsInterfaceFunc.encode(to: encoder)
                    /// Store encodedData to variable
                    let encodedData = try encoder.encoded()
                    let request: [String: Any] = [
                        "jsonrpc": "2.0",
                        "method": "eth_call",
                        "params": [
                            [
                                "to": contractAddress,
                                "data": encodedData.web3.hexString
                            ] as [String: Any],
                            "latest"
                        ] as [Any],
                        "id": contractAddress + "_" + interfaceId.web3.hexString
                    ]
                    return request
                } catch {
                    print("An error occurred while processing contract \(contractAddress) with interfaceId \(interfaceId.web3.hexString): \(error)")
                    return nil
                }
            }
        }
        /// Serialize request body
        guard let requestData = try? JSONSerialization.data(withJSONObject: jsonRpcRequests) else {
            throw ThirdWebRPCError.rpcRequestSerializationError
        }
        /// Create URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = requestData
        /// Try download data
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ThirdWebRPCError.httpResponseError(message: "No HTTP URL Response.\nReceived response: \(response)")
        }
        if httpResponse.statusCode != 200 {
            throw ThirdWebRPCError.httpResponseError(message: "Not 200. Status code: \(httpResponse.statusCode). data: \(String(describing: String(data: data, encoding: .utf8)))")
        }
        /// Decode data to RPC Response data
        guard let decodedData = try? JSONDecoder().decode([RPCResponseWithError].self, from: data) else {
            print(String(describing: String(data: data, encoding: .utf8)))
            throw ThirdWebRPCError.responseDataDecodeError(message: "Failed to decode [RPCResponseData] in ThirdWebRPC.filterContractsWithInterfaceSupport")
        }
        var interfaceInfos: [String: InterfaceInfo] = [:]
        /// Decode each result
        try decodedData.forEach { rpcResponseData in
            /// If result returned (instead of error), try decode it
            if let result = rpcResponseData.result {
                guard let decodedResult = (try? ERC165Responses.supportsInterfaceResponse(data: result)) else {
                    throw ThirdWebRPCError.abiDecodeError(message: "Failed to decode hex string result to String.")

                }
                // If interface is supported, add InterfaceInfo to dictionary
                if decodedResult.supported {
                    let contractAddress = rpcResponseData.id.components(separatedBy: "_")[0]
                    let interfaceId = rpcResponseData.id.components(separatedBy: "_")[1]
                    if let ercInterfaceId = ERCInterfaceId(rawValue: interfaceId) {
                        let interfaceInfo = InterfaceInfo(contractAddress: contractAddress, ercInterfaceId: ercInterfaceId)
                        interfaceInfos[contractAddress] = interfaceInfo
                    }
                }
            }

        }
        return interfaceInfos
        
    }
    /// These methods should only be used for testing purposes
    func checkSupportsInterface(contractAddress: String, interfaceId: Data) async throws -> Bool {
        /// Create encoder to encode ABI function
        let encoder = ABIFunctionEncoder("supportsInterface")
        /// Encode ABI function to encoder
        let supportsInterfaceFunc = ERC165Functions.supportsInterface(contract: EthereumAddress(contractAddress), interfaceId: interfaceId)
        try supportsInterfaceFunc.encode(to: encoder)
        /// Store encodedData to variable
        let encodedData = try encoder.encoded()
        print(encodedData.web3.hexString)
        /// Form JSON-RPC request body
        let jsonRpcRequest: [String: Any] = [
            "jsonrpc": "2.0",
            "method": "eth_call",
            "params": [
                [
                    "to": contractAddress,
                    "data": encodedData.web3.hexString
                ] as [String: Any],
                "latest"
            ] as [Any],
            "id": contractAddress // Use a unique ID based on the block number
        ]
        /// Serialize request body
        guard let requestData = try? JSONSerialization.data(withJSONObject: jsonRpcRequest) else {
            throw ThirdWebRPCError.rpcRequestSerializationError
        }
        /// Create URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = requestData
        /// Try download data
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ThirdWebRPCError.httpResponseError(message: "No HTTP URL Response.\nReceived response: \(response)")
        }
        if httpResponse.statusCode != 200 {
            throw ThirdWebRPCError.httpResponseError(message: "Not 200. Status code: \(httpResponse.statusCode). data: \(String(describing: String(data: data, encoding: .utf8)))")
        }
        /// Decode data to RPC Response data
        guard let decodedData = try? JSONDecoder().decode(RPCResponseData.self, from: data) else {
            print(String(describing: String(data: data, encoding: .utf8)))
            throw ThirdWebRPCError.responseDataDecodeError(message: "Failed to decode RPCResponseData in ThirdWebRPC.checkSupportsInterface")
        }
        /// Decode result hex string to String
        guard let supportsInterfaceResult = (try? ERC165Responses.supportsInterfaceResponse(data: decodedData.result!)) else {
            throw ThirdWebRPCError.abiDecodeError(message: "Failed to decode hex string result to String.")
        }
        return supportsInterfaceResult.supported
        
    }
    func getTokenName(contractAddress: String) async throws -> String {
        /// Create encoder to encode ABI function
        let encoder = ABIFunctionEncoder("name")
        /// Encode ABI function to encoder
        let nameFunc = ERC721MetadataFunctions.name(contract: EthereumAddress(contractAddress))
        try nameFunc.encode(to: encoder)
        /// Store encodedData to variable
        let encodedData = try encoder.encoded()
        /// Form JSON-RPC request body
        let jsonRpcRequest: [String: Any] = [
            "jsonrpc": "2.0",
            "method": "eth_call",
            "params": [
                [
                    "to": contractAddress,
                    "data": encodedData.web3.hexString
                ] as [String: Any],
                "latest"
            ] as [Any],
            "id": contractAddress /// Use a unique **string** here for decoder
        ]
        /// Serialize request body
        guard let requestData = try? JSONSerialization.data(withJSONObject: jsonRpcRequest) else {
            throw ThirdWebRPCError.rpcRequestSerializationError
        }
        /// Create URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = requestData
        /// Try download data
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ThirdWebRPCError.httpResponseError(message: "No HTTP URL Response.\nReceived response: \(response)")
        }
        if httpResponse.statusCode != 200 {
            throw ThirdWebRPCError.httpResponseError(message: "Not 200. Status code: \(httpResponse.statusCode). data: \(String(describing: String(data: data, encoding: .utf8)))")
        }
        /// Decode data to RPC Response data
        guard let decodedData = try? JSONDecoder().decode(RPCResponseData.self, from: data) else {
            print(String(describing: String(data: data, encoding: .utf8)))
            throw ThirdWebRPCError.responseDataDecodeError(message: "Failed to decode RPCResponseData in ThirdWebRPC.getTokenName")
        }
        /// Decode result hex string to String
        guard let nameResponse = (try? ERC20Responses.nameResponse(data: decodedData.result!)) else {
            throw ThirdWebRPCError.abiDecodeError(message: "Failed to decode hex string result to String.")
        }
        return nameResponse.value
    }
}

struct RPCResponseError: Codable {
    let error: String?
    let id: String
}

struct RPCResponseWithError: Codable {
    let id: String
    let error: ErrorObject?
    let result: String?

    enum CodingKeys: String, CodingKey {
        case id
        case error
        case result
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)

        // Check if the container has the "result" key
        if let resultString = try? container.decode(String.self, forKey: .result) {
            result = resultString
            error = nil
        } else {
            // If "result" key is not present, assume an error response
            result = nil
            error = try container.decode(ErrorObject.self, forKey: .error)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)

        // Conditionally encode "result" or "error" based on their presence
        if let result = result {
            try container.encode(result, forKey: .result)
        } else if let error = error {
            try container.encode(error, forKey: .error)
        }
    }
}


struct ErrorObject: Codable {
    let code: Int?
    let message: String?
}

struct RPCResponseData: Codable {
    let result: String?
    let error: String?
    let id: String
}

struct TokenInfo {
    let contractAddress: String
    var name: String?
    var symbol: String?
}

struct InterfaceInfo {
    let contractAddress: String
    var ercInterfaceId: ERCInterfaceId
}
