//
//  ContentView.swift
//  a1-s3713342
//
//  Created by Min on 2023/08/12.
//

import SwiftUI

struct ContentView: View {
    
    // FIXME: Should be removed
    @State private var user: User = getDummyUser()
    
    /// State for `TabView`
    /// - keeps track of which tab the user is currently viewing
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
                
                VStack {
                    
                    // MARK: Nav bar
                    SwipeNavigation(viewSelection: $selectedTab)
                    
                    // MARK: Tab contents
                    TabView(selection: $selectedTab) {
                        
                        /// Listening Tab
                        ListeningTab(user: $user)
                            .tag(0)
                        
                        /// Feed Tab
                        FeedTabWithCoreData()
                            .tag(1)
                        
                        /// Saved Tab
                        SavedTab()
                            .tag(2)
                        
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                }
                .navigationBarHidden(true)  // Hide the default navigation bar
        }
        .preferredColorScheme(.dark)
    }
}


struct ContentView_Previews: PreviewProvider {
    static let coreDataProvider = CoreDataProvider.preview
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, coreDataProvider.container.viewContext)
    }
}


