//
//  SwipeNav.swift
//  a1-s3713342
//
//  Created by Min on 22/8/23.
//

import SwiftUI

/// This view represents a navigation bar.
///
/// Should be used alongside a TabView.
struct NavBar: View {
    
    /// Binding that represents the user's current tab selection
    @Binding var tabSelection: Int
    
    // MARK: - Return body
    var body: some View {
        HStack {
            Text("Listening")
                .foregroundColor(tabSelection == 0 ? .primary : .secondary)
                .overlay(
                    Rectangle()
                        .frame(width: .infinity, height: 2)
                        .foregroundColor(tabSelection == 0 ? .accentColor : .clear)
                        .offset(y: 8),
                    alignment: .bottom
                )
                .onTapGesture {
                    tabSelection = 0
                }
            
            Text("Feed")
                .foregroundColor(tabSelection == 1 ? .primary : .secondary)
                .overlay(
                    Rectangle()
                        .frame(width: .infinity, height: 2)
                        .foregroundColor(tabSelection == 1 ? .accentColor : .clear)
                        .offset(y: 8),
                    alignment: .bottom
                )
                .onTapGesture {
                    tabSelection = 1
                }
            
            Text("Saved")
                .foregroundColor(tabSelection == 2 ? .primary : .secondary)
                .overlay(
                    Rectangle()
                        .frame(width: .infinity, height: 2)
                        .foregroundColor(tabSelection == 2 ? .accentColor : .clear)
                        .offset(y: 8),
                    alignment: .bottom
                )
                .onTapGesture {
                    tabSelection = 2
                }
        }
        .font(.headline)
        .padding()
        // End of HStack (parent)
    }
}

// MARK: - Previews
struct SwipeNavigation_Previews: PreviewProvider {
    static var previews: some View {
        NavBar(tabSelection: .constant(0))
    }
}

