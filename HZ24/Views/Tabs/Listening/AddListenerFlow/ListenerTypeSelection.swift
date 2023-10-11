//
//  AddListenerFlowView0.swift
//  a1-s3713342
//
//  Created by Min on 2023/08/05.
//

import SwiftUI

// MARK: - Step 0 of AddListener flow
/// This is the start (or root) of an `AddListener` flow.
/// Here, the user selects either the the flow for adding a ``NewTokenListener`` or ``ExistingTokenListener``
struct ListenerTypeSelection: View {
    
    // MARK: - Return body
    var body: some View {

        VStack {
            Spacer()
            
            /// Form question
            HStack {
                Text("What kind of listener would you like to add?")
                    .font(.title)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            
            /// Option to add ``NewTokenListener``
            NavigationLink {
                /// Navigate user to add ``NewTokenListener`` root
                TokenTypeSelection()
            } label: {
                FormOption(optionText: "Listen for **NEW TOKENS**", isSelected: false)
            }
            
            /// Option to add ``ExistingTokenListener``
            NavigationLink {
                /// Navigate user to add ``ExistingTokenListener`` root
                EnterContractAddress()
            } label: {
                FormOption(optionText: "Listen to **EXISTING TOKENS**", isSelected: false)
            }

            Spacer()
        }
        .padding(.horizontal, 16)
        .navigationTitle("Select listener type")
        .navigationBarTitleDisplayMode(.inline)
        // End of VStack (parent)

    }
    
    /// Form Option button
//    private func FormOption(markdown: String) -> some View {
//        CheckableFormOption(isChecked: false)
//            .overlay(Text(try! AttributedString(markdown: markdown)).font(.title3).foregroundColor(.black))
//    }
}

struct AddListenerFlowRoot_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ListenerTypeSelection()
        }
    }
}
