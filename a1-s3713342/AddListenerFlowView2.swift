//
//  AddListenerFlowView2.swift
//  a1-s3713342
//
//  Created by 민철 on 2023/08/12.
//

import SwiftUI

struct AddListenerFlowView2: View {
    @State private var option2Selected: Bool = false
    @State private var option3Selected: Bool = false
    @State private var option4Selected: Bool = false
    
    @Binding var navigateToNext: Bool

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all) // set black background
            
            VStack(spacing: 20) {
                // cant choose first option (default)
                VStack {
                    Image("preference-selected")
                        .overlay(Text("I want events on my 24HZ feed").foregroundColor(.black))
                }
                
                Button(action: {
                    option2Selected.toggle()
                }) {
                    VStack {
                        Image("preference-selector")
                            .overlay(Text("I also want once-a-day email").foregroundColor(.black))
                            .brightness(option2Selected ? -0.5 : 0)
                    }
                }
                
                Button(action: {
                    option3Selected.toggle()
                }) {
                    VStack {
                        Image("preference-selector")
                            .overlay(Text("I also want an email for every event").foregroundColor(.black))
                            .brightness(option3Selected ? -0.5 : 0)
                    }
                }
                
                Button(action: {
                    option4Selected.toggle()
                }) {
                    VStack {
                        Image("preference-selector")
                            .overlay(Text("I also want mobile notifications").foregroundColor(.black))
                            .brightness(option4Selected ? -0.5 : 0)
                    }
                }
                
                NavigationLink(destination: AddListenerFlowView3(navigateToNext: $navigateToNext)) {
                    Image("confirm")
                        //.resizable()
                        //.frame(width: 50, height: 50)
                }
            }
        }
    }
}
