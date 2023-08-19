//
//  AddListenerFlowCustom1.swift
//  a1-s3713342
//
//  Created by 민철 on 2023/08/20.
//

import SwiftUI

struct AddListenerFlowCustom1: View {
    @State var contractAddress: String = ""
    // the view automatically redraws when the value of this variable changes.
    // `contractAddress` is intended to hold the user-inputted contract address, initialized as an empty string.
    @State private var contractAddresses: [String] = [] // array to store the addresses
    @Binding var navigateToCustom: Bool
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all) // black background
            
            VStack {
                Text("Enter contract address")
                    .foregroundColor(.white)
                    .font(.system(size: 24))
                
                HStack {
                    Text("Address")
                        .foregroundColor(.black)
                    TextField("Enter address", text: $contractAddress)
                }
                .padding()
                .background(Color.white)
                
                if !contractAddress.isEmpty {
                    Button(action: {
                        contractAddresses.append(contractAddress) // Add the entered address to the array
                        navigateToCustom = true
                    }) {
                        Image("confirm")
                    }
                    .background(
                        NavigationLink("", destination: AddListenerFlowCustom2(), isActive: $navigateToCustom)
                            .opacity(0) // hide the NavigationLink
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

