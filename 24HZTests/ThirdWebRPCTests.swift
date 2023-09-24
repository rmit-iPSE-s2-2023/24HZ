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
    
    /// Testing finding new contract deployments within give block range
    /// Test cases:
    /// 1. Number of new contract deployments found in given block range is correct
    /// 2. `to` field in `TransactionObject` is `nil` (as it should be for transactions that created new contracts)
    func testFilteringForNewContractDeployments() async throws {
        /// DO NOT CHANGE: TESTING FOR THIS SPECIFIC BLOCK RANGE
        let blockCount = 1000
        let fromBlock = 4311000
        let toBlock = fromBlock + blockCount - 1
        do {
            let blockObjects = try await rpc.getBlocksInRange(fromBlock: fromBlock, toBlock: toBlock)
            print("Filtering for new contract deplyoments between in block range:\n\(fromBlock), \(toBlock)")
            /// Filter for  new deployment TransactionObjects; whose `to` field is `nil`
            let deployTxs = blockObjects.flatMap { blockObject in
                return blockObject.transactions.filter { tx in
                    return tx.to == nil
                }
            }
            print(deployTxs)
            XCTAssertEqual(deployTxs.count, 3)
            XCTAssertEqual(deployTxs.first!.to, nil)
        } catch {
            XCTFail("Expected block objects but failed: \(error).")
        }
    }
    
    /// Testing finding new contract deployments within give block range
    /// Test cases:
    /// 1. Number of `TransactionReceiptObject` returned matches number of deploy transactions found in given block range
    /// 2. `to
    func testTransactionReceipts() async throws {
        /// DO NOT CHANGE: TESTING FOR THIS SPECIFIC BLOCK RANGE
        let blockCount = 1000
        let fromBlock = 4311000
        let toBlock = fromBlock + blockCount - 1
        do {
            let blockObjects = try await rpc.getBlocksInRange(fromBlock: fromBlock, toBlock: toBlock)
            print("Filtering for new contract deplyoments between in block range:\n\(fromBlock), \(toBlock)")
            /// Filter for  new deployment TransactionObjects; whose `to` field is `nil`
            let deployTxs = blockObjects.flatMap { blockObject in
                return blockObject.transactions.filter { tx in
                    return tx.to == nil
                }
            }
            print(deployTxs.count)
            /// Map `TransactionObject`s to trasaction hashes
            let deployTxHashes = deployTxs.map { txObj in
                return txObj.hash
            }
            /// Get `TransactionReceipt`s for each new contract deployment transaction to access new contract's address
            let txReceiptObjects = try await rpc.getTransactionReceipts(txHashes: deployTxHashes)
            XCTAssertEqual(deployTxs.count, txReceiptObjects.count)
        } catch {
            XCTFail("Expected block objects but failed: \(error).")
        }
    }

}
