//
//  PageView.swift
//  HZ24
//
//  Created by 민철 on 8/10/23.
//

import SwiftUI

/// A view that combines multiple pages with a page control.
///
/// This view shows a paged interface, where each page is represented by a `Page` view.
/// The user can swipe between pages, and the page control at the bottom indicates the current page.
struct PageView<Page: View>: View {
    /// The array of pages to be displayed.
    var pages: [Page]
    
    /// The index of the currently visible page.
    @State private var currentPage = 0

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            /// PageViewController is responsible for displaying each page.
            PageViewController(pages: pages, currentPage: $currentPage)
            
            /// PageControl shows dots representing each page and highlights the current page's dot.
            PageControl(numberOfPages: pages.count, currentPage: $currentPage)
                .frame(width: CGFloat(pages.count * 18))
                .padding(.trailing)
        }
    }
}

struct PageView_Previews: PreviewProvider {
    static var previews: some View {
        /// A preview showing a sample of the PageView with TutorialCard views.
        PageView(pages: tutorials.map { Tutorials(tutorial: $0) })
            .aspectRatio(3 / 2, contentMode: .fit)
    }
}

