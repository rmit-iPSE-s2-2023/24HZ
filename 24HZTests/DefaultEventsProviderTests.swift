//
// DefaultEventsProviderTests.swift
// 24HZ
// 
// Created by jin on 2023-09-24
// 



import XCTest
@testable import _4HZ

final class DefaultEventsProviderTests: XCTestCase {

    let maxBlockRange = 1000
    var eventsProvider: DefaultEventsProvider!
    
    /// Example MetadataEvent contracts
    let metadataTestData = [
        "fromBlock": 4321000,
        "contracts": ["0x099352730ca072e2d74d69b94f90c66acfd8934c", "0xb4d732e6cf1ef96633ed0ab72e9a54b877af1c89", "0xb123cbc4381a0f21ef5f5f9967bb5a4558f38783"]
    ] as [String: Any]
    /// Example MintEvent contracts
    let mintTestData = [
        "fromBlock": 4321000,
        "contracts": ["0xd2621b7f7602dca0f0737c380f4e5374b4bdac9b", "0xeb0851f650150fec6b80ed894d95d152e7166a5b", "0x4e18d1be29f54d6c11935939e36c9988897c145e"]
    ] as [String: Any]

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
        let fromBlock = 4047777
        let toBlock = fromBlock + self.maxBlockRange - 1
        
        let interfaceIds = [ERCInterfaceId.erc1155.rawValue.web3.hexData!, ERCInterfaceId.erc20.rawValue.web3.hexData!, ERCInterfaceId.erc721.rawValue.web3.hexData!]
        do {
            let newDeploymentEvents = try await eventsProvider.getNewTokenEvents(fromBlock: fromBlock, toBlock: toBlock, forInterfaces: interfaceIds)
            print(newDeploymentEvents)
        } catch {
            XCTFail("Expected new deployment events but failed: \(error).")
        }
    }
    
    /// Testing ``DefaultEventsProvider.getMetadataEvents``
    /// Should return a dictionary keyed by contract addresses
    /// Note: This test is not providing any contract addresses to filter by. In real use, this code will always be called with contract address/es to filter by.
    func testGetMetadataEventsWithNoContractFilter() async throws {
        /// DO NOT CHANGE: TESTING FOR THIS SPECIFIC BLOCK RANGE
        let fromBlock = 4321000
        let toBlock = fromBlock + self.maxBlockRange - 1
        do {
            let metadataUpdateEventsByContractAddress = try await self.eventsProvider.getMetadataEvents(fromBlock: fromBlock, toBlock: toBlock, forContracts: nil)
            print(metadataUpdateEventsByContractAddress.keys)
            XCTAssertEqual(metadataUpdateEventsByContractAddress.count, 23)
            XCTAssertNotNil(metadataUpdateEventsByContractAddress)
        } catch {
            XCTFail("Expected events but failed \(error).")
        }
    }
    
    func testGetMetadataEventsWithContractFilter() async throws {
        /// DO NOT CHANGE: TESTING FOR THIS SPECIFIC BLOCK RANGE
        let fromBlock = metadataTestData["fromBlock"] as! Int
        let toBlock = fromBlock + self.maxBlockRange - 1
        let contracts = metadataTestData["contracts"] as! [String]
        do {
            let metadataUpdateEventsByContractAddress = try await self.eventsProvider.getMetadataEvents(fromBlock: fromBlock, toBlock: toBlock, forContracts: contracts)
            print(metadataUpdateEventsByContractAddress.keys)
            XCTAssertNotNil(metadataUpdateEventsByContractAddress)
        } catch {
            XCTFail("Expected events but failed \(error).")
        }
    }
    
    func testGetMintCommentEventsWithoutContractFilter() async throws {
        /// DO NOT CHANGE: TESTING FOR THIS SPECIFIC BLOCK RANGE
        let fromBlock = 4321000
        let toBlock = fromBlock + self.maxBlockRange - 1
        do {
            let mintEventsByContractAddress = try await self.eventsProvider.getMintCommentEvents(fromBlock: fromBlock, toBlock: toBlock, forContracts: nil)
            XCTAssertEqual(mintEventsByContractAddress.count, 3)
            XCTAssertNotNil(mintEventsByContractAddress)
        } catch {
            XCTFail("Expected events but failed \(error).")
        }
    }


}
