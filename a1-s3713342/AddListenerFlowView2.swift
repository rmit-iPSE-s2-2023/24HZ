//
//  AddListenerFlowView2.swift
//  a1-s3713342
//
//  Created by 민철 on 2023/08/12.
//

import SwiftUI

struct AddListenerFlowView2: View {
    @Binding var selectedBlocks: [BlockType]
    @Binding var blocks: [BlockType]
    @Binding var notificationSettings: [NotificationSetting]
    
    @State var selectedNotificationSettings: [NotificationSetting] = [.eventsFeed]
    @Binding var navigateToNext: Bool

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                
                Text("How would you like to be notified?")
                    .foregroundColor(.white)
                    .font(.system(size: 24))
                
                Text(blocks.map { $0.rawValue }.joined(separator: " & "))
                ForEach(NotificationSetting.allCases, id: \.self) { setting in
                    Button(action: {
                        if setting != .eventsFeed {
                            if selectedNotificationSettings.contains(setting) {
                                selectedNotificationSettings.removeAll { $0 == setting }
                            } else {
                                selectedNotificationSettings.append(setting)
                            }
                        }
                    }) {
                        Image(selectedNotificationSettings.contains(setting) ? "checked=true" : "checked=false")
                            .overlay(Text(setting.rawValue).foregroundColor(.black))
                    }
                }
                Spacer()
                
                if selectedNotificationSettings != [.eventsFeed] {
                    NavigationLink(destination: AddListenerFlowView3(selectedBlocks: $selectedBlocks, notificationSettings: $notificationSettings, blocks: $blocks, selectedNotificationSettings: $selectedNotificationSettings, navigateToNext: $navigateToNext)) {
                        Image("confirm")
                    }
                } else {
                    Image("confirm")
                }
            }
        }
    }
}
