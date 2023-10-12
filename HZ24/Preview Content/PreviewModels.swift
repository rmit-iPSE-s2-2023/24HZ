//
// PreviewModels.swift
// HZ24
// 
// Created by jin on 2023-10-07
// 



import Foundation
import CoreData

class PreviewModels {
    /// Add ``NewTokenListener`` for Coins
    static var newERC20Listener: NewTokenListener {
        let viewContext = CoreDataProvider.preview.container.viewContext
        let newListener = NewTokenListener(context: viewContext)
        /// ``Listener`` parent entity attribute/s
        newListener.createdAt = Date()
        newListener.displayTitle = ERCInterfaceId.erc20.displayTitle
        newListener.isListening = true
        /// ``NewTokenListener`` attribute/s
        newListener.ercInterfaceId = ERCInterfaceId.erc20.rawValue
        return newListener
    }
    
    static var newERC721Listener: NewTokenListener {
        let viewContext = CoreDataProvider.preview.container.viewContext
        let newListener = NewTokenListener(context: viewContext)
        /// ``Listener`` parent entity attribute/s
        newListener.createdAt = Date()
        newListener.displayTitle = ERCInterfaceId.erc721.displayTitle
        newListener.isListening = true
        /// ``NewTokenListener`` attribute/s
        newListener.ercInterfaceId = ERCInterfaceId.erc721.rawValue
        return newListener
    }
    
    static var newERC1155Listener: NewTokenListener {
        let viewContext = CoreDataProvider.preview.container.viewContext
        let newListener = NewTokenListener(context: viewContext)
        /// ``Listener`` parent entity attribute/s
        newListener.createdAt = Date()
        newListener.displayTitle = ERCInterfaceId.erc1155.displayTitle
        newListener.isListening = true
        /// ``NewTokenListener`` attribute/s
        newListener.ercInterfaceId = ERCInterfaceId.erc1155.rawValue
        return newListener
    }
    
    static var enjoyEthereumListener: ExistingTokenListener {
        let viewContext = CoreDataProvider.preview.container.viewContext
        let newListener = ExistingTokenListener(context: viewContext)
        /// ``Listener`` parent entity attribute/s
        newListener.createdAt = Date()
        newListener.displayTitle = "Opepen Threadition"
        newListener.isListening = true
        /// ``ExistingTokenListener`` attribute/s
        newListener.contractAddress = "0xc51bA90509E1d3a5CB5A78E21705A844ABfb8172"
        newListener.listeningForMetadataEvents = true
        newListener.listeningForMintCommentEvents = true
        newListener.tokenName = "Enjoy Ethereum+"
        newListener.tokenSymbol = "ZZO"
        return newListener
    }
    
    @discardableResult
    static func makePreviewERC20Listener(viewContext: NSManagedObjectContext) -> Listener {
        /// ERC20 Listener
        let newListener = NewTokenListener(context: viewContext)
        /// ``Listener`` parent entity attribute/s
        newListener.createdAt = Date()
        newListener.displayTitle = ERCInterfaceId.erc20.displayTitle
        newListener.isListening = true
        /// ``NewTokenListener`` attribute/s
        newListener.ercInterfaceId = ERCInterfaceId.erc20.rawValue
        
        return newListener
    }
    
    @discardableResult
    static func makePreviewNewTokenListeners(viewContext: NSManagedObjectContext) -> [Listener] {
        var listeners: [Listener] = []
        
        /// ERC20 Listener
        let newListener = NewTokenListener(context: viewContext)
        /// ``Listener`` parent entity attribute/s
        newListener.createdAt = Date()
        newListener.displayTitle = ERCInterfaceId.erc20.displayTitle
        newListener.isListening = true
        /// ``NewTokenListener`` attribute/s
        newListener.ercInterfaceId = ERCInterfaceId.erc20.rawValue
        listeners.append(newListener)
        
        /// ERC721 Listener
        let newListener2 = NewTokenListener(context: viewContext)
        /// ``Listener`` parent entity attribute/s
        newListener2.createdAt = Date()
        newListener2.displayTitle = ERCInterfaceId.erc721.displayTitle
        newListener2.isListening = true
        /// ``NewTokenListener`` attribute/s
        newListener2.ercInterfaceId = ERCInterfaceId.erc721.rawValue
        listeners.append(newListener2)
        
        /// ERC1155 Listener
        let newListener3 = NewTokenListener(context: viewContext)
        /// ``Listener`` parent entity attribute/s
        newListener3.createdAt = Date()
        newListener3.displayTitle = ERCInterfaceId.erc1155.displayTitle
        newListener3.isListening = true
        /// ``NewTokenListener`` attribute/s
        newListener3.ercInterfaceId = ERCInterfaceId.erc1155.rawValue
        listeners.append(newListener3)
        
        return listeners
    }
    
    static var mintCommentEvent: MintCommentEvent {
        let events = self.makeMintCommentEvents(1)
        return events[0]
    }
    
    @discardableResult
    static func makeMintCommentEvents(_ count: Int) -> [MintCommentEvent] {
        var events: [MintCommentEvent] = []
        let viewContext = CoreDataProvider.preview.container.viewContext
        for index in 0..<count {
            let event = MintCommentEvent(context: viewContext)
            /// ``Event`` parent entity attribute/s
            event.blockHash = "0x\(index)"
            event.blockNumber = Int64(index)
            event.contractAddress = "0x\(index)\(index)"
            event.ercInterfaceId = ERCInterfaceId.random().rawValue
            event.id = UUID()
            event.saved = false
            event.timestamp = Date().addingTimeInterval(Double(index) * -1800)
            event.tokenName = "Preview Token \(index)"
            event.tokenSymbol = "PRE\(index)"
            event.transactionHash = "0x\(index)\(index)\(index)"
            /// ``MintCommentEvent`` attribute/s
            /// Note: this is a sample subset, it can have different attributes set based on the ``MintCommentEventABI`` type
            event.abiEventName = MintCommentEventABI.MintComment.name
            event.mintComment = "I just love the number \(index)"
            event.quantity = Int64.random(in: 0..<5)
            event.sender = "0x\(index)\(index)\(index)"
            
            events.append(event)
        }
        return events
    }
    
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
