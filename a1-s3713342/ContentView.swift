//
//  ContentView.swift
//  a1-s3713342
//
//  Created by 민철 on 2023/08/05.
//

import SwiftUI

struct ContentView: View {
    @State private var viewSelection = 0
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all) // set black background

            VStack {
                HStack {
                    Text("Listening")
                        .foregroundColor(viewSelection == 0 ? .white : .gray)
                    Text("Feed")
                        .foregroundColor(viewSelection == 1 ? .white : .gray)
                    Text("Saved")
                        .foregroundColor(viewSelection == 2 ? .white : .gray)
                    Text("Chat")
                        .foregroundColor(viewSelection == 3 ? .white : .gray)
                }
                .font(.headline)
                .padding()
                
                TabView(selection: $viewSelection) {
                    Text("Listening")
                    //rectengular and + button
                        .tag(0)
                        .foregroundColor(.white)
                    Text("Feed")
                    // some contracts
                        .tag(1)
                        .foregroundColor(.white)
                    Text("Saved")
                    
                        .tag(2)
                        .foregroundColor(.white)
                    Text("Chat")
                        .tag(3)
                        .foregroundColor(.white)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Hide indicator
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

