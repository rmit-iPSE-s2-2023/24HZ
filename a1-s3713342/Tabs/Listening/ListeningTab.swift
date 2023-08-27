//
//  ListeningTab.swift
//  a1-s3713342
//
//  Created by 민철 on 22/8/23.
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
                // Header
                HStack {
                    Text("#USERNAME")
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                        .padding(.leading, 30)
                    Spacer()
                }
                
                HStack {
                    Text("here is what you're")
                        .font(.system(size: 30))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.leading, 30) 
                    Spacer()
                }
                
                HStack {
                    Text("listening to...")
                        .font(.system(size: 30))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.leading, 30) 
                    Spacer()
                }
                
                // Content: Blocks or Placeholder
                if blocks.isEmpty {
                    // Placeholder for no blocks
                    VStack {
                        Spacer()
                        Text("No blocks added")
                            .font(.system(size: 30))
                            .fontWeight(.regular)
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
        Group {
            // Preview with no blocks
            ListeningTab(blocks: .constant([]), notificationSettings: .constant([]))
            
            // Preview with some sample blocks
            ListeningTab(blocks: .constant([.zoraNFTs, .coins,.customNFTs]), notificationSettings: .constant([]))
        }
    }
}






