//
//  Hourmark.swift
//  a1-s3713342
//
//  Created by Jin on 2023-08-23.
//

import SwiftUI

struct Hourmark: View {
    
    //    Parameters
    let label: String
    let color: Color    // May need to specify color for Light/Dark modes
    
    init(label: String, color: Color = .gray) {
        self.label = label
        self.color = color
    }
    
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
    }
}
