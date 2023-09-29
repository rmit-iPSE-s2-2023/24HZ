//
//  CustomContinueButton.swift
//  a1-s3713342
//
//  Created by Min on 26/8/23.
//

import SwiftUI

// Function for creating a generic block button
func genericBlock(block: BlockType) -> some View {
    ZStack {
        // Rounded Rectangle with white border
        RoundedRectangle(cornerRadius: 15)
            .stroke(Color.white, lineWidth: 2)
            .background(Color.black)
            .frame(width: 350, height: 70)
            .overlay(
                // Block title
                Text(block.rawValue)
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding(.leading, 10),
                alignment: .leading
            )
            .overlay(
                // 'Generic' label at top-right
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.pink, Color.purple]), startPoint: .leading, endPoint: .trailing))
                        .frame(width: 60, height: 20)
                    
                    Text("Generic")
                        .foregroundColor(.white)
                        .font(.caption)
                }
                .padding([.top, .trailing], 10),
                alignment: .topTrailing
            )
    }
}

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

// Function for creating a custom check button
func CheckableFormOption(isChecked: Bool = false) -> some View {
    ZStack {
        // Background rectangle with rounded corners
        RoundedRectangle(cornerRadius: 10)
            .fill(isChecked ? Color.green : Color.white)
            .frame(width: 400, height: 100)
        
        if isChecked {
            // Small circle at top-right
            Circle()
                .fill(Color.black)
                .frame(width: 30, height: 30)
                .offset(x: 180, y: -30)
            
            // Checkmark icon
            Image(systemName: "checkmark")
                .foregroundColor(.green)
                .offset(x: 180, y: -30)
        }
    }
}

