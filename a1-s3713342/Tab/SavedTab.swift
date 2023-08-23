//
//  SavedTab.swift
//  a1-s3713342
//
//  Created by 민철 on 22/8/23.
//

import SwiftUI

struct SavedTab: View {
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            // Your existing content for the saved tab
            VStack(spacing: 20) {
                Text("Your saved events will show up on this page.")
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .padding(.top, 50)
                Spacer()
                
                VStack(spacing: 15) {
                    Text("To save events:")
                        .foregroundColor(.white)
                        .font(.headline)
                    
                    Text("1. Navigate to Feed")
                        .foregroundColor(.white)
                    Text("2. Tap on an event")
                        .foregroundColor(.white)
                    Text("3. Tap “Save”")
                        .foregroundColor(.white)
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white, lineWidth: 2)
                )
                
                VStack(spacing: 15) {
                    Image("icon")
                        .resizable()
                        .frame(width: 100, height: 100) // Adjust this to fit the icon's aspect ratio
                    Text("<helper_animation>")
                        .foregroundColor(.white)
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white, lineWidth: 2)
                )
                
                Spacer()
            }
        }
        .padding(.horizontal)
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}



