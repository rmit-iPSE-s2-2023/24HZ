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
    
    /// Testing ``DefaultEventsProvider.getNewTokenEvents``
    func testGetNewTokenEvents() async throws {
        /// DO NOT CHANGE: TESTING FOR THIS SPECIFIC BLOCK RANGE
        let blockCount = 1000
        let fromBlock = 4047777
        let toBlock = fromBlock + blockCount - 1
        
        let interfaceIds = [ERCInterfaceId.erc1155.rawValue.web3.hexData!, ERCInterfaceId.erc20.rawValue.web3.hexData!, ERCInterfaceId.erc721.rawValue.web3.hexData!]
        do {
            let newDeploymentEvents = try await eventsProvider.getNewTokenEvents(fromBlock: fromBlock, toBlock: toBlock, forInterfaces: interfaceIds)
            print(newDeploymentEvents)
        } catch {
            XCTFail("Expected new deployment events but failed: \(error).")
        }
    }


}
