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
    func getCurrentBlockNumber() async throws -> Int
    func getNewTokenEvents(fromBlock: Int, toBlock: Int, forInterfaces interfaceIds: [Data]) async throws -> [NewTokenEvent]
    func getMetadataEvents(fromBlock: Int, toBlock: Int, forContracts contracts: [String]?) async throws -> [MetadataUpdateEvent]
    func getMintCommentEvents(fromBlock: Int, toBlock: Int, forContracts contracts: [String]?) async throws -> [MintCommentEvent]
    
    // Currently out of scope
//    func getSalesUpdateEvents(fromBlock: Int, toBlock: Int, forContracts contracts: [String]?) async throws -> [SalesUpdateEvent]
}

enum ChainID : Int {
    case eth = 1
    case zora = 7777777
}

struct NewTokenEvent {
//    let eventType: EventType = .newContract
    let eventType: String = "newDeployment"

    // MARK: Instance property/s
    var contractAddress: String
    var tokenType: ERCInterfaceId
    var tokenName: String?
    var tokenSymbol: String?
    
    var blockNumber: String
    var blockHash: String
    var txHash: String
}

struct MetadataUpdateEvent {
//    let eventType: EventType = .newContract
    let eventType: String = "metadataUpdate"

    // MARK: Instance property/s
    var contractAddress: String
    var tokenType: String?  // FIXME: Implement this part
    var tokenName: String?
    var tokenSymbol: String?
    
    var blockNumber: String
    var blockHash: String?
    var txHash: String?
}

struct MintCommentEvent {
//    let eventType: EventType = .newContract
    let eventType: String = "mintComment"
    
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
