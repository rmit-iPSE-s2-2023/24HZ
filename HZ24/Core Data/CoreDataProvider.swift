//
// CoreDataProvider.swift
// 24HZ
// 
// Created by jin on 2023-09-26
// 



import Foundation
import CoreData

class CoreDataProvider {
    // MARK: Core Data
    private let inMemory: Bool
    
    /// NSPersistentContainer contains:
    /// - managed object context (viewContext)
    /// - persistent store coordinator
    /// - managed object model
    /// - persistent store (persistentStoreDescriptions)
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("Failed to retrieve a persistent store description.")
        }
        if self.inMemory {
            description.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    /// APIs to retrieve new data
    let eventsProvider: EventsProvider
    /// Number of blocks to query for a full fetch
    /// Note: In production, this should equate to 24 hours. With limitations of using a free API, 1000 is set as it is the max batch JSON-RPC size limit for ``ThirdWebRPC``
    let fullFetchBlockRange: Int = 1000
    
    // MARK: Singleton/s
    /// Shared singleton (on-disk)
    static let shared = CoreDataProvider()
    /// Preview singleton (in-memory)
    /// - to add test data for preview
    static var preview: CoreDataProvider = {
        let provider = CoreDataProvider(inMemory: true)
        let viewContext = provider.container.viewContext
        
        // TODO: Create dummy ``Event``/s e.g. fetch events from last 1000 blocks?
        /// Add preview ``NewTokenListener``/s
        PreviewModels.makePreviewERC20Listener(viewContext: viewContext)

        /// Add sample ``ExistingTokenListener``
        let existingTokenListener = ExistingTokenListener(context: viewContext)
        /// ``Listener`` parent entity attribute/s
        existingTokenListener.createdAt = Date()
        existingTokenListener.displayTitle = "Opepen Threadition"
        existingTokenListener.isListening = true
        /// ``ExistingTokenListener`` attribute/s
        existingTokenListener.contractAddress = "0x6d2C45390B2A0c24d278825c5900A1B1580f9722"
        existingTokenListener.listeningForMetadataEvents = true
        existingTokenListener.listeningForMintCommentEvents = true
        existingTokenListener.tokenName = "Opepen Threadition"
        existingTokenListener.tokenSymbol = ""
        
        /// Add sample ``NewTokenEvent``
        let newTokenEvent = NewTokenEvent(context: viewContext)
        /// ``Event`` parent entity attribute/s
        newTokenEvent.blockHash = "0x"
        newTokenEvent.blockNumber = Int64(1)
        newTokenEvent.contractAddress = "0xabc"
        newTokenEvent.ercInterfaceId = ERCInterfaceId.erc20.rawValue
        newTokenEvent.id = UUID()
        newTokenEvent.saved = false
        newTokenEvent.timestamp = Date()
        newTokenEvent.tokenName = "Preview Token1"
        newTokenEvent.tokenSymbol = "PRE"
        newTokenEvent.transactionHash = "0x"
        /// ``NewTokenEvent`` attribute/s
        newTokenEvent.deployerAddress = "0xdeployer"
        
        /// Save to store
        try! viewContext.save()
        // e.g. CapturedEvent.makePreviews()
        return provider
    }()
    
    // MARK: Initializer
    init(inMemory: Bool = false) {
        self.inMemory = inMemory
        eventsProvider = DefaultEventsProvider<ThirdWebRPC>.zora()
    }
}

extension CoreDataProvider {
    // MARK: Error/s
    enum CoreDataProviderError: Error {
        case rpcFetchError(msg: String)
        case noEventsCaptured
    }
}

extension CoreDataProvider {
    /// Fetches events for all event listeners that the user is listening to, and imports it into Core Data.
    // FIXME: At the moment, it just assumes there is no events fetched at all. This must be fixed to only query blocks that have not been queried already.
    func fetchData() async throws {
        let context = self.container.viewContext
        
        // FIXME: Should only fetch events for the blocks that haven't been queried, but we are just deleting all events and fetching events in the last 1000 blocks for simplicity
        /// Delete all events
        let events: [Event] = try context.fetch(.init(entityName: "Event"))
        for event in events {
            context.delete(event)
        }
        
        // MARK: Block range
        /// Firstly, establish the block range to query for new events
        /// EventsProvider Call 1: Get current block number
        guard let currentBlockNumber = try? await self.eventsProvider.getCurrentBlockNumber() else {
            throw CoreDataProviderError.rpcFetchError(msg: "fetchData: Failed to fetch current block number.")
        }
        let fromBlock = currentBlockNumber - self.fullFetchBlockRange + 1
        /// Secondly, make 3 calls to the ``EventsProvider`` to get ``NewTokenEvent``/s, ``MetadataEvent``/s, and ``MintCommentEvent``/s
        // FIXME: Should make background context; just using viewContext for now
        
        /// Fetch ``NewTokenEvent``/s (if any)
        try await fetchNewTokenEvents(currentBlockNumber)
        
        /// Fetch ``MetadataEvent``/s (if any)
        try await fetchMetadataEvents(currentBlockNumber)
        
        /// Fetch ``MintCommentEvent``/s (if any)
        try await fetchMintCommentEvents(currentBlockNumber)

        /// Save current viewContext to persistent container
        if context.hasChanges {
            try context.save()
        } else {
            print("Context does not have any changes. Skipped saving.")
        }
    }
    
