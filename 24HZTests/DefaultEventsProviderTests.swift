//
// DefaultEventsProviderTests.swift
// 24HZ
// 
// Created by jin on 2023-09-24
// 



import XCTest
@testable import _4HZ

final class DefaultEventsProviderTests: XCTestCase {

    var eventsProvider: DefaultEventsProvider!

    override func setUp() {
        super.setUp()
        eventsProvider = DefaultEventsProvider.zora
    }
    
    /// Testing getCurrentBlockNumber
    /// Test cases:
    /// 1. should return an Int value - not nil - OR throw
    func testGetCurrentBlock() async throws {
        do {
            let currentBlockNumber = try await eventsProvider.getCurrentBlockNumber()
            XCTAssertNotNil(currentBlockNumber)     // Case 1
            print(currentBlockNumber)   // FIXME: Debugging
        } catch {
            XCTFail("Expected current block number but failed: \(error).")
        }
    }

}
