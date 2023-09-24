//
// ThirdWebRPC.swift
// 24HZ
// 
// Created by jin on 2023-09-24
// 



import Foundation

struct ThirdWebRPC : RPC {
    var url: URL
    
    init(chainName: String) {
        guard let url = URL(string: "https://\(chainName).rpc.thirdweb.com") else {
            fatalError("Invalid URL for RPC client")
        }
        self.url = url
    }
}

// MARK: - ThirdWebRPC Errors
extension ThirdWebRPC {
    enum ThirdWebRPCError : Error {
        case rpcRequestSerializationError
        case httpResponseError(message: String)
        case responseDataDecodeError
    }
}

extension ThirdWebRPC {
    func getBlocksInRange(fromBlock: Int, toBlock: Int) async throws -> [BlockObject] {
        /// Form JSON-RPC request body
        let jsonRpcRequests: [[String: Any]] = (fromBlock...toBlock).map { blockNumber in
            [
                "jsonrpc": "2.0",
                "method": "eth_getBlockByNumber",
                "params": ["0x" + String(blockNumber, radix: 16), true] as [Any],
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
        guard let response = response as? HTTPURLResponse else {
            throw ThirdWebRPCError.httpResponseError(message: "No HTTP URL Response.\nReceived response: \(response)")
        }
        /// Decode downloaded data
        guard let decodedData = try? JSONDecoder().decode([BlockObject].self, from: data) else {
            throw ThirdWebRPCError.responseDataDecodeError
        }
        /// Return data as [BlockObject]
        return decodedData
    }
}

struct BlockObject: Codable {
    let number: String
    let hash: String
    let transactions: [TransactionObject]
    
    enum CodingKeys: String, CodingKey {
        case result
    }
    enum ResultCodingKeys: String, CodingKey {
        case number
        case hash
        case transactions
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let result = try container.nestedContainer(keyedBy: ResultCodingKeys.self, forKey: .result)
        number = try result.decode(String.self, forKey: .number)
        hash = try result.decode(String.self, forKey: .hash)
        transactions = try result.decode([TransactionObject].self, forKey: .transactions)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        /// Nested containers
        var result = container.nestedContainer(keyedBy: ResultCodingKeys.self, forKey: .result)
        try result.encode(number, forKey: .number)
        try result.encode(hash, forKey: .hash)
        try result.encode(transactions, forKey: .transactions)
    }
}

struct TransactionObject: Codable {
    let hash: String
    let to: String?
}
