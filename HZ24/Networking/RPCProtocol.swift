//
// RPC.swift
// 24HZ
// 
// Created by jin on 2023-09-24
// 


import Foundation

/// Protocol for talking directly to Ethereum+ endpoints via JSON-RPC.
///
/// Ethereum+: Any chain that is EVM-compatible.
/// EVM-compatible: A blockchain that conforms to the Ethereum JSON-RPC specifications.
/// Reference: [](https://ethereum.org/en/developers/docs/apis/json-rpc/)
///
/// Note: This is kept as a protocol open for implementation as RPC endpoint providers vary in request limits and exposed methods.
protocol RPCProtocol {
    
    // MARK: Properties
    /// URL of RPC endpoint.
    ///
    /// Adopters must provide the url to use in any network request
    var url: URL { get set }
    
    // MARK: Methods
    /// A method to retrieve information about blocks in a given range.
    ///
    /// Block information must be retrieved with `full transaction objects` so that the `to` field can be checked for `nil` - indicating that that transaction was a contract deployment transaction. If the option to receive `full transaction objects` is not specified in network request, the `transactions` array will only include the transaction hashes.
    ///
    /// See: [](https://ethereum.org/en/developers/docs/apis/json-rpc/#eth_getblockbyhash)
    ///
    /// - Parameters:
    ///   - fromBlock: The earliest block number to include in query.
    ///   - toBlock: The most recent block number to include in query.
    /// - Returns: A list of objects containing all the necessary information about each block. Must include an array of `transactions` in each ``BlockObject``.
    func getBlocksInRange(fromBlock: Int, toBlock: Int) async throws -> [BlockObject]
    
    /// A method to retrieve transaction receipts.
    ///
    /// This method aims to retrieve the contract addresses of newly deployed contracts.
    ///
    /// A transaction receipt for a deployment transaction contains the new contract address created for this newly deployed contract.
    ///
    /// See: [](https://ethereum.org/en/developers/docs/apis/json-rpc/#eth_gettransactionreceipt)
    ///
    /// - Parameters:
    ///   - txHashes: Transaction hashes (plain `String`/s; not hex-encoded)
    ///
    /// - Returns: A list of objects containing all the necessary information about each transaction receipt. Must include the `contractAddress` for deployment transactions.
    func getTransactionReceipts(txHashes: [String]) async throws -> [TransactionReceiptObject]
    
    /// A method to retrieve the name and symbol, if any, for token contracts.
    ///
    /// - Parameters:
    ///   - contractAddresses: Contract addresses (plain `String`/s; not hex-encoded)
    ///
    /// - Returns: A list of objects containing the name and symbol of a token contract. Must include the `contractAddress` to match against the given `contractAddresses` argument.
    func getTokenInfos(contractAddresses: [String]) async throws -> [TokenInfo]
    
    /// A method to check conformance to any ERC Interface for contract addresses.
    ///
    /// - Parameters:
    ///   - contractAddresses: Contract addresses (plain `String`/s; not hex-encoded)
    ///   - interfaceIds: ERC Interface signatures to filter for. (Must be ABI-encoded)
    ///
    /// - Returns: Contract addresses and the given ERC Interfaces that they conform to. Note: Only contract addresses that conform to the given ERC interfaces must be included in the list.
    func filterContractsWithInterfaceSupport(contractAddresses: [String], interfaceIds: [Data]) async throws -> [String: InterfaceInfo]
}


// MARK: - Associated Structs

/// An object containing information about a block.
struct BlockObject: Codable {
    let number: String
    let hash: String
    let timestamp: Date
    let transactions: [TransactionObject]
    
    // MARK: Errors
    enum JSONDecodeError : Error {
        case decodeError
    }
    
    enum CodingKeys: String, CodingKey {
        case result
    }
    enum ResultCodingKeys: String, CodingKey {
        case number
        case hash
        case timestamp
        case transactions
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let result = try container.nestedContainer(keyedBy: ResultCodingKeys.self, forKey: .result)
        number = try result.decode(String.self, forKey: .number)
        hash = try result.decode(String.self, forKey: .hash)
        transactions = try result.decode([TransactionObject].self, forKey: .transactions)
        guard let timestampRaw = try? result.decode(String.self, forKey: .timestamp),
              let timeInterval = TimeInterval(timestampRaw) else {
            throw JSONDecodeError.decodeError
        }
        timestamp = Date(timeIntervalSince1970: timeInterval)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        /// Nested containers
        var result = container.nestedContainer(keyedBy: ResultCodingKeys.self, forKey: .result)
        try result.encode(number, forKey: .number)
        try result.encode(hash, forKey: .hash)
        try result.encode(Int(timestamp.timeIntervalSince1970).web3.hexString, forKey: .timestamp)
        try result.encode(transactions, forKey: .transactions)
    }
}

/// An object containing information about a transaction
///
/// The `to` property identifies contract deployment transactions.
struct TransactionObject: Codable {
    let hash: String
    let to: String?     /// If to field is nil, it indicates the transaction created a new contract
}

/// An object containing information about a transaction receipt.
///
/// The `contractAddress` is the new contract address created for contract deployment transactions. For any other transaction, this field is `nil`
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

/// An object containing information about a token contract, such as their name and symbol.
struct TokenInfo: Identifiable {
    let id = UUID()
    let contractAddress: String
    var name: String?
    var symbol: String?
}

/// And object containing information about a contract's conformance to an ERC interface.
struct InterfaceInfo {
    let contractAddress: String
    var ercInterfaceId: ERCInterfaceId
}
