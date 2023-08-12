//
//  AddListenerFlowView0.swift
//  a1-s3713342
//
//  Created by 민철 on 2023/08/05.
//

import SwiftUI

struct AddListenerFlowView0: View {
    @State private var selectedOption: Int? // to track selected option
    @Binding var navigateToNext: Bool
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all) // set black background

            VStack (spacing: 20){
                HStack {
                    Button(action: {
                        selectedOption = 1
                    }) {
                        Image("preference-selector")
                            .overlay(Text("I want a generic event to listen to").foregroundColor(.black))
                            .brightness(selectedOption == 1 ? -0.5 : 0)
                    }

                    Button(action: {
                        selectedOption = 2
                    }) {
                        Image("preference-selector")
                            .overlay(Text("I have a contract address to listen to").foregroundColor(.black))
                            .brightness(selectedOption == 2 ? -0.5 : 0)
                    }
                }

                if selectedOption == 1 {
                    NavigationLink(destination: AddListenerFlowView1(navigateToNext: $navigateToNext)) {
                        Image("confirm")
                            //.resizable()
                            //.frame(width: 50, height: 50)
                    }
                } else if selectedOption == 2 {
                    NavigationLink(destination: Text("custompage")) {
                        Image("confirm")
                            //.resizable()
                            //.frame(width: 50, height: 50)
                    }
                } else {
                    Image("confirm")
                        //.resizable()
                        //.frame(width: 50, height: 50)
                }
            }
        }
    }
}
