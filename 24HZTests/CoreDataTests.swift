//
// CoreDataTests.swift
// 24HZ
// 
// Created by jin on 2023-09-27
// 



import XCTest
import CoreData
@testable import _4HZ

final class CoreDataTests: XCTestCase {
    
    var coreDataProvider: CoreDataProvider!
    var context: NSManagedObjectContext!

    override func setUp() {
        super.setUp()
        coreDataProvider = CoreDataProvider.preview
        context = coreDataProvider.container.viewContext
        print(coreDataProvider.container.persistentStoreDescriptions)
    }
    
    /// Trivial test to just make sure Core Data is playing nicely and project is building properly
    func testSavingNewTokenListener() throws {
        var newTokenListeners: [NewTokenListener]
        /// Initially, there should be no NewTokenListeners in store
        newTokenListeners = try self.context.fetch(.init(entityName: "NewTokenListener"))
        XCTAssertFalse(self.context.hasChanges)
        XCTAssertEqual(newTokenListeners.count, 0)
        let newTokenListener = NewTokenListener(context: self.context)
        /// MO: Listener property/s
        newTokenListener.id = UUID()
        newTokenListener.isListening = true
        /// MO: NewTokenListener property/s
        newTokenListener.ercInterfaceId = ERCInterfaceId.erc721.rawValue
        XCTAssertTrue(self.context.hasChanges)
        newTokenListeners = try self.context.fetch(.init(entityName: "NewTokenListener"))
        XCTAssertEqual(newTokenListeners.count, 1)
        print(newTokenListener)
        newTokenListeners.forEach { newTokenListener in
            print(newTokenListener.ercInterfaceId ?? "no ercInterfaceId")
        }
    }
    
    func testEnabledNewTokenListenersNSFetchRequest() throws {
        let newTokenListener = NewTokenListener(context: self.context)
        /// MO: Listener property/s
        newTokenListener.id = UUID()
        newTokenListener.isListening = true
        /// MO: NewTokenListener property/s
        newTokenListener.ercInterfaceId = ERCInterfaceId.erc721.rawValue
        let newTokenListener2 = NewTokenListener(context: self.context)
        /// MO: Listener property/s
        newTokenListener2.id = UUID()
        newTokenListener2.isListening = false
        /// MO: NewTokenListener property/s
        newTokenListener2.ercInterfaceId = ERCInterfaceId.erc721.rawValue
        let allNewTokenListeners = try self.context.fetch(.init(entityName: "NewTokenListener"))
        XCTAssertEqual(allNewTokenListeners.count, 2)
        let allListeners = try self.context.fetch(.init(entityName: "Listener"))
        print(allListeners)
        XCTAssertEqual(allListeners.count, 2)
        let onlyEnabledNewTokenListeners = try self.context.fetch(NSFetchRequests.enabledNewTokenListeners)
        XCTAssertEqual(onlyEnabledNewTokenListeners.count, 1)
    }
    
    func testmetadataEnabledExistingTokenListenersNSFetchRequest() throws {
        let existingTokenListener = ExistingTokenListener(context: self.context)
        /// ``Listener`` parent entity attribute/s
        existingTokenListener.id = UUID()
        existingTokenListener.isListening = true
        /// ``NewTokenListener`` attribute/s
        existingTokenListener.contractAddress = "0xa"
        existingTokenListener.listeningForMetadataEvents = true
        existingTokenListener.listeningForMintCommentEvents = true
        
        let existingTokenListener2 = ExistingTokenListener(context: self.context)
        /// ``Listener`` parent entity attribute/s
        existingTokenListener2.id = UUID()
        existingTokenListener2.isListening = true
        /// ``NewTokenListener`` attribute/s
        existingTokenListener2.contractAddress = "0xb"
        existingTokenListener2.listeningForMetadataEvents = false
        existingTokenListener2.listeningForMintCommentEvents = true
        let allExistingTokenListeners = try self.context.fetch(.init(entityName: "ExistingTokenListener"))
        XCTAssertEqual(allExistingTokenListeners.count, 2)
        let allListeners = try self.context.fetch(.init(entityName: "Listener"))
        XCTAssertEqual(allListeners.count, 2)
        let onlyMetadataEnabledListeners = try self.context.fetch(NSFetchRequests.metadataEnabledExistingTokenListeners)
        print(onlyMetadataEnabledListeners)
        XCTAssertEqual(onlyMetadataEnabledListeners.count, 1)
    }
    
    func testMintCommentEnabledExistingTokenListenersNSFetchRequest() throws {
        /// Create 2 new ``ExistingTokenListener`` entities
        /// 1) ``ExistingTokenListener`` with `\.listeningforMintCommentEvents` set to `true`
        let existingTokenListener = ExistingTokenListener(context: self.context)
        /// ``Listener`` parent entity attribute/s
        existingTokenListener.id = UUID()
        existingTokenListener.isListening = true
        /// ``NewTokenListener`` attribute/s
        existingTokenListener.contractAddress = "0xa"
        existingTokenListener.listeningForMetadataEvents = true
        existingTokenListener.listeningForMintCommentEvents = true
        /// 2) ``ExistingTokenListener`` with `\.listeningforMintCommentEvents` set to `false`
        let existingTokenListener2 = ExistingTokenListener(context: self.context)
        /// ``Listener`` parent entity attribute/s
        existingTokenListener2.id = UUID()
        existingTokenListener2.isListening = true
        /// ``NewTokenListener`` attribute/s
        existingTokenListener2.contractAddress = "0xb"
        existingTokenListener2.listeningForMetadataEvents = true
        existingTokenListener2.listeningForMintCommentEvents = false
        let allExistingTokenListeners = try self.context.fetch(.init(entityName: "ExistingTokenListener"))
        XCTAssertEqual(allExistingTokenListeners.count, 2)
        let allListeners = try self.context.fetch(.init(entityName: "Listener"))
        XCTAssertEqual(allListeners.count, 2)
        let onlyMintCommentEnabledListeners = try self.context.fetch(NSFetchRequests.mintCommentEnabledExistingTokenListeners)
        print(onlyMintCommentEnabledListeners)
        XCTAssertEqual(onlyMintCommentEnabledListeners.count, 1)
    }
}
