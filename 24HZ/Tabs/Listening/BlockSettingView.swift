//
//  BlockSettingView.swift
//  a1-s3713342
//
//  Created by Min on 2023/08/14.
//

import SwiftUI

struct BlockSettingView: View {
    var block: BlockType
    @Binding var notificationSettings: [NotificationSetting]
    @Binding var blocks: [BlockType]  // To update the blocks list
    @State private var showingAlert = false  // To control the alert visibility
    
    var body: some View {
        ZStack {
            // Background color
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {
                
                // Display the block name at the top
                Text(block.rawValue)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.leading)
                
                // List of notification settings toggles
                List {
                    ForEach(NotificationSetting.allCases, id: \.self) { setting in
                        toggleView(for: setting)
                    }
                }
                .listStyle(PlainListStyle())
                
                // Pushes the delete button to the bottom
                Spacer()
                
                // Delete button to remove the block
                deleteButton
            }
        }
    }
    
    // Function to create a Toggle view for each NotificationSetting
    private func toggleView(for setting: NotificationSetting) -> some View {
        Toggle(isOn: .constant(notificationSettings.contains(setting))) {
            Text(setting.rawValue)
                .foregroundColor(.black)
        }
        .disabled(setting == .eventsFeed)  // The 'eventsFeed' setting is always on and cannot be disabled
    }
    private var deleteButton: some View {
        // Create a text-based button styled as a delete button
        Text("Delete this listener")
            .font(.title3)
            .foregroundColor(.red)
            .padding()
            .frame(maxWidth: .infinity, alignment: .center)  // Center the text
            .onTapGesture { showingAlert = true }  // Show alert when tapped
            .alert(isPresented: $showingAlert) { createAlert() }  // Attach the alert
    }

    private func createAlert() -> Alert {
        // Alert to confirm deletion
        Alert(
            title: Text("Confirmation"),  // Alert title
            message: Text("Are you sure you want to delete this listener?"),  // Alert message
            primaryButton: .destructive(Text("Yes")) {
                blocks.removeAll { $0 == block }  // Remove block on confirmation
            },
            secondaryButton: .cancel(Text("No"))  // Cancel action
        )
    }
}



struct BlockSettingView_Previews: PreviewProvider {
    static var previews: some View {
        // dummydatas
        let dummyNotificationSettings = [NotificationSetting.eventsFeed]
        let dummyBlocks = [BlockType.zoraNFTs]
        
        // preview
        BlockSettingView(
            block: .zoraNFTs,
            notificationSettings: .constant(dummyNotificationSettings),
            blocks: .constant(dummyBlocks)
        )
    }
}


