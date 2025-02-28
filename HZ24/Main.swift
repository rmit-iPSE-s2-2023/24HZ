//
//  a1_s3713342App.swift
//  a1-s3713342
//
//  Created by Min on 2023/08/05.
//

import SwiftUI
import CoreData

/// Entry point of the 24HZ app.
///
/// An instance of ``CoreDataProvider`` is initialized and injected into the ``ContentView``. The Core Data viewContext is injected into app's environment.
@main
struct Main: App {
    
    let coreDataProvider = CoreDataProvider.shared
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView(coredataProvider: coreDataProvider)
            }
            .environment(\.managedObjectContext, coreDataProvider.container.viewContext)
        }
    }
}
