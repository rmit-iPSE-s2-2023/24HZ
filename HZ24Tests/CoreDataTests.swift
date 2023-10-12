//
// CoreDataTests.swift
// 24HZ
// 
// Created by jin on 2023-09-27
// 



import XCTest
import CoreData
@testable import HZ24

/// Suite to test ``HZ24/CoreDataProvider``
final class CoreDataTests: XCTestCase {
    
    var coreDataProvider: CoreDataProvider!
    var context: NSManagedObjectContext!

    /// Set-up before each test method
    override func setUp() {
        super.setUp()
        self.coreDataProvider = CoreDataProvider.preview
        self.context = coreDataProvider.container.viewContext
        print(coreDataProvider.container.persistentStoreDescriptions)
        do {
            let events = try context.fetch(.init(entityName: "Event"))
            let listeners = try context.fetch(.init(entityName: "Listener"))
            print("Initial events count: \(events.count)")
            print("Initial listeners count: \(listeners.count)")
        } catch {
            print(error)
        }
    }
    
    /// Tear-down after each test method
    override func tearDown() {
        super.tearDown()
        if self.context.hasChanges {
            self.context.reset()
        }
    }
    
    /// Test the pre-configured NSFetchRequest: ``NSFetchRequests/enabledNewTokensListeners``
    func testEnabledNewTokenListenersNSFetchRequest() throws {
        let previewListeners = try self.context.fetch(.init(entityName: "NewTokenListener"))
        let beforeCount = previewListeners.count
        
        /// Create a ``NewTokenListener`` in context
        let newTokenListener = NewTokenListener(context: self.context)
        /// ``Listener`` parent entity attribute/s
        newTokenListener.createdAt = Date()
        newTokenListener.displayTitle = ERCInterfaceId.erc721.displayTitle
        newTokenListener.isListening = true
        /// ``NewTokenListener`` attribute/s
        newTokenListener.ercInterfaceId = ERCInterfaceId.erc721.rawValue
        
        /// Create another ``NewTokenListener`` in context
        let newTokenListener2 = NewTokenListener(context: self.context)
        /// ``Listener`` parent entity attribute/s
        newTokenListener2.createdAt = Date()
        newTokenListener2.displayTitle = ERCInterfaceId.erc20.displayTitle
        newTokenListener2.isListening = false   /// isListening `false` means that this listener is "disabled"
        /// ``NewTokenListener`` attribute/s
        newTokenListener2.ercInterfaceId = ERCInterfaceId.erc20.rawValue
        
        /// Fetch all ``NewTokenListener``/s
        let allNewTokenListeners = try self.context.fetch(.init(entityName: "NewTokenListener"))
        
        XCTAssertEqual(allNewTokenListeners.count, beforeCount + 2)

        /// Fetch **only** ``NewTokenListener``/s that are enabled by the user
        let onlyEnabledNewTokenListeners = try self.context.fetch(NSFetchRequests.enabledNewTokenListeners)
        XCTAssertEqual(onlyEnabledNewTokenListeners.count, beforeCount + 1)
    }
    
    /// Test to ensure NewTokenListeners meet uniqueness constraint on ercInterfaceId and objects in store is updated by objects in context if uniqueness fails
    func testNewTokenListenersAreUnique() throws {
        /// Set the `NSManagedObject`'s `NSMergePolicy`
        self.context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        /// Create a ``NewTokenListener`` in context
        let newTokenListener = NewTokenListener(context: self.context)
        /// ``Listener`` parent entity attribute/s
        newTokenListener.createdAt = Date()
        newTokenListener.displayTitle = ERCInterfaceId.erc721.displayTitle
        newTokenListener.isListening = true
        /// ``NewTokenListener`` attribute/s
        newTokenListener.ercInterfaceId = ERCInterfaceId.erc721.rawValue
        try context.save()
        var listeners: [NewTokenListener] = try context.fetch(.init(entityName: "NewTokenListener"))
        XCTAssertEqual(listeners.count, 2)
        /// Create another ``NewTokenListener`` in context
        let newTokenListener2 = NewTokenListener(context: self.context)
        /// ``Listener`` parent entity attribute/s
        newTokenListener2.createdAt = Date()
        newTokenListener2.displayTitle = ERCInterfaceId.erc721.displayTitle
        newTokenListener2.isListening = false   /// NOTE: this second listener created in context has isListening set to false
        /// ``NewTokenListener`` attribute/s
        newTokenListener2.ercInterfaceId = ERCInterfaceId.erc721.rawValue   /// Note: this is the same value as the first listener above
        listeners = try context.fetch(.init(entityName: "NewTokenListener"))
        XCTAssertEqual(listeners.count, 3)
        /// Copying values for newTokenListener2 before saving
//        let copiedId = newTokenListener2.objectID
//        let copiedIsListening = newTokenListener2.isListening
        /// Save the "second" listener
        try context.save()
        listeners = try context.fetch(.init(entityName: "NewTokenListener"))
        print(listeners)
        XCTAssertEqual(listeners.count, 2)
        // FIXME: Ensure that attributes for stored object is updated with the one in the context
//        XCTAssertEqual(listeners.first!.isListening, copiedIsListening)
//        XCTAssertEqual(listeners.first!.objectID, copiedId)
    }
    
