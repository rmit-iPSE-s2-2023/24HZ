//
// ListenerRowItem.swift
// HZ24
// 
// Created by jin on 2023-10-10
// 



import SwiftUI


/// Displays a listener at a glance. Suitable for use as a row item in a list.
struct ListenerRowItem: View {
    
    var listener: Listener
    
    private func badgeText() -> String {
        if listener is NewTokenListener {
            return "Generic"
        } else {
            return "Custom"
        }
    }
    
    var body: some View {

        RoundedRectangle(cornerRadius: 10)
            .stroke(Color.secondary, lineWidth: 1)
            .frame(height: 60)
            .overlay(
                // Block title
                Text(listener.displayTitle ?? "Unknown")
                    .font(.title2)
                    .padding(.leading, 10),
                alignment: .leading
            )
            .overlay(
                // Display badge depending on type of Listener
                ZStack {
                    if listener is NewTokenListener {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.init(uiColor: .systemBackground))
                            .frame(width: 60, height: 20)
                    } else {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(LinearGradient(gradient: Gradient(colors: [Color.pink, Color.purple]), startPoint: .leading, endPoint: .trailing))
                            .frame(width: 60, height: 20)
                    }


                    Text(badgeText())
                        .font(.caption)
                }
                .padding([.top, .trailing], 6),
                alignment: .topTrailing
            )
    }
}

struct ListenerRowItem_Previews: PreviewProvider {
    static let erc721listener = PreviewModels.newERC721Listener
    static let enjoyEthereumListener = PreviewModels.enjoyEthereumListener
    static var previews: some View {
        ListenerRowItem(listener: erc721listener)
            .preferredColorScheme(.dark)
            .previewDisplayName("NewTokenListener")
        ListenerRowItem(listener: enjoyEthereumListener)
            .preferredColorScheme(.dark)
            .previewDisplayName("ExistingTokenListener")
    }
}
