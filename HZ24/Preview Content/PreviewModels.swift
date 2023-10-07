//
// PreviewModels.swift
// HZ24
// 
// Created by jin on 2023-10-07
// 



import Foundation
import CoreData

class PreviewModels {
    static var metadataEvent: MetadataEvent {
        let events = self.makeMetadataEvents(1)
        return events[0]
    }

    @discardableResult
    static func makeMetadataEvents(_ count: Int) -> [MetadataEvent] {
        var metadataEvents: [MetadataEvent] = []
        let viewContext = CoreDataProvider.preview.container.viewContext
        for index in 0..<count {
            let metadataEvent = MetadataEvent(context: viewContext)
            /// ``Event`` parent entity attribute/s
            metadataEvent.blockHash = "0x\(index)"
            metadataEvent.blockNumber = Int64(index)
            metadataEvent.contractAddress = "0x\(index)\(index)"
            metadataEvent.ercInterfaceId = ERCInterfaceId.random().rawValue
            metadataEvent.id = UUID()
            metadataEvent.saved = false
            metadataEvent.timestamp = Date().addingTimeInterval(Double(index) * -1800)
            metadataEvent.tokenName = "Preview Token \(index)"
            metadataEvent.tokenSymbol = "PRE\(index)"
            metadataEvent.transactionHash = "0x\(index)\(index)\(index)"
            /// ``MetadataEvent`` attribute/s
            /// Note: this is a sample subset, it can have different attributes set based on the ``MetadataEventABI`` type
            metadataEvent.abiEventName = "ABIEventName\(index)"
            metadataEvent.updatedAnimationURI = "ipfs://QmQ4Npi3kYbwBZLJbKt5pMwySGH2ZuSnU3BysKtrjWeQvr"
            metadataEvent.updatedFreezeAt = Int64(index)
            metadataEvent.updatedName = "Preview Token \(index + 1)"
            
            metadataEvents.append(metadataEvent)
        }
        return metadataEvents
    }
    
    static var newTokenEvent: NewTokenEvent {
        let events = self.makeNewTokenEvents(1)
        return events[0]
    }

    /// Creates ``NewTokenEvent``/s in preview context
    /// `@discardableResult` allows you to execute functions without assigning it to a variable.
    /// E.g. if you _don't_ use `@discardableResult` (`PreviewModels.makeNewTokenEvents(1)`), Xcode will warn you: "Result of call to 'makeNewTokenEvents' is unused"
    @discardableResult
    static func makeNewTokenEvents(_ count: Int) -> [NewTokenEvent] {
        var newTokenEvents: [NewTokenEvent] = []
        let viewContext = CoreDataProvider.preview.container.viewContext
        for index in 0..<count {
            let newTokenEvent = NewTokenEvent(context: viewContext)
            /// ``Event`` parent entity attribute/s
            newTokenEvent.blockHash = "0x\(index)"
            newTokenEvent.blockNumber = Int64(index)
            newTokenEvent.contractAddress = "0x\(index)\(index)"
            newTokenEvent.ercInterfaceId = ERCInterfaceId.random().rawValue
            newTokenEvent.id = UUID()
            newTokenEvent.saved = false
            newTokenEvent.timestamp = Date().addingTimeInterval(Double(index) * -1800)
            newTokenEvent.tokenName = "Preview Token \(index)"
            newTokenEvent.tokenSymbol = "PRE\(index)"
            newTokenEvent.transactionHash = "0x\(index)"
            /// ``NewTokenEvent`` attribute/s
            newTokenEvent.deployerAddress = "0xdeployer\(index)"
            newTokenEvents.append(newTokenEvent)
        }
        return newTokenEvents
    }
}

extension ERCInterfaceId {
    static func random() -> ERCInterfaceId {
        let allCases = self.allCases
        let randomIndex = Int.random(in: 0..<allCases.count)
        return allCases[randomIndex]
    }
}
