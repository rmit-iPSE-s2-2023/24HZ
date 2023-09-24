//
// ThirdWebRPC.swift
// 24HZ
// 
// Created by jin on 2023-09-24
// 


import Foundation

/// This implementation uses RPC endpoints provided by Third Web
/// Reference: https://thirdweb.com/dashboard/infrastructure/rpc-edge
struct ThirdWebRPC : RPCProtocol {
    var url: URL
    
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
        case rpcRequestSerializationError
        case httpResponseError(message: String)
        case responseDataDecodeError
    }
}

extension ThirdWebRPC {
    // MARK: Methods
    
    /// Get block headers for a given block range to access transactions and look for contract creation transactions
    func getBlocksInRange(fromBlock: Int, toBlock: Int) async throws -> [BlockObject] {
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
        guard response is HTTPURLResponse else {
            throw ThirdWebRPCError.httpResponseError(message: "No HTTP URL Response.\nReceived response: \(response)")
        }
        /// Decode downloaded data
        guard let decodedData = try? JSONDecoder().decode([BlockObject].self, from: data) else {
            throw ThirdWebRPCError.responseDataDecodeError
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
        guard response is HTTPURLResponse else {
            throw ThirdWebRPCError.httpResponseError(message: "No HTTP URL Response.\nReceived response: \(response)")
        }
        /// Decode downloaded data
        guard let decodedData = try? JSONDecoder().decode([TransactionReceiptObject].self, from: data) else {
            throw ThirdWebRPCError.responseDataDecodeError
        }
        /// Return data as [TransactionReceiptObject]
        return decodedData
    }
}
