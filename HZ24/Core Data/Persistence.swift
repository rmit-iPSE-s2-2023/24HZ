//
//  Persistence.swift
//  HZ24
//
//  Created by 민철 on 11/10/23.
//
// MARK: JUST made this for widget
import CoreData

struct PersistenceController {
    static let shared = PersistenceController ()
    static var preview: PersistenceController = {
        let result = PersistenceController (inMemory: true) // true
        let viewContext = result.container.viewContext
        // populate this with some preview data if required.
        
        // TEST
        let newTokenEvent = NewTokenEvent(context: viewContext)
        newTokenEvent.blockHash = "0x"
        newTokenEvent.blockNumber = Int64(1)
        newTokenEvent.contractAddress = "0xabc"
        newTokenEvent.id = UUID()
        newTokenEvent.saved = false
        newTokenEvent.timestamp = Date()
        newTokenEvent.tokenName = "Preview Token1"
        newTokenEvent.tokenSymbol = "PRE"
        newTokenEvent.transactionHash = "0x"
        newTokenEvent.deployerAddress = "0xdeployer"
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    let container: NSPersistentContainer
    
    init (inMemory: Bool = false) {
        
        container = NSPersistentContainer (name: "Model")
        
        let url = URL.storeURL(for: "group.com.Min-Jin.24HZ", databaseName: "HZ24")
        let storeDescription = NSPersistentStoreDescription (url: url)
        container.persistentStoreDescriptions = [storeDescription]
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores (completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError( "Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent=true
    }
}


public extension URL {
    static func storeURL (for appGroup: String, databaseName: String) -> URL {
        guard let fileContainer = FileManager.default.containerURL (forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError ("Unable to create URL for \(appGroup)")
        }
        return fileContainer.appendingPathComponent("\(databaseName),sqlite")
    }
}


