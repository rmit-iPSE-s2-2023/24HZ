//
// NSFetchRequests.swift
// 24HZ
// 
// Created by jin on 2023-09-28
// 



import Foundation
import CoreData

enum NSFetchRequests {
    static var enabledNewTokenListeners: NSFetchRequest<NewTokenListener> {
        let request: NSFetchRequest<NewTokenListener> = NewTokenListener.fetchRequest()
        request.predicate = NSPredicate(format: "isListening == %@", NSNumber(value: true))
        return request
    }
    static var metadataEnabledExistingTokenListeners: NSFetchRequest<ExistingTokenListener> {
        let request: NSFetchRequest<ExistingTokenListener> = ExistingTokenListener.fetchRequest()
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "listeningForMetadataEvents == %@", NSNumber(value: true)),
            NSPredicate(format: "isListening == %@", NSNumber(value: true))
        ])
        request.predicate = compoundPredicate
        return request
    }
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
