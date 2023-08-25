//
//  AddListenerFlowView1.swift
//  a1-s3713342
//
//  Created by 민철 on 2023/08/12.
//

import SwiftUI

struct AddListenerFlowView1: View {
    @Binding var blocks: [BlockType]
    @Binding var notificationSettings: [NotificationSetting]
    
    @State private var selectedBlocks: [BlockType] = []
    @Binding var navigateToNext: Bool
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            //black background
            VStack {
                Spacer()
                
                Text("What would you like to listen for?")
                    .foregroundColor(.white)
                    .font(.system(size: 24))
                
                ForEach(BlockType.allCases, id: \.self) { block in
                    Button(action: {
                        if selectedBlocks.contains(block) {
                            selectedBlocks.removeAll { $0 == block }
                        } else {
                            selectedBlocks.append(block)
                        }
                    }) {
                        Image(selectedBlocks.contains(block) ? "checked=true" : "checked=false")
                            .overlay(Text(block.rawValue).foregroundColor(.black))
                    }
                }
                Spacer()
                
                if !selectedBlocks.isEmpty {
                    NavigationLink(destination: AddListenerFlowView2(selectedBlocks: $selectedBlocks, blocks: $blocks, notificationSettings: $notificationSettings, navigateToNext: $navigateToNext)) {
                        Image("continue")
                    }
                } else {
                    Image("continue")
                }
                
            }
        }
    }
}
