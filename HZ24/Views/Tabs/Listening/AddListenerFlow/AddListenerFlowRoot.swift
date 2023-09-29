//
//  AddListenerFlowView0.swift
//  a1-s3713342
//
//  Created by Min on 2023/08/05.
//

import SwiftUI

// MARK: - Step 0 of AddListenerFlow
struct AddListenerFlowRoot: View {
    
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
                    /// Take user to add ``NewTokenListener`` root
                    AddNewTokenListenerTypeSelection()
                } label: {
                    FormOption(text: "Listen for **new token** releases")
                }
                
                /// Option to add ``ExistingTokenListener``
                NavigationLink {
                    /// Take user to add ``ExistingTokenListener`` root
                } label: {
                    FormOption(text: "Listen to events for an **existing token**")
                }

                Spacer()
            }
        }
    }
    
    // Refactored option button
    private func FormOption(text: String) -> some View {
        CheckableFormOption(isChecked: false)
            .overlay(Text(try! AttributedString(markdown: text)).font(.title3).foregroundColor(.black))
    }
}

struct AddListenerFlowRoot_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddListenerFlowRoot()
        }
    }
}
