//
// NSFetchRequests.swift
// 24HZ
// 
// Created by jin on 2023-09-28
// 



import Foundation
import CoreData

/// Set of pre-configured NSFetchRequests.
enum NSFetchRequests {
    
    /// An `NSFetchRequest` to fetch listeners that are currently enabled.
    static var enabledNewTokenListeners: NSFetchRequest<NewTokenListener> {
        let request: NSFetchRequest<NewTokenListener> = NewTokenListener.fetchRequest()
        request.predicate = NSPredicate(format: "isListening == %@", NSNumber(value: true))
        return request
    }
    
    /// An `NSFetchRequest` to fetch listeners that are currently enabled and listening for metadata-related events.
    static var metadataEnabledExistingTokenListeners: NSFetchRequest<ExistingTokenListener> {
        let request: NSFetchRequest<ExistingTokenListener> = ExistingTokenListener.fetchRequest()
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "listeningForMetadataEvents == %@", NSNumber(value: true)),
            NSPredicate(format: "isListening == %@", NSNumber(value: true))
        ])
        request.predicate = compoundPredicate
        return request
    }
    
    /// An `NSFetchRequest` to fetch listeners that are currently enabled and listening for mint with comment events.
    static var mintCommentEnabledExistingTokenListeners: NSFetchRequest<ExistingTokenListener> {
        let request: NSFetchRequest<ExistingTokenListener> = ExistingTokenListener.fetchRequest()
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "listeningForMintCommentEvents == %@", NSNumber(value: true)),
            NSPredicate(format: "isListening == %@", NSNumber(value: true))
        ])
        request.predicate = compoundPredicate
        return request
    }
}
