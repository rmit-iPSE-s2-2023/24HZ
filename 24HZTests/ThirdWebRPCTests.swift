//
// _4HZTests.swift
// 24HZ
// 
// Created by jin on 2023-09-24
// 



import XCTest
@testable import _4HZ   // importing 24HZ; first number gets replaced with "_"

final class ThirdWebRPCTests: XCTestCase {

    var rpc: ThirdWebRPC!

    override func setUp() {
        super.setUp()
        rpc = ThirdWebRPC(chainName: "zora")
    }
    
    /// Testing ThirdWebRPC.getBlocksInRange
    /// Test cases:
    /// 1. Should always return an array of BlockObjects - empty or not - OR throw
    /// 2. Returns the correct amount of BlockObjects i.e. for the given block range
    func testBlocksInRangeHappyPath() async throws {
        let blockCount = 500
        let fromBlock = 4321000
        let toBlock = fromBlock + blockCount - 1
        do {
            let blockObjects = try await rpc.getBlocksInRange(fromBlock: fromBlock, toBlock: toBlock)
            XCTAssertNotNil(blockObjects)   // Case 1
            XCTAssertEqual(blockCount, blockObjects.count)  // Case 2
            // FIXME: Debugging
            print(blockObjects.first!)
        } catch {
            XCTFail("Expected block objects but failed: \(error).")
        }
    }

}
