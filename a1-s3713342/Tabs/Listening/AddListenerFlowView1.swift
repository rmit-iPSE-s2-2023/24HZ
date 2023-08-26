//
//  AddListenerFlowView1.swift
//  a1-s3713342
//
//  Created by 민철 on 2023/08/12.
//

import SwiftUI

// MARK: - Step 1 of AddListenerFlow
struct AddListenerFlowView1: View {
    // Binding variables for parent view
    @Binding var blocks: [BlockType]
    @Binding var notificationSettings: [NotificationSetting]
    
    // Local state variables
    @State private var selectedBlocks: [BlockType] = []
    @Binding var navigateToNext: Bool
    
    var body: some View {
        ZStack {
            // Set black background
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer() // Empty space at the top
                
                // Title
                Text("What would you like to listen for?")
                    .foregroundColor(.white)
                    .font(.system(size: 24))
                
                // List of options for blocks
                ForEach(BlockType.allCases, id: \.self) { block in
                    createBlockButton(block: block)
                }
                
                Spacer() // Empty space at the bottom
                
                // Continue Button
                if !selectedBlocks.isEmpty {
                    NavigationLink(destination: AddListenerFlowView2(selectedBlocks: $selectedBlocks, blocks: $blocks, notificationSettings: $notificationSettings, navigateToNext: $navigateToNext)) {
                        customContinueButton()
                    }
                } else {
                    customContinueButton().opacity(0.5) // Disable the button if no option is selected
                }
            }
        }
    }
    
    // Refactored block button
    private func createBlockButton(block: BlockType) -> some View {
        Button(action: {
            // Toggle selection state for the block
            if selectedBlocks.contains(block) {
                selectedBlocks.removeAll { $0 == block }
            } else {
                selectedBlocks.append(block)
            }
        }) {
            customCheckButton(isChecked: selectedBlocks.contains(block))
                .overlay(Text(block.rawValue).foregroundColor(.black))
        }
    }
}
