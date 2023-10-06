//
// DefaultEventsProvider.swift
// 24HZ
// 
// Created by jin on 2023-09-24
// 


import Foundation
import web3

/// Default implementation of ``EventsProvider``
/// This implementation of ``EventsProvider`` uses the `web3.swift` Swift Package for some Ethereum convenience methods:
/// - Encoding/decoding hex data; hexadecimal (base-16) format
/// - ABIType abstractions
/// - RPC call abstractions
/// Most RPC calls are made using custom batch JSON-RPC methods provided by an ``RPCProtocol`` adopter
class DefaultEventsProvider : EventsProvider {
    
    // MARK: Property/s
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
    // MARK: Error/s
    enum EventsProviderError: Error {
        case rpcError(message: String)
        case encodeError(message: String)
        case multicallError(message: String)
    }
}

extension DefaultEventsProvider {
    // MARK: Protocol method implementation/s
    ///Default implementation of ``EventsProvider/getCurrentBlockNumber()``
    func getCurrentBlockNumber() async throws -> Int {
        let currentBlock = try await self.client.eth_blockNumber()
        return currentBlock
    }
    
    /// Default implementation of ``EventsProvider/getNewTokenEvents(fromBlock:toBlock:forInterfaces:)``
    func getNewTokenEvents(fromBlock: Int, toBlock: Int, forInterfaces interfaceIds: [Data]) async throws -> [NewTokenEventStruct] {
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
        /// TransactionReceipts contain the contractAddress if the transaction created a new contract. Unfortunately, the transaction objects returned in RPC Call1 does not include this info.
        guard let deployTxReceipts = try? await rpc.getTransactionReceipts(txHashes: deployTxHashes) else {
            throw EventsProviderError.rpcError(message: "rpc.getTransactionReceipts failed.")
        }
        /// RPC Call3: Filter ``TransactionReceiptObject``/s that support one of ``ERCInterfaceId``
        let deployContractAddresses = deployTxReceipts.map { txReceipt in
            txReceipt.contractAddress
        }
        print("DEBUG: deployContractAddresses: \(deployContractAddresses)")
        /// Returns dictionary keyed by contract address and ``InterfaceInfo`` value
        let tokenContracts = try await rpc.filterContractsWithInterfaceSupport(contractAddresses: deployContractAddresses, interfaceIds: interfaceIds)
        /// Filter txReceipts checking if its contractAddress is a key in tokenContracts
        let newTokenEvents: [NewTokenEventStruct] = deployTxReceipts.compactMap { txReceipt -> NewTokenEventStruct? in
            if let interfaceInfo = tokenContracts[txReceipt.contractAddress] {
                let newTokenEvent = NewTokenEventStruct(ercInterfaceId: interfaceInfo.ercInterfaceId, contractAddress: txReceipt.contractAddress, blockNumber: txReceipt.blockNumber, blockHash: txReceipt.blockHash, txHash: txReceipt.transactionHash, deployerAddress: txReceipt.from)
                return newTokenEvent
            } else {
                return nil
            }
        }
        /// Create array to store ``NewDeploymentEvent``/s
        // FIXME: Instead of creating a new array we could potentially do this with inout
        var newTokenEventsWithTokenInfo: [NewTokenEventStruct] = []
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
    
    /// Default Implementation of ``EventsProvider/getMetadataEvents(fromBlock:toBlock:forContracts:)``
    func getMetadataEvents(fromBlock: Int, toBlock: Int, forContracts contracts: [String]?) async throws -> [MetadataEventStruct] {
        /// Create an array of relevant event types conforming to ``ABIEvent``
        var abiEventTypes: [ABIEvent.Type] = []
        abiEventTypes.append(MetadataEventABI.ContractMetadataUpdated.self)
        abiEventTypes.append(MetadataEventABI.DescriptionUpdated.self)
        abiEventTypes.append(MetadataEventABI.MediaURIsUpdated.self)
        abiEventTypes.append(MetadataEventABI.MetadataUpdated.self)
        /// Create array of function signatures for orTopics
        let signatures = try abiEventTypes.map { abiEventType in
            return try abiEventType.signature()
        }
        /// Create array of encoded contract addresses for contracts
        var encodedContractAddresses = [String]()
        if let validContracts = contracts {
            encodedContractAddresses = try validContracts.map { contractAddress -> String in
                guard let encodedAddress = try? ABIEncoder.encode(EthereumAddress(contractAddress)).bytes else {
                    throw EventsProviderError.encodeError(message: "Ethereum address encoding fail")
                }
                return String(hexFromBytes: encodedAddress)
            }
        }
        /// Create orTopics array
        let orTopics = [signatures, encodedContractAddresses]
        /// Download
        let result = try await client.getEvents(addresses: nil, orTopics: orTopics, fromBlock: EthereumBlock(rawValue: fromBlock), toBlock: EthereumBlock(rawValue: toBlock), eventTypes: abiEventTypes)
        /// Wrangle
        let events = result.events
        guard !events.isEmpty else {
            print("No events found.")
            return []
        }
        print("getMetadataEvents result.events.count: \(events.count)")
        print("getMetadataEvents result.logs.count: \(result.logs.count)")
        let metadataEventStructs: [MetadataEventStruct] = events.map { event -> MetadataEventStruct in
            /// Downcast ABIEvent to subtypes to access instance properties
            /// - get token contract address
            // FIXME: Maybe switch is better here -> Don't have to use .zero if there is a default case with fatalerror or throw?
            var metadataEventStruct = MetadataEventStruct(contractAddress: "", blockNumber: event.log.blockNumber.stringValue, blockHash: event.log.blockHash, txHash: event.log.transactionHash, abiEventName: "")
            if let descriptionUpdatedEvent: MetadataEventABI.DescriptionUpdated = event as? MetadataEventABI.DescriptionUpdated {
                metadataEventStruct.contractAddress = descriptionUpdatedEvent.target.asString()
                metadataEventStruct.abiEventName = MetadataEventABI.DescriptionUpdated.name
                metadataEventStruct.updatedNewDescription = descriptionUpdatedEvent.newDescription
            } else if let mediaURIsUpdatedEvent: MetadataEventABI.MediaURIsUpdated = event as? MetadataEventABI.MediaURIsUpdated {
                metadataEventStruct.contractAddress = mediaURIsUpdatedEvent.target.asString()
                metadataEventStruct.abiEventName = MetadataEventABI.MediaURIsUpdated.name
                metadataEventStruct.updatedAnimationURI = mediaURIsUpdatedEvent.animationURI
                metadataEventStruct.updatedImageURI = mediaURIsUpdatedEvent.imageURI
            } else if let contractMetadataUpdatedEvent: MetadataEventABI.ContractMetadataUpdated = event as? MetadataEventABI.ContractMetadataUpdated {
                metadataEventStruct.contractAddress = contractMetadataUpdatedEvent.updated.asString()
                metadataEventStruct.abiEventName = MetadataEventABI.ContractMetadataUpdated.name
                metadataEventStruct.updatedURI = contractMetadataUpdatedEvent.uri
                metadataEventStruct.updatedName = contractMetadataUpdatedEvent.name
            } else if let metadataUpdatedEvent: MetadataEventABI.MetadataUpdated = event as? MetadataEventABI.MetadataUpdated {
                metadataEventStruct.contractAddress = metadataUpdatedEvent.target.asString()
                metadataEventStruct.abiEventName = MetadataEventABI.MetadataUpdated.name
                metadataEventStruct.updatedContractURI = metadataUpdatedEvent.contractURI
                metadataEventStruct.updatedFreezeAt = Int64(exactly: metadataUpdatedEvent.freezeAt)
                metadataEventStruct.updatedMetadataBase = metadataUpdatedEvent.metadataBase
                metadataEventStruct.updatedMetadataExtension = metadataUpdatedEvent.metadataExtension
            }
            return metadataEventStruct
        }
        /// Create dictionary to return results keyed by contract address
//        var eventsDict: [String: [MetadataEventStruct]] = [:]
//
//        metadataUpdateEvents.forEach { metadataUpdateEvent in
//            eventsDict[metadataUpdateEvent.contractAddress, default: []].append(metadataUpdateEvent)
//        }
//        return eventsDict
        return metadataEventStructs
        /// Note: tokenName and tokenSymbol should be fetched when user adds new listener for a specified contract address.
    }
    
    /// Default Implementation of ``EventsProvider/getMintCommentEvents(fromBlock:toBlock:forContracts:)``
    func getMintCommentEvents(fromBlock: Int, toBlock: Int, forContracts contracts: [String]?) async throws -> [MintCommentEventStruct] {
        /// ABIEvent types that are relevant to Mint with Comments
        var abiEventTypes = [ABIEvent.Type]()
        abiEventTypes.append(MintCommentEventABI.MintComment.self)
        /// Array of function signatures to use as orTopics parameter in RPC call
        let signatures = try abiEventTypes.map { abiEventType in
            return try abiEventType.signature()
        }
        /// Array of encoded contract addresses for contracts
        var encodedContractAddresses = [String]()
        if let validContracts = contracts {
            encodedContractAddresses = try validContracts.map { contractAddress -> String in
                guard let encodedAddress = try? ABIEncoder.encode(EthereumAddress(contractAddress)).bytes else {
                    throw EventsProviderError.encodeError(message: "Ethereum address encoding fail")
                }
                return String(hexFromBytes: encodedAddress)
            }
        }
        /// orTopics array
        let orTopics = [signatures, [], encodedContractAddresses]
        /// RPC Call to get relevant events
        let result = try await client.getEvents(addresses: nil, orTopics: orTopics, fromBlock: EthereumBlock(rawValue: fromBlock), toBlock: EthereumBlock(rawValue: toBlock), eventTypes: abiEventTypes)
        /// Array of filtered ABIEvents
        let events = result.events
        // FIXME: Debugging
        print("getMintCommentEvents result.events.count: \(events.count)")
        print("getMintCommentEvents result.logs.count: \(result.logs.count)")
        let mintCommentEvents: [MintCommentEventStruct] = events.compactMap { event -> MintCommentEventStruct? in
            /// Downcast ABIEvent to subtypes to access instance properties:
            /// - get comment
            /// - get quantity
            var mintCommentEventStruct = MintCommentEventStruct(contractAddress: event.log.address.asString(), blockNumber: event.log.blockNumber.stringValue, abiEventName: "")
            if let mintCommentEvent: MintCommentEventABI.MintComment = event as? MintCommentEventABI.MintComment {
                mintCommentEventStruct.mintComment = mintCommentEvent.comment
                mintCommentEventStruct.quantity = Int64(exactly: mintCommentEvent.quantity)
                mintCommentEventStruct.abiEventName = MintCommentEventABI.MintComment.name
                return mintCommentEventStruct
            } else {
                return nil
            }
        }
        return mintCommentEvents
        /// Create dictionary to return results keyed by contract address
//        var eventsDict: [String: [MintCommentEventStruct]] = [:]
//
//        mintCommentEvents.forEach { mintCommentEvent in
//            eventsDict[mintCommentEvent.contractAddress, default: []].append(mintCommentEvent)
//        }
//        return eventsDict
        /// Note: tokenName and tokenSymbol should be fetched when user adds new listener for a specified contract address.
    }
}

extension DefaultEventsProvider {
    // MARK: Private method/s
    private func getTokenInfoViaMulticall(newDeploymentEvents: [NewTokenEventStruct]) async throws -> [NewTokenEventStruct] {
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
