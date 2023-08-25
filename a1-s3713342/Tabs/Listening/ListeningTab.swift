//
//  ListeningTab.swift
//  a1-s3713342
//
//  Created by 민철 on 22/8/23.
//

import SwiftUI

struct ListeningTab: View {
    
    @Binding var blocks: [BlockType]
    @Binding var notificationSettings: [NotificationSetting]
    @State private var navigateToNext = false
    @State private var navigateToCustom = false
    
    
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                Text("NAME")
                    .font(.title2)
                    .foregroundColor(.purple)
                Text("here is what you're")
                    .foregroundColor(.white)
                Text("listening to")
                    .foregroundColor(.white)
                
                // If user add no blocks, message is shown 
                if blocks.isEmpty {
                    Text("No blocks added")
                        .foregroundColor(.white)
                        .padding(.top, 20)
                } else {
                    ForEach(blocks, id: \.self) { block in
                        NavigationLink(destination: BlockSettingView(block: block, notificationSettings: $notificationSettings)) {
                            HStack {
                                Image("block-generic")
                                    .overlay(
                                        Text(block.rawValue)
                                            .foregroundColor(.black)
                                            .font(.headline)
                                            .padding(.leading, 10),
                                        alignment: .leading
                                    )
                            }
                        }
                    }
                }
                
                Spacer()
                
            NavigationLink(destination: AddListenerFlowView0(blocks: $blocks, notificationSettings: $notificationSettings, navigateToNext: $navigateToNext, navigateToCustom: $navigateToCustom), isActive: $navigateToNext) {
                Image("add-event")
            }
            .isDetailLink(false)
            }
        }
    }
}

struct ListeningTab_Previews: PreviewProvider {
    static var previews: some View {
        ListeningTab(blocks: .constant([]), notificationSettings: .constant([]))
    }
}





