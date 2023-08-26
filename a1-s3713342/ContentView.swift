//
//  ContentView.swift
//  a1-s3713342
//
//  Created by 민철 on 2023/08/12.
//

import SwiftUI

struct ContentView: View {
    
    @State var user: User = getDummyUser()
    @State var currentTime = Constants.dummyCurrentTimeInterval    // Should keep state; using Constant for purpose of prototype
    
    // States related to blocks and notifications
    @State var blocks: [BlockType] = []
    @State var notificationSettings: [NotificationSetting] = [.eventsFeed]
    
    // State for tab view selection
    @State private var viewSelection = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background Color
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack {
                    // Custom navigation bar
                    SwipeNavigation(viewSelection: $viewSelection)
                    
                    // Tab contents
                    TabView(selection: $viewSelection) {
                        
                        // Listening Tab
                        ListeningTab(blocks: $blocks, notificationSettings: $notificationSettings)
                            .tag(0)
                        
                        // Feed Tab
                        FeedTab(user: $user, currentTime: $currentTime)
                            .tag(1)
                        
                        // Saved Tab
                        SavedTab()
                            .tag(2)
                        
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                }
            }
            .navigationBarHidden(true)  // Hide the default navigation bar
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


