//
//  ContentView.swift
//  a1-s3713342
//
//  Created by Min on 2023/08/12.
//

import SwiftUI

struct ContentView: View {
    
    var coredataProvider: CoreDataProvider = .shared
    
    /// State for `TabView`
    /// - keeps track of which tab the user is currently viewing
    @State private var selectedTab = 0
    
    private func fetchData() async {
        do {
            try await coredataProvider.fetchData()
        } catch {
            print(error)
        }
    }
    
    var body: some View {
        NavigationView {
                
                VStack {
                    
                    // MARK: Nav bar
                    SwipeNavigation(viewSelection: $selectedTab)
                    
                    // MARK: Tab contents
                    TabView(selection: $selectedTab) {
                        
                        /// Listening Tab
                        ListeningTab()
                            .tag(0)
                        
                        /// Feed Tab
                        FeedTabWithCoreData()
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
                .navigationBarHidden(true)  // Hide the default navigation bar
        }
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
    }
}


