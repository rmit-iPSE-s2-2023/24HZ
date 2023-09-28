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
        // TODO: Create dummy CapturedEvents e.g. fetch events from last 1000 blocks?
        // e.g. CapturedEvent.makePreviews()
        return provider
    }()
    
    // MARK: Initializer
    init(inMemory: Bool = false) {
        self.inMemory = inMemory
        eventsProvider = DefaultEventsProvider.zora
    }
}

extension CoreDataProvider {
    // MARK: Error/s
    enum CoreDataError: Error {
        case rpcFetchError(msg: String)
        case noEventsCaptured
    }
}

extension CoreDataProvider {
    /// Fetches events for all event listeners that the user is listening to, and imports it into Core Data.
    // FIXME: At the moment, it just assumes there is no events fetched at all. This must be fixed to only query blocks that have not been queried already.
    func fetchData() async throws {
        /// Firstly, establish the block range to query for new events
        /// EventsProvider Call 1: Get current block number
        guard let currentBlockNumber = try? await self.eventsProvider.getCurrentBlockNumber() else {
            throw CoreDataError.rpcFetchError(msg: "fetchData: Failed to fetch current block number.")
        }
        let fromBlock = currentBlockNumber - self.fullFetchBlockRange + 1
        /// Secondly, make 3 calls to the ``EventsProvider`` to get ``NewTokenEvent``/s, ``MetadataEvent``/s, and ``MintCommentEvent``/s
        // FIXME: Should make background context; just using viewContext for now
        let context = self.container.viewContext
        /// 1) Getting ``NewTokenEvent``/s
        /// Fetch ``NewTokenListener``/s where isListening is true
        let newTokenListeners: [NewTokenListener] = try context.fetch(NSFetchRequests.enabledNewTokenListeners)
        /// Map ``NewTokenListener``/s to intefaceIds: [Data]
        let interfaceIds = newTokenListeners.compactMap { newTokenListener in
            return newTokenListener.ercInterfaceId!.web3.hexData!
        }
        /// EventsProvider Call 2: Get ``NewTokenEventStruct``/s
        do {
            let newTokenEventStructs = try await self.eventsProvider.getNewTokenEvents(fromBlock: fromBlock, toBlock: currentBlockNumber, forInterfaces: interfaceIds)
            print("New token events captured: \(newTokenEventStructs.count)")
            /// Create ``NewTokenEvent`` Core Data managed objects  for each ``NewTokenEventStruct``
            for newTokenEventStruct in newTokenEventStructs {
                /// Create ``NewTokenEvent`` MO in context
                let newTokenEvent = NewTokenEvent(context: self.container.viewContext)
                /// Set ``Event`` parent entity attribute/s:
                newTokenEvent.blockHash = newTokenEventStruct.blockHash
                newTokenEvent.blockNumber = Int64(newTokenEventStruct.blockNumber.dropFirst(2), radix: 16)!
                newTokenEvent.contractAddress = newTokenEventStruct.contractAddress
                newTokenEvent.id = UUID()
                newTokenEvent.saved = false
                newTokenEvent.timestamp = Date()    // TODO: This should be timestamp of event's block
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
        /// 2) Getting ``MetadataEvent``/s
        /// Fetch ``ExistingTokenListener``/s where listeningForMetadata is true
        let metadataListeners = try context.fetch(NSFetchRequests.metadataEnabledExistingTokenListeners)
        let metadataListenerContractAddresses = metadataListeners.map { metadataListener in
            return metadataListener.contractAddress!
        }
        do {
            /// EventsProvider Call 3: Get ``MetadataEventStruct``/s
            let metadataEventStructs = try await self.eventsProvider.getMetadataEvents(fromBlock: fromBlock, toBlock: currentBlockNumber, forContracts: metadataListenerContractAddresses)
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

        }
        
        
        /// Save current viewContext to persistent container
        try self.container.viewContext.save()
    }
}
