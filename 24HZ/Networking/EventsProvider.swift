//
// EventsProvider.swift
// 24HZ
// 
// Created by jin on 2023-09-24
// 



import Foundation

/// Protocol for providing events to a data layer (like Core Data). Adopters should use appropriate RPCProtocol conformers, third-party libraries, and/or their own methods to collect events and format for consumer.
/// - should not know anything about how data is managed
/// - just provide the correct data in the correct format
protocol EventsProvider {
    
    // MARK: Protocol property/s
    var chainId: ChainID { get set }
    
    // MARK: Protocol method/s
    
    /// Returns the current block number for set chainId
    func getCurrentBlockNumber() async throws -> Int
    
    /// Returns all ``NewTokenEvent`` in given block range for specified interfaceIds
    /// - Parameters:
    ///   - fromBlock: The lower bound of block range (inclusive)
    ///   - toBlock: The upper bound of block range (inclusive)
    ///   - forInterfaces: ``ERCInterfaceId`` to query for
    // TODO: Can refactor forInterfaces data type to be ERCInterfaceId type and convert to useful type in implementation
    func getNewTokenEvents(fromBlock: Int, toBlock: Int, forInterfaces interfaceIds: [Data]) async throws -> [NewTokenEventStruct]
    
    /// Returns all ``MetadataEvent`` in given block range for specified contract addresses
    /// - Parameters:
    ///   - fromBlock: The lower bound of block range (inclusive)
    ///   - toBlock: The upper bound of block range (inclusive)
    ///   - forContracts: Contract addresses to query for
    func getMetadataEvents(fromBlock: Int, toBlock: Int, forContracts contracts: [String]?) async throws -> [String: [MetadataEventStruct]]
    
    /// Returns all ``MintEvent`` in given block range for specified contract addresses
    /// - Parameters:
    ///   - fromBlock: The lower bound of block range (inclusive)
    ///   - toBlock: The upper bound of block range (inclusive)
    ///   - forContracts: Contract addresses to query for
    func getMintCommentEvents(fromBlock: Int, toBlock: Int, forContracts contracts: [String]?) async throws -> [String: [MintCommentEventStruct]]

    // Currently out of scope
//    func getSalesUpdateEvents(fromBlock: Int, toBlock: Int, forContracts contracts: [String]?) async throws -> [SalesUpdateEvent]
}

enum ChainID : Int {
    case eth = 1
    case zora = 7777777
}

struct NewTokenEventStruct {
    /// MO: Event property/s
    var contractAddress: String
    var ercInterfaceId: ERCInterfaceId
    var tokenName: String?
    var tokenSymbol: String?
    
    var blockNumber: String
    var blockHash: String
    var txHash: String
    
    /// MO: NewTokenEvent property/s
    var deployerAddress: String
}

struct MetadataEventStruct {
//    let eventType: EventType = .newContract
    let eventType: String = "Metadata Update"

    // MARK: Instance property/s
    var contractAddress: String
    var tokenType: String?  // FIXME: Implement this part
    var tokenName: String?
    var tokenSymbol: String?
    
    var blockNumber: String
    var blockHash: String?
    var txHash: String?
}

struct MintCommentEventStruct {
//    let eventType: EventType = .newContract
    let eventType: String = "Mint Comment"
    
    // MARK: Event specific property/s
    var comment: String?

    // MARK: Instance property/s
    var contractAddress: String
    var tokenType: String?  // FIXME: Implement this part
    var tokenName: String?
    var tokenSymbol: String?
    
    var blockNumber: String
    var blockHash: String?
    var txHash: String?
}

// Currently out of scope
//struct SalesUpdateEvent {
////    let eventType: EventType = .newContract
//    let eventType: String = "salesUpdate"
//
//    var contractAddress: String
//    var tokenType: String?
//    var tokenName: String?
//    var tokenSymbol: String?
//
//    var blockNumber: String
//    var blockHash: String?
//    var txHash: String?
//}
