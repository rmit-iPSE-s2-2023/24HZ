//
//  BlockSettingView.swift
//  a1-s3713342
//
//  Created by 민철 on 2023/08/14.
//

import SwiftUI

struct BlockSettingView: View {
    var block: BlockType
    @Binding var notificationSettings: [NotificationSetting]
    
    var body: some View {
        List {
            ForEach(NotificationSetting.allCases, id: \.self) { setting in
                Toggle(isOn: .constant(notificationSettings.contains(setting))) {
                    Text(setting.rawValue)
                }
                .disabled(setting == .eventsFeed)
            }
        }
        .background(Color.black) // Set the background color of the List
        .listStyle(PlainListStyle()) // This removes the default iOS List style which can interfere with custom styles

    }
}


