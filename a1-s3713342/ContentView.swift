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
    
    @State var blocks: [BlockType] = []
    @State var notificationSettings: [NotificationSetting] = [.eventsFeed]
    @State private var viewSelection = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                VStack {
                    SwipeNavigation(viewSelection: $viewSelection) //navbar
                    
                    TabView(selection: $viewSelection) {
                        
                        ListeningTab(blocks: $blocks, notificationSettings: $notificationSettings)
                            .tag(0)
                        
                        FeedTab(user: $user, currentTime: $currentTime)
                            .tag(1)
                        
                        SavedTab()
                            .tag(2)
                        
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                }
            }
            .navigationBarHidden(true)
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


