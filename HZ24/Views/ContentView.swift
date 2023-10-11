//
//  ContentView.swift
//  a1-s3713342
//
//  Created by Min on 2023/08/12.
//

import SwiftUI

/// The root view of the 24HZ app.
struct ContentView: View {
    
    var coredataProvider: CoreDataProvider = .shared
    
    /// State to keep track of which tab the user is currently viewing
    @State private var selectedTab = 0
    
    /// A method for fetching event data and updating the Core Data store.
    private func fetchData() async {
        do {
            try await coredataProvider.fetchData()
        } catch {
            print(error)
        }
    }
    
    // MARK: - Return body
    var body: some View {
        VStack() {
            // MARK: Nav bar
            NavBar(tabSelection: $selectedTab)
            
            // MARK: Tab contents
            TabView(selection: $selectedTab) {
                
                /// Listening Tab
                ListeningTab()
                    .tag(0)
                
                /// Feed Tab
                FeedTab()
                    .tag(1)
                    .refreshable {
                        await fetchData()
                    }
                
                /// Saved Tab
                SavedTab()
                    .tag(2)
                
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        // End of VStack (parent)
        .navigationBarHidden(true)  // Hide the default navigation bar
        .preferredColorScheme(.dark)
        .task {
            await fetchData()
        }
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static let coreDataProvider = CoreDataProvider.preview
    static var previews: some View {
        ContentView(coredataProvider: coreDataProvider)
            .environment(\.managedObjectContext, coreDataProvider.container.viewContext)
            .previewDisplayName("ContentView (unwrapped)")
        
        NavigationView {
            ContentView(coredataProvider: coreDataProvider)
                .environment(\.managedObjectContext, coreDataProvider.container.viewContext)
        }
        .previewDisplayName("ContentView (wrapped in nav")
    }
}


