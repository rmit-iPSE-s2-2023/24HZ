//
//  AddListenerFlowView3.swift
//  a1-s3713342
//
//  Created by 민철 on 2023/08/12.
//

import SwiftUI

// MARK: - Final Step of AddListenerFlow
struct AddListenerFlowView3: View {
    // Binding variables for parent view
    @Binding var selectedBlocks: [BlockType]
    @Binding var notificationSettings: [NotificationSetting]
    @Binding var blocks: [BlockType]
    @Binding var selectedNotificationSettings: [NotificationSetting]
    
    // Binding to control navigation
    @Binding var navigateToNext: Bool
    
    var body: some View {
        ZStack {
            // Set the background color to black
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                // Display a success message
                Text("Success!")
                    .foregroundColor(.white)
                    .font(.largeTitle)
            }
            .onAppear {
                // Execute the following code after a delay of 3 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    // Update the binding variables and navigate back
                    self.blocks = selectedBlocks
                    self.notificationSettings = selectedNotificationSettings
                    navigateToNext = false
                }
            }
        }
    }
}

