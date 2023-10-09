//
//  Hourmark.swift
//  a1-s3713342
//
//  Created by Jin on 2023-08-23.
//

import SwiftUI

/// Displays a horizontal divider with a label. Intended to mark an hour in a timeline view.
///
/// - Parameters:
///   - label: Label indicating the time. Should be a `String` in `HH:mm` format.
///   - color: Color for the label and divider. Must be of type `Color`.
struct Hourmark: View {
    
    
    let label: String
    let color: Color    // TODO: May need to specify color for Light/Dark modes
    
    /// Initialized with the default color as `.gray`
    init(label: String, color: Color = .gray) {
        self.label = label
        self.color = color
    }
    
    // MARK: - Return body
    var body: some View {
        HStack {
            Text(label)
                .font(.caption)
                .foregroundColor(color)
            
            VStack {
                Divider()
                .background(color)
            }
        }
    }
}

struct Hourmark_Previews: PreviewProvider {
    static var previews: some View {
        Hourmark(label: "11:00")
            .preferredColorScheme(.dark)
    }
}
