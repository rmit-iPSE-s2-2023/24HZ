//
//  add-listener-flow:0.swift
//  a1-s3713342
//
//  Created by 민철 on 2023/08/05.
//

import SwiftUI

// add-listener-flow/0:

struct AddListenerFlowView0: View {
    @State private var selectedOption: Int? = nil
    @State private var moveToNextView = false

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    selectedOption = 1
                }) {
                    Image("preference-selector")
                        .overlay(Text("1"))
                        .brightness(selectedOption == 1 ? 0 : 0.5)
                }

                Button(action: {
                    selectedOption = 2
                }) {
                    Image("preference-selector")
                        .overlay(Text("2"))
                        .brightness(selectedOption == 2 ? 0 : 0.5)
                }
            }

            Button(action: {
                if selectedOption != nil {
                    moveToNextView = true
                }
            }) {
                Rectangle()
                    .stroke(Color.white)
                    .frame(width: 50, height: 30)
                    .overlay(Text("Check"))
            }
        }
        .fullScreenCover(isPresented: $moveToNextView) {
            AddListenerFlowView1()
        }
    }
}

struct add_listener_flow_0_Previews: PreviewProvider {
    static var previews: some View {
        add_listener_flow_0()
    }
}