    /// Test the pre-configured NSFetchRequest: ``NSFetchRequests/metadataEnabledExistingTokenListeners``
    func testmetadataEnabledExistingTokenListenersNSFetchRequest() throws {
        let previewListeners = try self.context.fetch(.init(entityName: "ExistingTokenListener"))
        let beforeCount = previewListeners.count
        
        let existingTokenListener = ExistingTokenListener(context: self.context)
        /// ``Listener`` parent entity attribute/s
        existingTokenListener.createdAt = Date()
        existingTokenListener.displayTitle = "Contract A"
        existingTokenListener.isListening = true
        /// ``NewTokenListener`` attribute/s
        existingTokenListener.contractAddress = "0xa"
        existingTokenListener.listeningForMetadataEvents = true
        existingTokenListener.listeningForMintCommentEvents = true
        
        let existingTokenListener2 = ExistingTokenListener(context: self.context)
        /// ``Listener`` parent entity attribute/s
        existingTokenListener2.createdAt = Date()
        existingTokenListener2.displayTitle = "Contract B"
        existingTokenListener2.isListening = true
        /// ``NewTokenListener`` attribute/s
        existingTokenListener2.contractAddress = "0xb"
        existingTokenListener2.listeningForMetadataEvents = false
        existingTokenListener2.listeningForMintCommentEvents = true
        
        let allExistingTokenListeners = try self.context.fetch(.init(entityName: "ExistingTokenListener"))
        
        XCTAssertEqual(allExistingTokenListeners.count, beforeCount + 2)

        let onlyMetadataEnabledListeners = try self.context.fetch(NSFetchRequests.metadataEnabledExistingTokenListeners)
        
        XCTAssertEqual(onlyMetadataEnabledListeners.count, beforeCount + 1)
    }
    
    /// Test the pre-configured NSFetchRequest: ``NSFetchRequests/mintCommentEnabledExistingTokenListeners``
    func testMintCommentEnabledExistingTokenListenersNSFetchRequest() throws {
        let previewListeners = try self.context.fetch(.init(entityName: "ExistingTokenListener"))
        let beforeCount = previewListeners.count
        
        /// Create 2 new ``ExistingTokenListener`` entities
        ///
        /// 1) ``ExistingTokenListener`` with `\.listeningforMintCommentEvents` set to `true`
        let existingTokenListener = ExistingTokenListener(context: self.context)
        /// ``Listener`` parent entity attribute/s
        existingTokenListener.createdAt = Date()
        existingTokenListener.displayTitle = "Contract A"
        existingTokenListener.isListening = true
        /// ``NewTokenListener`` attribute/s
        existingTokenListener.contractAddress = "0xa"
        existingTokenListener.listeningForMetadataEvents = true
        existingTokenListener.listeningForMintCommentEvents = true
        
        /// 2) ``ExistingTokenListener`` with `\.listeningforMintCommentEvents` set to `false`
        let existingTokenListener2 = ExistingTokenListener(context: self.context)
        /// ``Listener`` parent entity attribute/s
        existingTokenListener2.createdAt = Date()
        existingTokenListener2.displayTitle = "Contract B"
        existingTokenListener2.isListening = true
        /// ``NewTokenListener`` attribute/s
        existingTokenListener2.contractAddress = "0xb"
        existingTokenListener2.listeningForMetadataEvents = true
        existingTokenListener2.listeningForMintCommentEvents = false
        
        let allExistingTokenListeners = try self.context.fetch(.init(entityName: "ExistingTokenListener"))
        
        XCTAssertEqual(allExistingTokenListeners.count, beforeCount + 2)
        
        let onlyMintCommentEnabledListeners = try self.context.fetch(NSFetchRequests.mintCommentEnabledExistingTokenListeners)
        
        XCTAssertEqual(onlyMintCommentEnabledListeners.count, beforeCount + 1)
    }
    
    /// Test ``CoreDataProvider/fetchData`` runs with no errors!
    func testFetchData() async throws {
        let listener = ExistingTokenListener(context: self.context)
        listener.contractAddress = "0x8fcfdad5ebdd1ce815aa769bbd7499091ac056d1"
        listener.listeningForMetadataEvents = true
        listener.isListening = true
        listener.listeningForMintCommentEvents = true
        try await coreDataProvider.fetchData()
        let events = try context.fetch(.init(entityName: "Event"))
        print(events)
    }
    
}
