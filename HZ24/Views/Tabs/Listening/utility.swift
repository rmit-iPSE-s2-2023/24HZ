//
//  CustomContinueButton.swift
//  a1-s3713342
//
//  Created by Min on 26/8/23.
//

import SwiftUI



// Function for creating a '+' button

// Function for creating a custom continue button
func customContinueButton() -> some View {
    // Arrow symbol
    Image(systemName: "arrow.right")
        .font(.system(size: 40))
        .foregroundColor(.black)
        .frame(width: 200, height: 70)
        .background(Color.white)
        .border(Color.white, width: 5)
        .cornerRadius(10)
}

