//
//  IndentedWithHeaderLayout.swift
//  a1-s3713342
//
//  Created by Jin on 2023-08-27.
//

import SwiftUI

/// A custom layout with a header that contains two elements.
/// The first two subviews are displayed as a header with the first
/// element in the header indented.
/// The remaining subviews (if any) will be indented based on
/// the given indentSize
///

@available(iOS 16.0, *)
struct IndentedWithHeaderLayout: Layout {
    
    let indentSize: CGFloat
    
    /// Returns a size for the layout container for vertical arrangemenet of
    /// subviews.
    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Void
    ) -> CGSize {
        
        // Make sure at least 2 subviews are given as this is required
        // to create the header
        guard subviews.count >= 2 else { return .zero }

        // Get the total height of subviews
        let totalHeight = totalHeight(subviews: subviews)
        
        // Get the spacing needed for vertical arrangement of subviews
        let spacing = spacing(subviews: subviews)
        let totalSpacing = spacing.reduce(0) { $0 + $1 }

        return CGSize(
            width: proposal.width!,
            height: totalHeight + totalSpacing)

}

    /// Place the subviews vertically with a mandatory header and indentation.
    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Void
    ) {
        // Make sure at least 2 subviews are given as this is required
        // to create the header
        guard subviews.count >= 2 else { return }

        let totalHeight = totalHeight(subviews: subviews)
        let spacing = spacing(subviews: subviews)
        let placementProposal = ProposedViewSize(width: proposal.width, height: totalHeight)
        
        // place header elements first
        subviews[0].place(at: CGPoint(x: bounds.minX - 10 + indentSize, y: bounds.minY + subviews[0].dimensions(in: .unspecified).height / 2),
                          anchor: .trailing,
                          proposal: ProposedViewSize(width: indentSize, height: 12))
        subviews[1].place(at: CGPoint(x: bounds.minX + indentSize, y: bounds.minY + subviews[0].dimensions(in: .unspecified).height / 2),
                          anchor: .leading,
                          proposal: ProposedViewSize(width: placementProposal.width! - indentSize, height: 10))
        
        // If there are elements to be placed under the header,
        // stack them vertically with indentation
        if subviews.count > 2 {
            
            // Calculate the initial y position of the first element
            var nextY: CGFloat = bounds.minY + subviews[0].dimensions(in: .unspecified).height

            for index in subviews.indices[2...] {
                subviews[index].place(
                    at: CGPoint(x: bounds.minX + indentSize, y: nextY),
                    proposal: ProposedViewSize(width: placementProposal.width! - indentSize, height: subviews[index].dimensions(in: .unspecified).height))
                nextY += spacing[index] + subviews[index].dimensions(in: .unspecified).height
            }
        }

    }

    /// Calculates the total height needed to display the subviews.
    private func totalHeight(subviews: Subviews) -> CGFloat {
        guard subviews.count >= 2 else { return .zero }

        let subviewSizes = subviews.map { $0.sizeThatFits(.unspecified) }
        
        // Calculate the height needed for the header
        var totalHeight: CGFloat = subviewSizes[..<2].reduce(.zero) { partialResult, headerElement in
            max(headerElement.height, partialResult)
        }
        
        // If there are elements to be placed under the header,
        // add the sum of these heights to the totalHeight
        if subviews.count > 2 {
            totalHeight = subviewSizes.reduce(.zero) { currentMax, subviewSize in
                currentMax + subviewSize.height
                }
        }

        return totalHeight
    }

    /// Calculate the spacing between subviews in vertical direction
    private func spacing(subviews: Subviews) -> [CGFloat] {
        
        subviews.indices.map { index in
            guard index < subviews.count - 1 else { return 0 }
            return subviews[index].spacing.distance(
                to: subviews[index + 1].spacing,
                along: .vertical)
        }
    }
}
