//
// ThirdWebRPCTests.swift
// 24HZ
// 
// Created by jin on 2023-09-24
// 



import XCTest
import web3
@testable import _4HZ   // importing 24HZ; first number gets replaced with "_"

final class ThirdWebRPCTests: XCTestCase {

    var rpc: ThirdWebRPC!
    
    /// Example Zora Contracts
    /// 1155
    let opepenThreadition = "0x6d2C45390B2A0c24d278825c5900A1B1580f9722"
    /// 721
    let allure = "0x53cb0B849491590CaB2cc44AF8c20e68e21fc36D"
    /// 20
    enum ERC20ExampleContracts: String {
        case merk = "0xD838D5b87439e17B0194fd43e37300cD99Aa3DE0"
        case mara = "0x661d1Fa0aAE29e6608a877627e49A058CAaE0285"
        case dlgate = "0x9513EB990A7162D8e508D550dFE4E3719805eE95"
        case weth = "0x4200000000000000000000000000000000000006"    // this contract does not support ERC-165 it seems!
    }

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
    /// Testing ThirdWebRPC.getBlocksInRange
    /// Test cases:
    /// 1. Should throw when block range is too big
    func testBlocksInRangeTooBig() async throws {
        let blockCount = 1001   // Max 1000 requests per batch
        let fromBlock = 4350000
        let toBlock = fromBlock + blockCount - 1
        do {
            let blockObjects = try await rpc.getBlocksInRange(fromBlock: fromBlock, toBlock: toBlock)
            XCTFail("Expected function to throw")
        } catch {
            print(error)
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
            /// Filter for  new deployment ``TransactionObject``s; whose `to` field is `nil`
            let deployTxs = blockObjects.flatMap { blockObject in
                return blockObject.transactions.filter { tx in
                    return tx.to == nil
                }
            }
            print(deployTxs.count)  // FIXME: Debugging
            /// Map ``TransactionObject``s to trasaction hashes
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
    
    func testTokenName() async throws {
        do {
            let tokenName = try await rpc.getTokenName(contractAddress: self.allure)
            print(tokenName)
        } catch {
            XCTFail("Expected token name but failed: \(error)")
        }
    }
    
    /// Testing getting the token name and symbol for a given array of contract addresses
    /// Return object should be a dictionary with the contract addresses as keys
    /// Test cases:
    /// 1. Number of dictionary keys should match the number of contracts included in array
    func testTokenInfo() async throws {
        let contractAddresses = [allure, opepenThreadition]
        do {
            let tokenInfos = try await rpc.getTokenInfos(contractAddresses: contractAddresses)
            print(tokenInfos)
            XCTAssertEqual(tokenInfos.count, contractAddresses.count)
        } catch {
            XCTFail("Expected token name but failed: \(error)")
        }
    }
    
    func testInterfaceSupportFor721() async throws {
        let interfaceId = ERCInterfaceId.erc721.rawValue.web3.hexData!
        do {
            let result = try await rpc.checkSupportsInterface(contractAddress: allure, interfaceId: interfaceId)
            XCTAssertTrue(result)
            
        } catch {
            XCTFail("Expected check interface support but failed: \(error)")
        }
    }
    func testInterfaceSupportFor1155() async throws {
        let interfaceId = ERCInterfaceId.erc1155.rawValue.web3.hexData!
        do {
            let result = try await rpc.checkSupportsInterface(contractAddress: opepenThreadition, interfaceId: interfaceId)
            XCTAssertTrue(result)
            
        } catch {
            XCTFail("Expected check interface support but failed: \(error)")
        }
    }
    func testInterfaceSupportFor20() async throws {
        let contractAddress = ERC20ExampleContracts.dlgate.rawValue
        let interfaceId20 = ERCInterfaceId.erc20.rawValue.web3.hexData!
        do {
            let result20 = try await rpc.checkSupportsInterface(contractAddress: contractAddress, interfaceId: interfaceId20)
            XCTAssertTrue(result20)
            
        } catch {
            XCTFail("Expected check interface support but failed: \(error)")
        }
        let interfaceId721 = ERCInterfaceId.erc721.rawValue.web3.hexData!
        do {
            let result721 = try await rpc.checkSupportsInterface(contractAddress: contractAddress, interfaceId: interfaceId721)
            XCTAssertFalse(result721)
        } catch {
            XCTFail("Expected check interface support but failed: \(error)")
        }
        let interfaceId1155 = ERCInterfaceId.erc1155.rawValue.web3.hexData!
        do {
            let result1155 = try await rpc.checkSupportsInterface(contractAddress: contractAddress, interfaceId: interfaceId1155)
            XCTAssertFalse(result1155)

        } catch {
            XCTFail("Expected check interface support but failed: \(error)")
        }
    }
    
    
    func testFilterContractsWithInterfaceSupport() async throws {
        let interfaceIds = [ERCInterfaceId.erc1155.rawValue.web3.hexData!, ERCInterfaceId.erc20.rawValue.web3.hexData!, ERCInterfaceId.erc721.rawValue.web3.hexData!]
        do {
            let results = try await rpc.filterContractsWithInterfaceSupport(contractAddresses: [opepenThreadition, allure, ERC20ExampleContracts.dlgate.rawValue], interfaceIds: interfaceIds)
            print(results)
        } catch {
            XCTFail("Expected check interface support but failed: \(error)")
        }
    }

}
