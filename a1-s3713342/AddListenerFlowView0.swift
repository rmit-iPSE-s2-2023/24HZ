//
//  AddListenerFlowView0.swift
//  a1-s3713342
//
//  Created by 민철 on 2023/08/05.
//

import SwiftUI

//
//  SwiftUIView.swift
//  dddd
//
//  Created by 민철 on 2023/08/05.
//

import SwiftUI

struct AddListenerFlowView0: View {
    @State private var selectedOption: Int?// To track selected option
    @State private var moveToNextView = false

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
                Button(action: {
                    if selectedOption != nil {
                        moveToNextView = true
                    }
                }) {
                    Image("confirm")
                        //.resizable()
                        //.frame(width: 50, height: 50)
                        
                }
            }
            .fullScreenCover(isPresented: $moveToNextView) {
                AddListenerFlowView1()
            }
        }
    }
}

struct AddListenerFlowView0_Previews: PreviewProvider {
    static var previews: some View {
        AddListenerFlowView0()
    }
}
