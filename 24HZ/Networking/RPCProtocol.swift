//
// RPC.swift
// 24HZ
// 
// Created by jin on 2023-09-24
// 



import Foundation

/// Protocol for making **manual** JSON-RPC requests to Ethereum+ endpoints
/// Ethereum+: Any chain that is EVM-compatible
/// EVM-copmatible: A blockchain that conforms to the Ethereum JSON-RPC specifications
/// Reference: https://ethereum.org/en/developers/docs/apis/json-rpc/
///
/// Note: This is kept as a protocol open for implementation as different RPC endpoint providers have varying limitations and exposed methods
protocol RPCProtocol {
    
    /// URL of RPC endpoint.
    /// - adopters must provide the url to use in any HTTP request
    var url: URL { get set }
    
    // MARK: Methods
    func getBlocksInRange(fromBlock: Int, toBlock: Int) async throws -> [BlockObject]
    func getTransactionReceipts(txHashes: [String]) async throws -> [TransactionReceiptObject]
}

// MARK: - JSON Response Objects
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
    let to: String?     /// If to field is nil, it indicates the transaction created a new contract
}

struct TransactionReceiptObject: Codable {
    let blockHash: String
    let blockNumber: String
    let contractAddress: String
    let from: String
    let transactionHash: String
    
    enum CodingKeys: String, CodingKey {
        case result
    }
    
    enum ResultCodingKeys: String, CodingKey {
        case blockHash
        case blockNumber
        case contractAddress
        case from
        case transactionHash
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let result = try container.nestedContainer(keyedBy: ResultCodingKeys.self, forKey: .result)
        blockHash = try result.decode(String.self, forKey: .blockHash)
        blockNumber = try result.decode(String.self, forKey: .blockNumber)
        contractAddress = try result.decode(String.self, forKey: .contractAddress)
        from = try result.decode(String.self, forKey: .from)
        transactionHash = try result.decode(String.self, forKey: .transactionHash)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        /// Nested containers
        var result = container.nestedContainer(keyedBy: ResultCodingKeys.self, forKey: .result)
        try result.encode(blockHash, forKey: .blockHash)
        try result.encode(blockNumber, forKey: .blockNumber)
        try result.encode(contractAddress, forKey: .contractAddress)
        try result.encode(from, forKey: .from)
        try result.encode(transactionHash, forKey: .transactionHash)
    }
}
