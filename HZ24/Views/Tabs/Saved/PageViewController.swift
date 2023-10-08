//
//  PageViewController.swift
//  HZ24
//
//  Created by 민철 on 8/10/23.
//

import SwiftUI
import UIKit

// MARK: part b-j Integrate the UIKit and SwiftUI

/// A SwiftUI view that wraps a `UIPageViewController` to show a sequence of pages.
/// This view allows users to swipe through a collection of views and provides a seamless transition between them.
struct PageViewController<Page: View>: UIViewControllerRepresentable {
    
    // The collection of views to be displayed as pages.
    var pages: [Page]
    
    // The current page index, which can be used to control the visible page.
    @Binding var currentPage: Int

    /// Creates a coordinator to manage the data flow between the view controller and the SwiftUI view.
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    /// Creates the `UIPageViewController` to be displayed.
    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal)
        pageViewController.dataSource = context.coordinator
        pageViewController.delegate = context.coordinator

        return pageViewController
    }

    /// Updates the `UIPageViewController` when the `currentPage` binding changes.
    func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
        pageViewController.setViewControllers(
            [context.coordinator.controllers[currentPage]], direction: .forward, animated: true)
    }

    /// The coordinator class is used to bridge the `UIPageViewController` data source and delegate methods to SwiftUI.
    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        var parent: PageViewController
        var controllers = [UIViewController]()

        init(_ pageViewController: PageViewController) {
            parent = pageViewController
            controllers = parent.pages.map { UIHostingController(rootView: $0) }
        }

        /// Returns the view controller before the currently visible view controller.
        func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let index = controllers.firstIndex(of: viewController) else {
                return nil
            }
            if index == 0 {
                return controllers.last
            }
            return controllers[index - 1]
        }

        /// Returns the view controller after the currently visible view controller.
        func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let index = controllers.firstIndex(of: viewController) else {
                return nil
            }
            if index + 1 == controllers.count {
                return controllers.first
            }
            return controllers[index + 1]
        }

        /// Called when a page transition animation completes.
        /// Updates the `currentPage` binding to reflect the currently visible page.
        func pageViewController(
            _ pageViewController: UIPageViewController,
            didFinishAnimating finished: Bool,
            previousViewControllers: [UIViewController],
            transitionCompleted completed: Bool) {
            if completed,
               let visibleViewController = pageViewController.viewControllers?.first,
               let index = controllers.firstIndex(of: visibleViewController) {
                parent.currentPage = index
            }
        }
    }
}

