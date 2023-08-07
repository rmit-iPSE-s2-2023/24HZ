//
//  ContentView.swift
//  a1-s3713342
//
//  Created by 민철 on 2023/08/05.
//

import SwiftUI

struct ContentView: View {
    @State private var viewSelection = 0
    @State private var showAddListenerFlow = false
    
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
                    
                    VStack (spacing: 20){
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 350, height: 500) // 넓이 높이
                            .cornerRadius(30) // 모서리
                        
                        // Display current events or any other content
                        Button(action: {
                            showAddListenerFlow = true
                        }) {
                            Image("add-event")
                        }
                    }
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
            // Navigation to add-listener-flow/0
            .fullScreenCover(isPresented: $showAddListenerFlow) {
                AddListenerFlowView0()
            }
        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

