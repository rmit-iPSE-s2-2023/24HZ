//
//  AddListenerFlowCustom1.swift
//  a1-s3713342
//
//  Created by Min on 2023/08/20.
//

import SwiftUI

// MARK: - Add Custom Listener Step 1
struct AddListenerFlowCustom1: View {
    @State var contractAddress: String = ""  // Holds the user-inputted contract address
    @State private var contractAddresses: [String] = []  // Array to store addresses
    @Binding var navigateToCustom: Bool  // Controls navigation to the next view

    var body: some View {
        ZStack {
            // Background color
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                // Title text
                Text("Enter contract address")
                    .foregroundColor(.white)
                    .font(.title)
                
                // Text field for address input
                HStack {
                    Text("Address")
                        .foregroundColor(.black)
                    TextField("Enter address", text: $contractAddress)
                }
                .padding()
                .background(Color.white)
                
                // Confirmation button
                if !contractAddress.isEmpty {
                    Button(action: {
                        contractAddresses.append(contractAddress)  // Append address
                        navigateToCustom = true  // Navigate to next view
                    }) {
                        Image("confirm")
                    }
                    .background(
                        NavigationLink("", destination: AddListenerFlowCustom2(), isActive: $navigateToCustom)
                            .opacity(0)  // Hide the NavigationLink
                    )
                } else {
                    Image("confirm")
                }
            }
        }
    }
}

struct AddListenerFlowCustom1_Previews: PreviewProvider {
    static var previews: some View {
        AddListenerFlowCustom1(navigateToCustom: .constant(false))
    }
}

