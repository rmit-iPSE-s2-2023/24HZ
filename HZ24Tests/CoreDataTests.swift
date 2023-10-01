//
// CoreDataTests.swift
// 24HZ
// 
// Created by jin on 2023-09-27
// 



import XCTest
import CoreData
@testable import HZ24

final class CoreDataTests: XCTestCase {
    
    var coreDataProvider: CoreDataProvider!
    var context: NSManagedObjectContext!

    override func setUp() {
        super.setUp()
        self.coreDataProvider = CoreDataProvider.preview
        self.context = coreDataProvider.container.viewContext
        print(coreDataProvider.container.persistentStoreDescriptions)
    }
    
    func testPreviewEntities() throws {
        let previewListeners = try self.context.fetch(.init(entityName: "Listener"))
        XCTAssertEqual(previewListeners.count, 1)
    }
    
    /// Trivial test to just make sure Core Data is playing nicely and project is building properly
    func testSavingNewTokenListener() throws {
        var newTokenListeners: [NewTokenListener]
        /// Initially, there should only be ONE NewTokenListeners in store
        newTokenListeners = try self.context.fetch(.init(entityName: "NewTokenListener"))
        XCTAssertFalse(self.context.hasChanges)
        XCTAssertEqual(newTokenListeners.count, 1)
        let newTokenListener = NewTokenListener(context: self.context)
        /// MO: Listener property/s
        newTokenListener.createdAt = Date()
        newTokenListener.displayTitle = ERCInterfaceId.erc721.displayTitle
        newTokenListener.isListening = true
        /// MO: NewTokenListener property/s
        newTokenListener.ercInterfaceId = ERCInterfaceId.erc721.rawValue
        XCTAssertTrue(self.context.hasChanges)
        newTokenListeners = try self.context.fetch(.init(entityName: "NewTokenListener"))
        XCTAssertEqual(newTokenListeners.count, 2)
        print(newTokenListener)
        newTokenListeners.forEach { newTokenListener in
            print(newTokenListener.ercInterfaceId ?? "no ercInterfaceId")
        }
    }
    
    func testEnabledNewTokenListenersNSFetchRequest() throws {
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
        XCTAssertEqual(allNewTokenListeners.count, 3)
        /// Fetch all ``Listener``/s
        let allListeners = try self.context.fetch(.init(entityName: "Listener"))
        XCTAssertEqual(allListeners.count, 3)   // This test ensures parent-child entities are working as intended
        /// Fetch **only** ``NewTokenListener``/s that are enabled by the user
        let onlyEnabledNewTokenListeners = try self.context.fetch(NSFetchRequests.enabledNewTokenListeners)
        XCTAssertEqual(onlyEnabledNewTokenListeners.count, 2)
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
        let copiedId = newTokenListener2.objectID
        let copiedIsListening = newTokenListener2.isListening
        /// Save the "second" listener
        try context.save()
        listeners = try context.fetch(.init(entityName: "NewTokenListener"))
        print(listeners)
        XCTAssertEqual(listeners.count, 2)
        // FIXME: Ensure that attributes for stored object is updated with the one in the context
//        XCTAssertEqual(listeners.first!.isListening, copiedIsListening)
//        XCTAssertEqual(listeners.first!.objectID, copiedId)
    }
    
    func testmetadataEnabledExistingTokenListenersNSFetchRequest() throws {
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
        XCTAssertEqual(allExistingTokenListeners.count, 2)
        let allListeners = try self.context.fetch(.init(entityName: "Listener"))
        XCTAssertEqual(allListeners.count, 3)
        let onlyMetadataEnabledListeners = try self.context.fetch(NSFetchRequests.metadataEnabledExistingTokenListeners)
        print(onlyMetadataEnabledListeners)
        XCTAssertEqual(onlyMetadataEnabledListeners.count, 1)
    }
    
    func testMintCommentEnabledExistingTokenListenersNSFetchRequest() throws {
        /// Create 2 new ``ExistingTokenListener`` entities
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
        XCTAssertEqual(allExistingTokenListeners.count, 2)
        let allListeners = try self.context.fetch(.init(entityName: "Listener"))
        XCTAssertEqual(allListeners.count, 3)
        let onlyMintCommentEnabledListeners = try self.context.fetch(NSFetchRequests.mintCommentEnabledExistingTokenListeners)
        print(onlyMintCommentEnabledListeners)
        XCTAssertEqual(onlyMintCommentEnabledListeners.count, 1)
    }
    
    func testFetchData() async throws {
        try await coreDataProvider.fetchData()
    }
    
    func testFetchDataWithNewTokenListener() async throws {
//        let newTokenListener = NewTokenListener(context: self.context)
//        newTokenListener.
        try await coreDataProvider.fetchData()
    }
}
