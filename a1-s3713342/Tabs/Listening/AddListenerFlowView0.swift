//
//  AddListenerFlowView0.swift
//  a1-s3713342
//
//  Created by 민철 on 2023/08/05.
//

import SwiftUI

struct AddListenerFlowView0: View {
    @Binding var blocks: [BlockType]
    @Binding var notificationSettings: [NotificationSetting]
    
    @State var selectedOption: Int? = nil // to track selected option
    @Binding var navigateToNext: Bool
    @Binding var navigateToCustom: Bool // for custom page
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all) // set black background
            
            VStack {
                //bar
                Spacer()
                
                Text("What kind of listener would you like to add?")
                    .foregroundColor(.white)
                    .font(.system(size: 24))


                
                Button(action: {
                    selectedOption = 1
                }) {
                    Image(selectedOption == 1 ? "checked=true" : "checked=false")
                        .overlay(Text("I want a generic event to listen to").foregroundColor(.black))
                }
                
                Button(action: {
                    selectedOption = 2
                }) {
                    Image(selectedOption == 2 ? "checked=true" : "checked=false")
                        .overlay(Text("I have a specific contract to listen to").foregroundColor(.black))
                }
                Spacer()
                

                
                if selectedOption == 1 {
                    NavigationLink(destination: AddListenerFlowView1(blocks: $blocks, notificationSettings: $notificationSettings, navigateToNext: $navigateToNext)) {
                        Image("continue")
                    }
                } else if selectedOption == 2 {
                    NavigationLink(destination: AddListenerFlowCustom1(navigateToCustom: $navigateToCustom)) {
                        Image("continue")
                    }
                } else {
                    Image("continue")
                }
            }
        }
    }
}

