//
// MetadataEvent.swift
// 24HZ
// 
// Created by jin on 2023-09-25
// 



import Foundation
import web3
import BigInt

/// Dependencies: web3, BigInt
/// Types conforming to `web3/ABIEvent` related to Metadata updates for a ERC-721 or ERC-1155 token contract
enum MetadataEventABI {
    /// Events from EditionMetadataRenderer ABI (Zora 721)
    public struct DescriptionUpdated: ABIEvent {
        public static let name = "DescriptionUpdated"
        public static let types: [ABIType.Type] = [EthereumAddress.self, EthereumAddress.self, String.self]
        public static let typesIndexed = [true, false, false]
        public let log: EthereumLog
        
        public let target: EthereumAddress  // Target is the tokenContract Address (topic 1 in getEvents)
        public let sender: EthereumAddress
        public let newDescription: String
        
        public init?(topics: [ABIDecoder.DecodedValue], data: [ABIDecoder.DecodedValue], log: EthereumLog) throws {
            try DescriptionUpdated.checkParameters(topics, data)
            self.log = log
            
            self.target = try topics[0].decoded()
            self.sender = try data[0].decoded()
            self.newDescription = try data[1].decoded()
        }
    }
    public struct MediaURIsUpdated: ABIEvent {
        public static let name = "MediaURIsUpdated"
        public static let types: [ABIType.Type] = [EthereumAddress.self, EthereumAddress.self, String.self, String.self]
        public static let typesIndexed = [true, false, false, false]
        public let log: EthereumLog
        
        public let target: EthereumAddress  // Target is the tokenContract Address (topic 1 in getEvents)
        public let sender: EthereumAddress
        public let imageURI: String
        public let animationURI: String
        
        public init?(topics: [ABIDecoder.DecodedValue], data: [ABIDecoder.DecodedValue], log: EthereumLog) throws {
            try MediaURIsUpdated.checkParameters(topics, data)
            self.log = log
            
            self.target = try topics[0].decoded()
            self.sender = try data[0].decoded()
            self.imageURI = try data[1].decoded()
            self.animationURI = try data[2].decoded()
        }
    }
    /// Events from DropMetadataRenderer ABI (Zora 721)
    public struct MetadataUpdated: ABIEvent {
        public static let name = "MetadataUpdated"
        public static let types: [ABIType.Type] = [EthereumAddress.self, String.self, String.self, String.self, BigUInt.self]
        public static let typesIndexed = [true, false, false, false, false]
        public let log: EthereumLog
        
        public let target: EthereumAddress  // Target is the tokenContract Address (topic 1 in getEvents)
        public let metadataBase: String
        public let metadataExtension: String
        public let contractURI: String
        public let freezeAt: BigUInt
        
        public init?(topics: [ABIDecoder.DecodedValue], data: [ABIDecoder.DecodedValue], log: EthereumLog) throws {
            try MetadataUpdated.checkParameters(topics, data)
            self.log = log
            
            self.target = try topics[0].decoded()
            self.metadataBase = try data[0].decoded()
            self.metadataExtension = try data[1].decoded()
            self.contractURI = try data[2].decoded()
            self.freezeAt = try data[3].decoded()
        }
    }
    /// Events from ZoraCreator1155Impl ABI (Zora 1155)
    public struct ContractMetadataUpdated: ABIEvent {
        public static let name = "ContractMetadataUpdated"
        public static let types: [ABIType.Type] = [EthereumAddress.self, String.self, String.self]
        public static let typesIndexed = [true, false, false]
        public let log: EthereumLog

        public let updated: EthereumAddress
        public let uri: String
        public let name: String

        public init?(topics: [ABIDecoder.DecodedValue], data: [ABIDecoder.DecodedValue], log: EthereumLog) throws {
            try ContractMetadataUpdated.checkParameters(topics, data)
            self.log = log

            self.updated = try topics[0].decoded()
            self.uri = try data[0].decoded()
            self.name = try data[1].decoded()
        }
    }
}
