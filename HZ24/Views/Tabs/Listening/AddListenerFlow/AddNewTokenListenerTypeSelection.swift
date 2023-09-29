//
//  AddListenerFlowView1.swift
//  a1-s3713342
//
//  Created by Min on 2023/08/12.
//

import SwiftUI

// MARK: - Step 1 of AddListenerFlow
struct AddNewTokenListenerTypeSelection: View {
    
    /// User specified ``ERCInterfaceId``/s to listen to
    @State private var tokenTypeSelection: [ERCInterfaceId] = []
    
    var body: some View {
        ZStack {
            // Set black background
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                /// Form question
                Text("What would you like to listen for?")
                    .foregroundColor(.white)
                    .font(.title)
                
                /// ``NewTokenListener``'s ``ERCInterfaceId`` options
                /// Note: ``ERCInterfaceId``/s for ``NewtokenListener``/s that user has already opted in to should be pre-selected here
                ForEach(ERCInterfaceId.allCases, id: \.self) { ercInterfaceId in
                    createBlockButton(ercInterfaceId: ercInterfaceId)
                }
                
                Spacer() // Empty space at the bottom
                
                // Continue Button
                NavigationLink {
//                    AddListenerNotificationTypeSelection()
                } label: {
                    customContinueButton().opacity(tokenTypeSelection.isEmpty ? 0.5 : 1)
                }

            }
        }
    }
    
    // Refactored block button
    private func createBlockButton(ercInterfaceId: ERCInterfaceId) -> some View {
        Button(action: {
            // Toggle selection state for the block
            if tokenTypeSelection.contains(ercInterfaceId) {
                tokenTypeSelection.removeAll { $0 == ercInterfaceId }
            } else {
                tokenTypeSelection.append(ercInterfaceId)
            }
        }) {
            CheckableFormOption(isChecked: tokenTypeSelection.contains(ercInterfaceId))
                .overlay(Text(ercInterfaceId.rawValue).font(.title3.bold()).foregroundColor(.black))
        }
    }
}
