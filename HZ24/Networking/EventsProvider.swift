//
// EventsProvider.swift
// 24HZ
// 
// Created by jin on 2023-09-24
// 


import Foundation

/// Protocol for providing blockchain events to a data layer like Core Data.
///
/// Adopters should use appropriate ``RPCProtocol`` conformers, third-party libraries, and/or their own methods to collect events via the network and format for consumer.
protocol EventsProvider {
    
    // MARK: - Properties
    var chainId: ChainID { get set }
    
    // MARK: - Methods
    /// A method to return the current block number.
    ///
    /// Should be used to identify the most recent block number to query for events.
    ///
    /// - Returns: Block number as an `Int` value.
    func getCurrentBlockNumber() async throws -> Int
    
    // TODO: Can refactor forInterfaces data type to be ERCInterfaceId type and convert to useful type in implementation
    /// A method to retrieve new token contract deployment events.
    ///
    /// - Parameters:
    ///   - fromBlock: The lower bound of block range (inclusive)
    ///   - toBlock: The upper bound of block range (inclusive)
    ///   - forInterfaces: ``ERCInterfaceId`` to query for
    ///
    /// - Returns: Useful information about newly deployed token contracts in given block range.
    func getNewTokenEvents(fromBlock: Int, toBlock: Int, forInterfaces interfaceIds: [Data]) async throws -> [NewTokenEventStruct]
    
    /// A method to retrieve events related to metadata updates for given token contracts.
    ///
    /// - Parameters:
    ///   - fromBlock: The lower bound of block range (inclusive)
    ///   - toBlock: The upper bound of block range (inclusive)
    ///   - forContracts: Contract addresses to query for
    ///
    /// - Returns: Objects containing information about metadata update events.
    func getMetadataEvents(fromBlock: Int, toBlock: Int, forContracts contracts: [String]?) async throws -> [MetadataEventStruct]
    
    /// A method to retrieve mint events where the minter included a comment.
    ///
    /// - Parameters:
    ///   - fromBlock: The lower bound of block range (inclusive)
    ///   - toBlock: The upper bound of block range (inclusive)
    ///   - forContracts: Contract addresses to query for
    ///
    /// - Returns: Objects containing information about mint with comment events.
    func getMintCommentEvents(fromBlock: Int, toBlock: Int, forContracts contracts: [String]?) async throws -> [MintCommentEventStruct]

    // Currently out of scope
//    func getSalesUpdateEvents(fromBlock: Int, toBlock: Int, forContracts contracts: [String]?) async throws -> [SalesUpdateEvent]
}

/// The number identifier of an EVM-compatible chain..
enum ChainID : Int {
    case eth = 1
    case zora = 7777777
}

/// A struct that contains useful information about a token contract deployment event.
///
/// Should be used to create ``NewTokenEvent`` in Core Data layer.
struct NewTokenEventStruct {
    
    /// MO: ``Event`` attribute/s
    var ercInterfaceId: ERCInterfaceId

    var contractAddress: String
    var tokenName: String?
    var tokenSymbol: String?
    
    var blockNumber: String
    var blockHash: String
    var timestamp: Date
    var txHash: String
    
    /// MO: ``NewTokenEvent`` attribute/s
    var deployerAddress: String
}

/// A struct that contains useful information about an event related to metadata updates.
///
/// Should be used to create ``MetadataEvent`` in Core Data layer.
struct MetadataEventStruct {

    /// MO ``Event`` attribute/s
    var contractAddress: String
    var tokenName: String?
    var tokenSymbol: String?
    var blockNumber: String
    var blockHash: String?
    var txHash: String?
    
    /// MO: ``MetadataEvent`` attribute/s
    var abiEventName: String
    var updatedAnimationURI: String?
    var updatedContractURI: String?
    var updatedFreezeAt: Int64?
    var updatedImageURI: String?
    var updatedMetadataBase: String?
    var updatedMetadataExtension: String?
    var updatedName: String?
    var updatedNewDescription: String?
    var updatedURI: String?
    
    
}

/// A struct that contains useful information about en event where the user included a comment.
///
/// Should be used to create ``MintCommentEvent`` in Core Data layer.
struct MintCommentEventStruct {
    /// MO ``Event`` attribute/s
    var contractAddress: String
    var tokenName: String?
    var tokenSymbol: String?
    var blockNumber: Int64
    var blockHash: String?
    var timestamp: Date
    var txHash: String?
    
    /// MO: ``MintComment`` attribute/s
    var abiEventName: String
    var mintComment: String
    var quantity: Int64?
    var sender: String
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
