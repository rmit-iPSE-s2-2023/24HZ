//
//  ListeningTab.swift
//  a1-s3713342
//
//  Created by Min on 22/8/23.
//

import SwiftUI

struct ListeningTab: View {
    
    // MARK: - Properties
    
    // Binding to an array of blocks that the user has added.
    // This will be a shared state between different views.
    @Binding var blocks: [BlockType]
    
    // Binding to an array of notification settings.
    // This allows the tab to know what kind of notifications are enabled.
    @Binding var notificationSettings: [NotificationSetting]
    
    @Binding var user: User

    // State to manage navigation to the next view.
    // Triggered when the user wants to navigate to the next screen in a sequence.
    @State private var navigateToNext = false
    
    // State to manage navigation to a custom view.
    // Triggered when the user wants to navigate to a custom screen.
    @State private var navigateToCustom = false
    
    
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                
                HStack {
                    Text(user.name + ",")
                        .multilineTextAlignment(.leading)
                        .font(.largeTitle.bold())
                        .foregroundColor(.orange)
                        .padding(.leading, 10)
                    Spacer()
                }
                
                HStack {
                    Text("here is what you're listening to...")
                        .multilineTextAlignment(.leading)
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                        .padding(.leading, 10)
                    Spacer()
                }
                
                // Content: Blocks or Placeholder
                if blocks.isEmpty {
                    // Placeholder for no blocks
                    VStack {
                        Spacer()
                        Text("No blocks added")
                            .font(.title2)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                } else {
                    // List of blocks
                    ForEach(blocks, id: \.self) { block in
                        NavigationLink(destination: BlockSettingView(block: block, notificationSettings: $notificationSettings, blocks: $blocks)) {
                            genericBlock(block: block)
                        }
                    }
                }
                
                Spacer()
                
                // Bottom Add Button
                NavigationLink(destination: AddListenerFlowView0(blocks: $blocks, notificationSettings: $notificationSettings, navigateToNext: $navigateToNext, navigateToCustom: $navigateToCustom), isActive: $navigateToNext) {
                    HStack {
                        Spacer()
                        plusButton()
                            .offset(y: -20)
                            .padding(.bottom, 20)
                            .padding(.trailing, 20)
                    }
                }
                .isDetailLink(false)
            }
        }
    }
}


struct ListeningTab_Previews: PreviewProvider {
    static var previews: some View {
        let user = getDummyUser() // Create a constant user for preview
        Group {
            // Preview with no blocks
            ListeningTab(blocks: .constant([]), notificationSettings: .constant([]), user: .constant(user))
            
            // Preview with some sample blocks
            ListeningTab(blocks: .constant([.zoraNFTs, .coins,.customNFTs]), notificationSettings: .constant([]), user: .constant(user))
        }
    }
}






