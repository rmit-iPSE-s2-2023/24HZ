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
    // TODO: This should be Core Data ``Listener``s
    @Binding var listeners: [BlockType]
    
    // Binding to an array of notification settings.
    // This allows the tab to know what kind of notifications are enabled.
    // TODO: For now, disable dailyemail/allemail/push
    @Binding var notificationSettings: [NotificationSetting]
    
    // TODO: Get rid of this, no user info will be stored
    @Binding var user: User

    // State to manage navigation to the next view.
    // Triggered when the user wants to navigate to the next screen in a sequence.
    // TODO: Is this needed?
    @State private var navigateToNext = false
    
    // TODO: Is this needed?
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
                if listeners.isEmpty {
                    // Placeholder for no blocks
                    VStack {
                        Spacer()
                        Text("No listeners added")
                            .font(.title2)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                } else {
                    // List of blocks
                    ForEach(listeners, id: \.self) { block in
                        NavigationLink(destination: BlockSettingView(block: block, notificationSettings: $notificationSettings, blocks: $listeners)) {
                            genericBlock(block: block)
                        }
                    }
                }
                
                Spacer()
                
                /// Navigate user to root of `AddEventListener` flow
                NavigationLink(destination: AddListenerFlowRoot(), isActive: $navigateToNext) {
                    HStack {
                        Spacer()
                        AddListenerButton()
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
            ListeningTab(listeners: .constant([]), notificationSettings: .constant([]), user: .constant(user))
            
            // Preview with some sample blocks
            ListeningTab(listeners: .constant([.zoraNFTs, .coins,.customNFTs]), notificationSettings: .constant([]), user: .constant(user))
        }
    }
}

func AddListenerButton() -> some View {
    // '+' symbol
    Image(systemName: "plus")
        .font(.system(size: 40))
        .frame(width: 60, height: 60)
        .foregroundColor(.white)
        .background(Color.black)
        .overlay(
            // Circular border
            Circle()
                .stroke(Color.white, lineWidth: 2)
        )
}




