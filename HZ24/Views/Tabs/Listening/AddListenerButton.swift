//
// AddListenerButton.swift
// HZ24
// 
// Created by jin on 2023-10-10
// 


import SwiftUI

/// A view that represents a button to add a new listener.
///
/// This is just a visual component. Functionality should be implemented by parent view.
struct AddListenerButton: View {
    var body: some View {
        Image(systemName: "plus")
            .font(.largeTitle)
            .frame(width: 60, height: 60)
            .overlay(
                // Circular border
                Circle()
                    .stroke(lineWidth: 2)
            )
    }
}

struct AddListenerButton_Previews: PreviewProvider {
    static var previews: some View {
        AddListenerButton()
    }
}
