//
// MintCommentEvent.swift
// 24HZ
// 
// Created by jin on 2023-09-26
// 



import Foundation
import web3
import BigInt

/// Types conforming to ``ABIEvent`` related to Mints for a ERC-721 or ERC-1155 token contract
/// Dependencies: web3, BigInt
enum MintEvent {
    /// Event from ERC721Drop ABI (Zora 721) & ZoraCreatorFixedPriceStrategy (Zora 1155)
    public struct MintComment: ABIEvent {
        public static let name = "MintComment"
        public static let types: [ABIType.Type] = [EthereumAddress.self, EthereumAddress.self, BigUInt.self, BigUInt.self, String.self]
        public static let typesIndexed = [true, true, true, false, false]
        public let log: EthereumLog
        
        public let sender: EthereumAddress
        public let tokenContract: EthereumAddress
        public let tokenId: BigUInt
        public let quantity: BigUInt
        public let comment: String
        
        public init?(topics: [ABIDecoder.DecodedValue], data: [ABIDecoder.DecodedValue], log: EthereumLog) throws {
            try MintComment.checkParameters(topics, data)
            self.log = log
            
            self.sender = try topics[0].decoded()
            self.tokenContract = try topics[1].decoded()
            self.tokenId = try topics[2].decoded()
            self.quantity = try data[0].decoded()
            self.comment = try data[1].decoded()
        }
    }
}
