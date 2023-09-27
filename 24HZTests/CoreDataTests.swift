//
// CoreDataTests.swift
// 24HZ
// 
// Created by jin on 2023-09-27
// 



import XCTest
@testable import _4HZ

final class CoreDataTests: XCTestCase {
    
    var coreDataProvider: CoreDataProvider!

    override func setUp() {
        super.setUp()
        coreDataProvider = CoreDataProvider.preview
        print(coreDataProvider.container.persistentStoreDescriptions)
    }
    
    /// Trivial test to just make sure Core Data is playing nicely and project is building properly
    func testSavingNewTokenListener() throws {
        let viewContext = self.coreDataProvider.container.viewContext
        var newTokenListeners: [NewTokenListener]
        /// Initially, there should be no NewTokenListeners in store
        newTokenListeners = try viewContext.fetch(.init(entityName: "NewTokenListener"))
        XCTAssertFalse(viewContext.hasChanges)
        XCTAssertEqual(newTokenListeners.count, 0)
        let newTokenListener = NewTokenListener(context: viewContext)
        /// MO: Listener property/s
        newTokenListener.id = UUID()
        newTokenListener.isListening = true
        /// MO: NewTokenListener property/s
        newTokenListener.ercInterfaceId = ERCInterfaceId.erc721.rawValue
        XCTAssertTrue(viewContext.hasChanges)
        newTokenListeners = try viewContext.fetch(.init(entityName: "NewTokenListener"))
        XCTAssertEqual(newTokenListeners.count, 1)
        print(newTokenListener)
        newTokenListeners.forEach { newTokenListener in
            print(newTokenListener.ercInterfaceId ?? "no ercInterfaceId")
        }
    }

}
