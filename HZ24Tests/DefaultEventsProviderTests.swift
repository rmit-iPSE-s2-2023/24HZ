//
// DefaultEventsProviderTests.swift
// 24HZ
// 
// Created by jin on 2023-09-24
// 



import XCTest
@testable import HZ24

final class DefaultEventsProviderTests: XCTestCase {

    let maxBlockRange = 1000
    var eventsProvider: DefaultEventsProvider<ThirdWebRPC>!
    
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
        eventsProvider = DefaultEventsProvider<ThirdWebRPC>.zora()
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
    
    // MARK: - NewTokenEvent/s
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
    
    // MARK: - MetadataEvent/s
    /// Testing ``DefaultEventsProvider.getMetadataEvents``
    /// Should return a dictionary keyed by contract addresses
    /// Note: This test is not providing any contract addresses to filter by. In real use, this code will always be called with contract address/es to filter by.
    func testGetMetadataEventsWithNoContractFilter() async throws {
        /// DO NOT CHANGE: TESTING FOR THIS SPECIFIC BLOCK RANGE
        let fromBlock = 4321000
        let toBlock = fromBlock + self.maxBlockRange - 1
        do {
            let metadataUpdateEventsByContractAddress = try await self.eventsProvider.getMetadataEvents(fromBlock: fromBlock, toBlock: toBlock, forContracts: nil)
            XCTAssertNotNil(metadataUpdateEventsByContractAddress)
            XCTAssertEqual(metadataUpdateEventsByContractAddress.count, 25)
        } catch {
            XCTFail("Expected events but failed \(error).")
        }
    }
    
    func testGetMetadataEventsWithNoContractFilterCurrentBlock() async throws {
        let toBlock = try await eventsProvider.getCurrentBlockNumber()
        let fromBlock = toBlock - self.maxBlockRange + 1
        do {
            let events = try await self.eventsProvider.getMetadataEvents(fromBlock: fromBlock, toBlock: toBlock, forContracts: nil)
            print(events.count)
            print(events)
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
            XCTAssertNotNil(metadataUpdateEventsByContractAddress)
        } catch {
            XCTFail("Expected events but failed \(error).")
        }
    }
    
    // MARK: - MintCommentEvent/s
    /// Testing it is capturing _some_ `MintComment` events in the last 1000 blocks by using the current block
    /// Note: Useful if we want to note **active contracts for demoing**
    func testGetMintCommentEventsWithContractFilter() async throws {
        let toBlock = try await eventsProvider.getCurrentBlockNumber()
        let fromBlock = toBlock - self.maxBlockRange + 1
        /// First run `testGetMintCommentEventsWithoutContractFilterCurrentBlock`, get some example contract addresses from output and include in this array.
        let contracts = ["0xc51ba90509e1d3a5cb5a78e21705a844abfb8172"]
        do {
            let events = try await self.eventsProvider.getMintCommentEvents(fromBlock: fromBlock, toBlock: toBlock, forContracts: contracts)
            print("All MintComment events in last \(maxBlockRange) blocks: \(events.count)")
            print(events)
        } catch {
            XCTFail("Expected events but failed \(error).")
        }
    }
    
    func testGetMintCommentEventsWithoutContractFilter() async throws {
        /// DO NOT CHANGE: TESTING FOR THIS SPECIFIC BLOCK RANGE
        let fromBlock = 4321000
        let toBlock = fromBlock + self.maxBlockRange - 1
        do {
            let events = try await self.eventsProvider.getMintCommentEvents(fromBlock: fromBlock, toBlock: toBlock, forContracts: nil)
            print(events)
            XCTAssertEqual(events.count, 7)
            XCTAssertNotNil(events)
        } catch {
            XCTFail("Expected events but failed \(error).")
        }
    }
    
    /// Testing it is capturing _some_ `MintComment` events in the last 1000 blocks by using the current block
    /// Note: Useful if we want to note **active contracts for demoing**
    func testGetMintCommentEventsWithoutContractFilterCurrentBlock() async throws {
        let toBlock = try await eventsProvider.getCurrentBlockNumber()
        let fromBlock = toBlock - self.maxBlockRange + 1
        do {
            let events = try await self.eventsProvider.getMintCommentEvents(fromBlock: fromBlock, toBlock: toBlock, forContracts: nil)
            print("All MintComment events in last \(maxBlockRange) blocks: \(events.count)")
            print(events)
        } catch {
            XCTFail("Expected events but failed \(error).")
        }
    }
    
}
