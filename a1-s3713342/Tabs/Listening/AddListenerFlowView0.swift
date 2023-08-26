//
//  AddListenerFlowView0.swift
//  a1-s3713342
//
//  Created by 민철 on 2023/08/05.
//

import SwiftUI

// MARK: - Step 0 of AddListenerFlow
struct AddListenerFlowView0: View {
    // Binding variables for parent view
    @Binding var blocks: [BlockType]
    @Binding var notificationSettings: [NotificationSetting]
    
    // Local state variables
    @State var selectedOption: Int? = nil // To track selected option
    @Binding var navigateToNext: Bool
    @Binding var navigateToCustom: Bool // For custom page
    
    var body: some View {
        ZStack {
            // Background color
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                // Empty space at top
                Spacer()
                
                // Title Text
                Text("What kind of listener would you like to add?")
                    .foregroundColor(.white)
                    .font(.system(size: 24))

                // Option buttons
                               createOptionButton(option: 1, text: "I want a generic event to listen to")
                               createOptionButton(option: 2, text: "I have a specific contract to listen to")
                
                // Empty space at bottom
                Spacer()
                
                // Continue Button Logic
                if selectedOption == 1 {
                    NavigationLink(destination: AddListenerFlowView1(blocks: $blocks, notificationSettings: $notificationSettings, navigateToNext: $navigateToNext)) {
                        customContinueButton()
                    }
                } else if selectedOption == 2 {
                    NavigationLink(destination: AddListenerFlowCustom1(navigateToCustom: $navigateToCustom)) {
                        customContinueButton()
                    }
                } else {
                    customContinueButton().opacity(0.5) // Disable if no option selected
                }
            }
        }
    }
    
    // Refactored option button
    private func createOptionButton(option: Int, text: String) -> some View {
        Button(action: { selectedOption = option }) {
            customCheckButton(isChecked: selectedOption == option)
                .overlay(Text(text).foregroundColor(.black))
        }
    }
}

struct AddListenerFlowView0_Previews: PreviewProvider {
    static var previews: some View {
        AddListenerFlowView0(
            blocks: .constant([.coins, .zoraNFTs]), // Dummy data
            notificationSettings: .constant([.eventsFeed, .onceADayEmail]), // Dummy data
            navigateToNext: .constant(false), // Dummy data
            navigateToCustom: .constant(false) // Dummy data
        )
    }
}
