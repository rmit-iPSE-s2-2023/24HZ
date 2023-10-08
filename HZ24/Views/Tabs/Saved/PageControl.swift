//
//  PageControl.swift
//  HZ24
//
//  Created by 민철 on 8/10/23.
//

import SwiftUI
import UIKit

// MARK: part b-j Integrate the UIKit and SwiftUI

/// A SwiftUI wrapper around `UIPageControl` that allows page-based navigation.
struct PageControl: UIViewRepresentable {
    /// Total number of pages.
    var numberOfPages: Int
    /// Current page index (zero-based).
    @Binding var currentPage: Int

    /// Creates a coordinator to handle `UIPageControl` events.
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    /// Creates the `UIPageControl` view.
    func makeUIView(context: Context) -> UIPageControl {
        let control = UIPageControl()
        control.numberOfPages = numberOfPages
        // Attach an action to the page control's value changed event.
        control.addTarget(
            context.coordinator,
            action: #selector(Coordinator.updateCurrentPage(sender:)),
            for: .valueChanged)

        return control
    }

    /// Updates the `UIPageControl` view with the current page.
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.currentPage = currentPage
    }

    /// Coordinator class to handle `UIPageControl` events.
    class Coordinator: NSObject {
        /// Reference to the parent `PageControl` view.
        var control: PageControl

        /// Initializer for the coordinator.
        init(_ control: PageControl) {
            self.control = control
        }

        /// Action for updating the current page when the value of the `UIPageControl` changes.
        @objc
        func updateCurrentPage(sender: UIPageControl) {
            control.currentPage = sender.currentPage
        }
    }
}

