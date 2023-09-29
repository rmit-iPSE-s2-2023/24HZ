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
    
    var body: some View {
        ZStack {
            /// Background
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                /// Form question
                Text("What kind of listener would you like to add?")
                    .foregroundColor(.white)
                    .font(.title)
                
                /// Option to add ``NewTokenListener``
                NavigationLink {
                    /// Navigate user to add ``NewTokenListener`` root
                    TokenTypeSelection()
                } label: {
                    FormOption(markdown: "Listen for **new token** releases")
                }
                
                /// Option to add ``ExistingTokenListener``
                NavigationLink {
                    /// Navigate user to add ``ExistingTokenListener`` root
                } label: {
                    FormOption(markdown: "Listen to events for an **existing token**")
                }

                Spacer()
            }
        }
    }
    
    /// Form Option button
    private func FormOption(markdown: String) -> some View {
        CheckableFormOption(isChecked: false)
            .overlay(Text(try! AttributedString(markdown: markdown)).font(.title3).foregroundColor(.black))
    }
}

struct AddListenerFlowRoot_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ListenerTypeSelection()
            
        }
    }
}
