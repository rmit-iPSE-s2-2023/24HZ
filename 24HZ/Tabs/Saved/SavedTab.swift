//
//  SavedTab.swift
//  a1-s3713342
//
//  Created by Min on 22/8/23.
//

import SwiftUI

struct SavedTab: View {
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                HStack {
                    Text("Your saved events will show up on this page")
                        .multilineTextAlignment(.leading)
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                        .padding(.leading, 10)
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("To save events:")
                        .foregroundColor(.white)
                        .font(.title2)

                    Text("1. Navigate to **Feed**")
                        .foregroundColor(.white)
                        .padding(.leading, 20)
                    
                    Text("2. Tap on an _Event_")
                        .foregroundColor(.white)
                        .padding(.leading, 20)

                    Text("3. Tap _Save_")
                        .foregroundColor(.white)
                        .padding(.leading, 20)

                }
                .frame(width: 330, alignment: .leading)
                .padding(.vertical, 40)
                .padding(.horizontal, 20)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white, lineWidth: 2)
                )

                VStack(spacing: 15) {
                    Image("icon")
                        .resizable()
                        .frame(width: 100, height: 70) // Adjust this to fit the icon's aspect ratio
                    Text("<helper_animation>")
                        .foregroundColor(.gray)
                }
                .frame(width: 330, height: 200)
                .padding(.vertical, 40)
                .padding(.horizontal, 20)
                .overlay(
                    Rectangle()
                        .stroke(Color.white, lineWidth: 2)
                )
                
                Spacer()
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

struct SavedTab_Previews: PreviewProvider {
    static var previews: some View {
        SavedTab()
    }
}


