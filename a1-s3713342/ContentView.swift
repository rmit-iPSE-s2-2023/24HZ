//
//  ContentView.swift
//  a1-s3713342
//
//  Created by 민철 on 2023/08/05.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all) // set background black

            VStack {
                HStack {
                    Text("Listening")
                        .foregroundColor(.white) // white
                    Text("Feed")
                        .foregroundColor(.white) // white
                    Text("Saved")
                        .foregroundColor(.white) // white
                    Text("Chat")
                        .foregroundColor(.white) // white
                }
                .font(.headline)
                Spacer() // to the top
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

