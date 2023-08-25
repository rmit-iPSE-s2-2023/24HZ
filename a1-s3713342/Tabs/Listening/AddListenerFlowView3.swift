//
//  AddListenerFlowView3.swift
//  a1-s3713342
//
//  Created by 민철 on 2023/08/12.
//

import SwiftUI

struct AddListenerFlowView3: View {
    @Binding var selectedBlocks: [BlockType]
    @Binding var notificationSettings: [NotificationSetting]
    @Binding var blocks: [BlockType]
    @Binding var selectedNotificationSettings: [NotificationSetting]
    
    // Add this state variable
    @Binding var navigateToNext: Bool
    
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all) // set black background
            VStack {
                Text("Success!").foregroundColor(.white)
                    .font(.largeTitle)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    // Set this state variable to true after 3 seconds
                    self.blocks = selectedBlocks
                    self.notificationSettings = selectedNotificationSettings
                    navigateToNext = false
                }
            }
        }
    }
}
