//
//  SwipeNav.swift
//  a1-s3713342
//
//  Created by 민철 on 22/8/23.
//

import SwiftUI

struct SwipeNavigation: View {
    @Binding var viewSelection: Int
    
    var body: some View {
        HStack {
            VStack {
                Text("Listening")
                    .foregroundColor(viewSelection == 0 ? .white : .gray)
                    .onTapGesture { // click to move
                        viewSelection = 0
                    }
                if viewSelection == 0 { // highlighter
                    Rectangle()
                        .frame(width: 60, height: 2)
                        .foregroundColor(.blue)
                }
            }
            
            VStack {
                Text("Feed")
                    .foregroundColor(viewSelection == 1 ? .white : .gray)
                    .onTapGesture { // click to move
                        viewSelection = 1
                    }
                if viewSelection == 1 { // highlighter
                    Rectangle()
                        .frame(width: 60, height: 2)
                        .foregroundColor(.blue)
                }
            }
            
            VStack {
                Text("Saved")
                    .foregroundColor(viewSelection == 2 ? .white : .gray)
                    .onTapGesture { // click to move
                        viewSelection = 2
                    }
                if viewSelection == 2 { // highlighter
                    Rectangle()
                        .frame(width: 60, height: 2)
                        .foregroundColor(.blue)
                }
            }
            
            VStack {
                Text("Chat")
                    .foregroundColor(viewSelection == 3 ? .white : .gray)
                    .onTapGesture { // click to move
                        viewSelection = 3
                    }
                if viewSelection == 3 { // highlighter
                    Rectangle()
                        .frame(width: 60, height: 2)
                        .foregroundColor(.blue)
                }
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




