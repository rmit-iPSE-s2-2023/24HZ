//
// DefaultEventsProvider.swift
// 24HZ
// 
// Created by jin on 2023-09-24
// 



import Foundation
import web3

/// This implementation of ``EventsProvider`` uses the `web3.swift` Swift Package for some Ethereum convenience methods
class DefaultEventsProvider : EventsProvider {
    var chainId: ChainID
    
    private let client: EthereumHttpClient
    
    // MARK: Singleton/s
    static let zora = DefaultEventsProvider(chain: "zora")
    static let eth = DefaultEventsProvider(chain: "ethereum")
    
    // MARK: Initializer
    private init(chain: String) {
        guard let clientUrl = URL(string: "https://\(chain).rpc.thirdweb.com") else {
            fatalError("Invalid URL for Ethereum client")
        }
        chainId = ChainID.zora
        client = EthereumHttpClient(url: clientUrl)
    }
}

extension DefaultEventsProvider {
    enum EventsProviderError: Error {
        case encodeError(message: String)
        case multicallError(message: String)
    }
}

extension DefaultEventsProvider {
    
    func getCurrentBlockNumber() async throws -> Int {
        let currentBlock = try await self.client.eth_blockNumber()
        return currentBlock
    }
    
    func getNewDeploymentEvents(fromBlock: Int, toBlock: Int, forInterfaces: [String]?) async throws -> [NewDeploymentEvent] {
        fatalError("implement getNewDeploymentEvents")
    }
    
    func getMetadataEvents(fromBlock: Int, toBlock: Int, forContracts contracts: [String]?) async throws -> [MetadataUpdateEvent] {
        fatalError("implement getMetadataEvents")
    }
    
    func getMintCommentEvents(fromBlock: Int, toBlock: Int, forContracts contracts: [String]?) async throws -> [MintCommentEvent] {
        fatalError("implement getMintCommentEvents")
    }
    
    
}
