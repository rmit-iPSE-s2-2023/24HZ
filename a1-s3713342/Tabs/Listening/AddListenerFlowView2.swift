//
//  AddListenerFlowView2.swift
//  a1-s3713342
//
//  Created by Min on 2023/08/12.
//

import SwiftUI

// MARK: - Step 2 of AddListenerFlow
struct AddListenerFlowView2: View {
    // Binding variables for parent view
    @Binding var selectedBlocks: [BlockType]
    @Binding var blocks: [BlockType]
    @Binding var notificationSettings: [NotificationSetting]
    
    // Local state variables
    @State var selectedNotificationSettings: [NotificationSetting] = [.eventsFeed]
    @Binding var navigateToNext: Bool

    var body: some View {
        ZStack {
            // Set black background
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer() // Empty space at the top
                
                // Title
                Text("How would you like to be notified?")
                    .foregroundColor(.white)
                    .font(.title)
                
                // Display selected blocks
                Text(selectedBlocks.map { $0.rawValue }.joined(separator: " & "))
                
                // List of options for notification settings
                ForEach(NotificationSetting.allCases, id: \.self) { setting in
                    createNotificationSettingButton(setting: setting)
                }
                
                Spacer() // Empty space at the bottom
                
                // Continue Button
                if selectedNotificationSettings != [.eventsFeed] {
                    NavigationLink(destination: AddListenerFlowView3(selectedBlocks: $selectedBlocks, notificationSettings: $notificationSettings, blocks: $blocks, selectedNotificationSettings: $selectedNotificationSettings, navigateToNext: $navigateToNext)) {
                        customContinueButton()
                    }
                } else {
                    customContinueButton().opacity(0.5)  // Disable the button if no option is selected
                }
            }
        }
    }
    
    // Refactored notification setting button
    private func createNotificationSettingButton(setting: NotificationSetting) -> some View {
        Button(action: {
            // Toggle selection state for the notification setting
            if setting != .eventsFeed {
                if selectedNotificationSettings.contains(setting) {
                    selectedNotificationSettings.removeAll { $0 == setting }
                } else {
                    selectedNotificationSettings.append(setting)
                }
            }
        }) {
            customCheckButton(isChecked: selectedNotificationSettings.contains(setting))
                .overlay(Text(setting.rawValue).foregroundColor(.black))
        }
    }
}
