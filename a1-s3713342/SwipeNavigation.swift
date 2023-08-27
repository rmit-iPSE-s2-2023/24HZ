//
//  SwipeNav.swift
//  a1-s3713342
//
//  Created by Min on 22/8/23.
//

import SwiftUI

struct SwipeNavigation: View {
    @Binding var viewSelection: Int
    
    var body: some View {
        HStack {
            Text("Listening")
                .foregroundColor(viewSelection == 0 ? .white : .gray)
                .overlay(
                    Rectangle()
                        .frame(width: 60, height: 2)
                        .foregroundColor(viewSelection == 0 ? .blue : .clear)
                        .offset(y: 10),
                    alignment: .bottom
                )
                .onTapGesture { // click to move
                    viewSelection = 0
                }
            
            Text("Feed")
                .foregroundColor(viewSelection == 1 ? .white : .gray)
                .overlay(
                    Rectangle()
                        .frame(width: 60, height: 2)
                        .foregroundColor(viewSelection == 1 ? .blue : .clear)
                        .offset(y: 10),
                    alignment: .bottom
                )
                .onTapGesture { // click to move
                    viewSelection = 1
                }
            
            Text("Saved")
                .foregroundColor(viewSelection == 2 ? .white : .gray)
                .overlay(
                    Rectangle()
                        .frame(width: 60, height: 2)
                        .foregroundColor(viewSelection == 2 ? .blue : .clear)
                        .offset(y: 10),
                    alignment: .bottom
                )
                .onTapGesture { // click to move
                    viewSelection = 2
                }
        }
        .font(.headline)
        .padding()
    }
}



struct SwipeNavigation_Previews: PreviewProvider {
    static var previews: some View {
        SwipeNavigation(viewSelection: .constant(0))
            .background(Color.black)
            .previewLayout(.sizeThatFits)
    }
}