    private func fetchNewTokenEvents(_ upToBlock: Int?) async throws {
        let context = self.container.viewContext
        
        // MARK: Fetch listeners
        /// 1) Getting ``NewTokenEvent``/s
        /// Fetch ``NewTokenListener``/s where isListening is true
        let newTokenListeners: [NewTokenListener] = try context.fetch(NSFetchRequests.enabledNewTokenListeners)
        /// Map ``NewTokenListener``/s to intefaceIds: [Data]
        let interfaceIds = newTokenListeners.compactMap { newTokenListener in
            return newTokenListener.ercInterfaceId!.web3.hexData!
        }
        /// Return early if no listeners found
        if newTokenListeners.isEmpty {
            print("No NewTokenListener/s found.")
            return
        }
        
        // MARK: Block range
        /// Firstly, establish the block range to query for new events
        /// EventsProvider Call 1: Get current block number
        var toBlock: Int
        if let unwrapped = upToBlock {
            toBlock = unwrapped
        } else {
            guard let result = try? await self.eventsProvider.getCurrentBlockNumber() else {
                throw CoreDataProviderError.rpcFetchError(msg: "fetchNewTokenEvents: Failed to fetch current block number.")
            }
            toBlock = result
        }
        let fromBlock = toBlock - self.fullFetchBlockRange + 1

        do {
            /// EventsProvider Call 2: Get ``NewTokenEventStruct``/s
            let newTokenEventStructs = try await self.eventsProvider.getNewTokenEvents(fromBlock: fromBlock, toBlock: toBlock, forInterfaces: interfaceIds)
            print("New token events captured: \(newTokenEventStructs.count)")
            
            /// Create ``NewTokenEvent`` Core Data managed objects for each ``NewTokenEventStruct``
            for newTokenEventStruct in newTokenEventStructs {
                /// Create ``NewTokenEvent`` MO in context
                let newTokenEvent = NewTokenEvent(context: self.container.viewContext)
                /// Set ``Event`` parent entity attribute/s:
                newTokenEvent.blockHash = newTokenEventStruct.blockHash
                newTokenEvent.blockNumber = Int64(newTokenEventStruct.blockNumber.dropFirst(2), radix: 16)!
                newTokenEvent.contractAddress = newTokenEventStruct.contractAddress
                newTokenEvent.id = UUID()
                newTokenEvent.saved = false
                newTokenEvent.timestamp = newTokenEventStruct.timestamp
                newTokenEvent.tokenName = newTokenEventStruct.tokenName
                newTokenEvent.tokenSymbol = newTokenEventStruct.tokenSymbol
                newTokenEvent.transactionHash = newTokenEventStruct.txHash
                /// Set ``Event`` parent entity relationship/s
                newTokenEvent.capturedBy = newTokenListeners.first(where: { newTokenListener in
                    return newTokenListener.ercInterfaceId == newTokenEventStruct.ercInterfaceId.rawValue
                })
                /// Set ``NewTokenEvent`` attribute/s
                newTokenEvent.deployerAddress = newTokenEventStruct.deployerAddress
            }
        } catch {
            print(error)
        }
    }
    
