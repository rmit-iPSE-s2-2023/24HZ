//
//  AddListenerFlowView1.swift
//  a1-s3713342
//
//  Created by 민철 on 2023/08/12.
//

import SwiftUI

struct AddListenerFlowView1: View {
    @State private var option1Selected: Bool = false
    @State private var option2Selected: Bool = false
    @State private var option3Selected: Bool = false
    
    @Binding var navigateToAddListenerFlow: Bool

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all) // set black background
            
            VStack(spacing: 20) {
                Button(action: {
                    option1Selected.toggle()
                }) {
                    VStack {
                        Image("preference-selector")
                            .overlay(Text("Lmk about new Zora NFTs").foregroundColor(.black))
                            .brightness(option1Selected ? -0.5 : 0)
                    }
                }
                Button(action: {
                    option2Selected.toggle()
                }) {
                    VStack {
                        Image("preference-selector")
                            .overlay(Text("Lmk about new Zora NFTs").foregroundColor(.black))
                            .brightness(option2Selected ? -0.5 : 0)
                    }
                }
                Button(action: {
                    option3Selected.toggle()
                }) {
                    VStack {
                        Image("preference-selector")
                            .overlay(Text("Lmk about new Zora NFTs").foregroundColor(.black))
                            .brightness(option3Selected ? -0.5 : 0)
                    }
                }
                
                if option1Selected || option2Selected || option3Selected {
                    NavigationLink(destination: AddListenerFlowView2(navigateToAddListenerFlow: $navigateToAddListenerFlow)) {
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





struct AddListenerFlowView1_Previews: PreviewProvider {
    static var previews: some View {
        AddListenerFlowView1(navigateToAddListenerFlow: .constant(true))
    }
}
