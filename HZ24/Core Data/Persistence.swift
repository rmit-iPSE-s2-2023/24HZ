//
//  Persistence.swift
//  HZ24
//
//  Created by Min on 11/10/23.
//

import CoreData

/// `PersistenceController` is used for initializing and managing the CoreData stack.
/// This class utilizes the singleton pattern, providing a shared instance accessible throughout the app.
/// It also offers a separate instance for preview purposes, allowing the CoreData stack to be used at design time.
struct PersistenceController {
    /// The shared instance used within the actual app. This instance saves data to the permanent store.
    static let shared = PersistenceController()

    /// The instance for previews. This instance uses an in-memory store to prevent actual data from being saved to disk.
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // Populate this with some preview data if required.
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    /// The app's CoreData container. This container hosts the managed object context for the model.
    let container: NSPersistentContainer

    /// Initializes a new `PersistenceController` instance.
    /// - Parameter inMemory: Set to `true` if the store should only exist in memory. This is typically used for testing and previews.
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Model")
        
        // Configure the URL for storing the database within the app group.
        let url = URL.storeURL(for: "group.com.Min-Jin.24HZ", databaseName: "HZ24")
        let storeDescription = NSPersistentStoreDescription(url: url)
        container.persistentStoreDescriptions = [storeDescription]

        if inMemory {
            // Set the URL to /dev/null to prevent data from being saved to disk.
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }

        // Load the persistent stores. If an error occurs, the app is terminated.
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })

        // Set up the context to automatically merge changes from the parent context.
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}

public extension URL {
    /// Generates a store URL for the specified app group and database name.
    /// - Parameters:
    ///   - appGroup: The app group where the database file will be stored.
    ///   - databaseName: The name of the database.
    /// - Returns: The complete URL for the database file.
    static func storeURL(for appGroup: String, databaseName: String) -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("Unable to create URL for \(appGroup)")
        }
        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
    }
}
