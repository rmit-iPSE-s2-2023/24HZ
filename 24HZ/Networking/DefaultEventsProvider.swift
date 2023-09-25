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
    private let rpc: RPCProtocol
    
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
        rpc = ThirdWebRPC(chainName: "zora")
    }
}

extension DefaultEventsProvider {
    enum EventsProviderError: Error {
        case rpcError(message: String)
        case encodeError(message: String)
        case multicallError(message: String)
    }
}

extension DefaultEventsProvider {
    // MARK: Protocol method implementation/s
    func getCurrentBlockNumber() async throws -> Int {
        let currentBlock = try await self.client.eth_blockNumber()
        return currentBlock
    }
    
    /// Returns information about new contract deployment events within given block range for specified interfaces if any.
    /// fromBlock: The lower number in block range (inclusive)
    /// toBlock: The higher number in block range (inclusive)
    /// forInterfaces: An array of interface Ids
    /// Note: Users should not be aware of interface types. This is to make the right requests in the backend for different token types
    // TODO: Implement functionality to filter for interfaces (erc-20, erc-721, erc-1155 etc.)
    func getNewTokenEvents(fromBlock: Int, toBlock: Int, forInterfaces: [String]?) async throws -> [NewTokenEvent] {
        /// RPC Call1: Get ``BlockObject``s for given block range
        guard let blockObjects = try? await rpc.getBlocksInRange(fromBlock: fromBlock, toBlock: toBlock) else {
            throw EventsProviderError.rpcError(message: "rpc.getBlocksInRange failed.")
        }
        /// Filter for  new deployment ``TransactionObject``/s; whose `to` field is `nil`
        let deployTxObjects = blockObjects.flatMap { blockObject in
            return blockObject.transactions.filter { tx in
                return tx.to == nil
            }
        }
        /// Map ``TransactionObject``/s to trasaction hashes
        let deployTxHashes = deployTxObjects.map { txObj in
            return txObj.hash
        }
        /// RPC Call2: Get ``TransactionReceiptObject``/s using deployment transaction hashes
        guard let deployTxReceipts = try? await rpc.getTransactionReceipts(txHashes: deployTxHashes) else {
            throw EventsProviderError.rpcError(message: "rpc.getTransactionReceipts failed.")
        }
        /// RPC Call3: Filter ``TransactionReceiptObject``/s that support one of ``ERCInterfaceId``
        let deployContractAddresses = deployTxReceipts.map { txReceipt in
            txReceipt.contractAddress
        }
        print("DEBUG: deployContractAddresses: \(deployContractAddresses)")
        let interfaceIds = [ERCInterfaceId.erc1155.rawValue.web3.hexData!, ERCInterfaceId.erc20.rawValue.web3.hexData!, ERCInterfaceId.erc721.rawValue.web3.hexData!]
        let tokenContracts = try await rpc.filterContractsWithInterfaceSupport(contractAddresses: deployContractAddresses, interfaceIds: interfaceIds)
        /// Filter txReceipts checking if its contractAddress is a key in tokenContracts
        let newTokenEvents = deployTxReceipts.compactMap { txReceipt in
            if let interfaceInfo = tokenContracts[txReceipt.contractAddress] {
                let newTokenEvent = NewTokenEvent(contractAddress: txReceipt.contractAddress, tokenType: interfaceInfo.ercInterfaceId, blockNumber: txReceipt.blockNumber, blockHash: txReceipt.blockHash, txHash: txReceipt.transactionHash)
                return newTokenEvent
            } else {
                return nil
            }
        }
        /// Create array to store ``NewDeploymentEvent``/s
        // FIXME: Instead of creating a new array we could potentially do this with inout
        var newTokenEventsWithTokenInfo: [NewTokenEvent] = []
        /// RPC Call 4: Finally, get token name and token symbol for new token events
        switch self.chainId {
        case ChainID.zora:
            let newTokenAddresses = newTokenEvents.map { event in
                event.contractAddress
            }
            let tokenInfos = try await rpc.getTokenInfos(contractAddresses: newTokenAddresses)
            newTokenEventsWithTokenInfo = newTokenEvents.map({ newTokenEvent in
                var newTokenEventWithTokenInfo = newTokenEvent
                newTokenEventWithTokenInfo.tokenName = tokenInfos[newTokenEvent.contractAddress]?.name
                newTokenEventWithTokenInfo.tokenSymbol = tokenInfos[newTokenEvent.contractAddress]?.symbol
                return newTokenEventWithTokenInfo
            })
        case ChainID.eth:
            fatalError("implement getting tokenInfo for eth chain")
        }
        return newTokenEventsWithTokenInfo
    }
    
    func getMetadataEvents(fromBlock: Int, toBlock: Int, forContracts contracts: [String]?) async throws -> [MetadataUpdateEvent] {
        fatalError("implement getMetadataEvents")
    }
    
    func getMintCommentEvents(fromBlock: Int, toBlock: Int, forContracts contracts: [String]?) async throws -> [MintCommentEvent] {
        fatalError("implement getMintCommentEvents")
    }
    
    
}

extension DefaultEventsProvider {
    // MARK: Private method/s
    private func getTokenInfoViaMulticall(newDeploymentEvents: [NewTokenEvent]) async throws -> [NewTokenEvent] {
        /// Create a Multicall to get the token name and symbol for each newly deployed contract address
        /// Note: Multicall only seems to work with ABI functions (`eth_call`) and not any old RPC call
        /// Note: Multicall is **NOT** implemented for Zora so we must use custom batch RPC call for Zora
        var updatedNewDeploymentEvents = newDeploymentEvents
        let multicall = Multicall(client: client)
        var aggregator = Multicall.Aggregator()
        for (index, newDeploymentEvent) in updatedNewDeploymentEvents.enumerated() {
            print("Appending multicalls")
            let contractAddress = EthereumAddress(newDeploymentEvent.contractAddress)
            try aggregator.append(
                function: ERC721MetadataFunctions.name(contract: contractAddress),
                response: ERC721MetadataResponses.nameResponse.self
            ) { result in
                updatedNewDeploymentEvents[index].tokenName = try? result.get()
            }
            try aggregator.append(
                function: ERC721MetadataFunctions.symbol(contract: contractAddress),
                response: ERC721MetadataResponses.symbolResponse.self
            ) { result in
                updatedNewDeploymentEvents[index].tokenSymbol = try? result.get()
            }
        }
        
        do {
            let response = try await multicall.aggregate(calls: aggregator.calls)
            // FIXME: Debugging
            print("Multicall response")
            print(response)
            print(response.outputs)
            return updatedNewDeploymentEvents
        } catch {
            print(error)
            fatalError("Aggregated eth_call failed.")
        }
    }
}