    private func fetchMetadataEvents(_ upToBlock: Int?) async throws {
        let context = self.container.viewContext

        // MARK: Fetch listeners
        /// Fetch ``ExistingTokenListener``/s where listeningForMetadata is true
        let metadataListeners = try context.fetch(NSFetchRequests.metadataEnabledExistingTokenListeners)
        let metadataListenerContractAddresses = metadataListeners.map { metadataListener in
            return metadataListener.contractAddress!
        }
        /// Return early if no listeners found
        if metadataListeners.isEmpty {
            print("No ExistingTokenListener/s for MetadataEvent/s found.")
            return
        }
        
        // MARK: Block range
        /// Firstly, establish the block range to query for new events
        /// EventsProvider Call 1: Get current block number
        var toBlock: Int
        if let unwrapped = upToBlock {
            toBlock = unwrapped
        } else {
            guard let result = try? await self.eventsProvider.getCurrentBlockNumber() else {
                throw CoreDataProviderError.rpcFetchError(msg: "fetchMetadataEvents: Failed to fetch current block number.")
            }
            toBlock = result
        }
        let fromBlock = toBlock - self.fullFetchBlockRange + 1
        
        do {
            /// EventsProvider Call 3: Get ``MetadataEventStruct``/s
            let metadataEventStructs = try await self.eventsProvider.getMetadataEvents(fromBlock: fromBlock, toBlock: toBlock, forContracts: metadataListenerContractAddresses)
            print("New metadata events captured: \(metadataEventStructs.count)")
            for metadataEventStruct in metadataEventStructs {
                /// Create ``MetadataEvent`` in context
                let metadataEvent = MetadataEvent(context: context)
                /// Set ``Event`` parent entity attribute/s:
                metadataEvent.blockHash = metadataEventStruct.blockHash
                metadataEvent.blockNumber = Int64(metadataEventStruct.blockNumber.dropFirst(2), radix: 16)!
                metadataEvent.contractAddress = metadataEventStruct.contractAddress
                metadataEvent.id = UUID()
                metadataEvent.saved = false
                metadataEvent.timestamp = Date()    // TODO: This should be timestamp of event's block
                metadataEvent.tokenName = metadataEventStruct.tokenName
                metadataEvent.tokenSymbol = metadataEventStruct.tokenSymbol
                metadataEvent.transactionHash = metadataEventStruct.txHash
                /// Set ``Event`` parent entity relationship/s
                metadataEvent.capturedBy = metadataListeners.first(where: { metadataListener in
                    return metadataListener.contractAddress == metadataEventStruct.contractAddress
                })
                /// Set ``MetadataEvent`` attribute/s
                metadataEvent.abiEventName = metadataEventStruct.abiEventName
                metadataEvent.updatedAnimationURI = metadataEventStruct.updatedAnimationURI
                metadataEvent.updatedContractURI = metadataEventStruct.updatedContractURI
                metadataEvent.updatedFreezeAt = metadataEventStruct.updatedFreezeAt ?? 0
                metadataEvent.updatedImageURI = metadataEventStruct.updatedImageURI
                metadataEvent.updatedMetadataBase = metadataEventStruct.updatedMetadataBase
                metadataEvent.updatedMetadataExtension = metadataEventStruct.updatedMetadataExtension
                metadataEvent.updatedName = metadataEventStruct.updatedName
                metadataEvent.updatedNewDescription = metadataEventStruct.updatedNewDescription
                metadataEvent.updatedURI = metadataEventStruct.updatedURI
            }
        } catch {
            print(error)
        }
    }
    
    private func fetchMintCommentEvents(_ upToBlock: Int?) async throws {
        let context = self.container.viewContext
        
        // MARK: Fetch listeners
        /// 3) Getting ``MintCommentEvent``/s
        let mintCommentListeners = try context.fetch(NSFetchRequests.mintCommentEnabledExistingTokenListeners)
        let mintCommentListenerContractAddresses = mintCommentListeners.map { mintCommentListener in
            return mintCommentListener.contractAddress!
        }
        /// Return early if no listeners found
        if mintCommentListeners.isEmpty {
            print("No ExistingTokenListener/s for MintCommentEvent/s found.")
            return
        }
        
        // MARK: Block range
        /// Firstly, establish the block range to query for new events
        /// EventsProvider Call 1: Get current block number
        var toBlock: Int
        if let unwrapped = upToBlock {
            toBlock = unwrapped
        } else {
            guard let result = try? await self.eventsProvider.getCurrentBlockNumber() else {
                throw CoreDataProviderError.rpcFetchError(msg: "fetchMintCommentEvents: Failed to fetch current block number.")
            }
            toBlock = result
        }
        let fromBlock = toBlock - self.fullFetchBlockRange + 1
        
        do {
            /// EventsProvider Call: Get ``MintCommentEventStruct``/s
            let mintCommentEventStructs = try await self.eventsProvider.getMintCommentEvents(fromBlock: fromBlock, toBlock: toBlock, forContracts: mintCommentListenerContractAddresses)
            print("New mint comment events captured: \(mintCommentEventStructs.count)")
            for mintCommentEventStruct in mintCommentEventStructs {
                /// Associate ``Event`` with corresponding ``Listener``
                let listener = mintCommentListeners.first(where: { mintCommentListener in
                    return mintCommentListener.contractAddress == mintCommentEventStruct.contractAddress
                })!
                /// Create ``MintCommentEvent`` in context
                let mintEvent = MintCommentEvent(context: context)
                /// Set ``Event`` parent entity attribute/s:
                mintEvent.blockHash = mintCommentEventStruct.blockHash
                mintEvent.blockNumber = mintCommentEventStruct.blockNumber
                mintEvent.contractAddress = mintCommentEventStruct.contractAddress
                mintEvent.id = UUID()
                mintEvent.saved = false
                mintEvent.timestamp = mintCommentEventStruct.timestamp    // TODO: This should be timestamp of event's block
                mintEvent.tokenName = listener.tokenName
                mintEvent.tokenSymbol = listener.tokenSymbol
                mintEvent.transactionHash = mintCommentEventStruct.txHash
                /// Set ``Event`` parent entity relationship/s
                mintEvent.capturedBy = listener
                /// Set ``MintCommentEvent`` attribute/s
                mintEvent.abiEventName = mintCommentEventStruct.abiEventName
                mintEvent.mintComment = mintCommentEventStruct.mintComment
                mintEvent.quantity = mintCommentEventStruct.quantity ?? 0
                mintEvent.sender = mintCommentEventStruct.sender
            }
        } catch {
            print(error)
        }
    }
}
