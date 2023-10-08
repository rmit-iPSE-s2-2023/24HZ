//
//  Tutorials.swift
//  HZ24
//
//  Created by 민철 on 4/10/23.
//

import SwiftUI

/// Represents a single tutorial with an image and overlay text.
struct Tutorial: Identifiable {
    var id: Int
    var featureImage: Image
    var overlayText: String
}

// TODO: Replace with the actual images to be used.
/// Sample tutorial data for previews and mock-ups.
let tutorials: [Tutorial] = [
    Tutorial(id: 1, featureImage: Image("example11"), overlayText: "First Step"),
    Tutorial(id: 2, featureImage: Image("example22"), overlayText: "Second Step"),
    Tutorial(id: 3, featureImage: Image("example33"), overlayText: "Last Step")
]

/// A view representing a tutorial with an image and overlay text.
struct Tutorials: View {
    var tutorial: Tutorial

    var body: some View {
        tutorial.featureImage
            .resizable()
            .aspectRatio(3 / 2, contentMode: .fit)
            .overlay(TextOverlay(tutorial: tutorial))
    }
}

/// A view that provides a gradient overlay and displays the tutorial text.
struct TextOverlay: View {
    var tutorial: Tutorial

    /// Gradient overlay used for the text background.
    var gradient: LinearGradient {
        .linearGradient(
            Gradient(colors: [.black.opacity(0.6), .black.opacity(0)]),
            startPoint: .bottom,
            endPoint: .center)
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            gradient
            Text(tutorial.overlayText)
                .font(.title)
                .bold()
                .padding()
                .foregroundColor(.white)
        }
    }
}

/// Previews for the `Tutorials` view.
struct Tutorials_Previews: PreviewProvider {
    static var previews: some View {
        Tutorials(tutorial: tutorials[0])
    }
}

