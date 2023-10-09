//
//  ListeningTab.swift
//  a1-s3713342
//
//  Created by Min on 22/8/23.
//

import SwiftUI
import CoreData
import Combine

/// `ListeningTab` is the main view responsible for displaying the list of listeners for the user.
struct ListeningTab: View {
    // Reference to the CoreData's context
    @Environment(\.managedObjectContext) private var viewContext
    
    // MARK: - FetchRequest
    // Binding to an array of blocks that the user has added.
    // This will be a shared state between different views.
    // TODO: This should be Core Data ``Listener``s
    @FetchRequest(entity: Listener.entity(), sortDescriptors: [])
    private var listeners: FetchedResults<Listener>
    
    // TODO: Get rid of this, no user info will be stored
    @Binding var user: User
    
    // MARK: - State
    // State to manage navigation to the next view.
    // Triggered when the user wants to navigate to the next screen in a sequence.
    // TODO: Is this needed?
    @State private var navigateToNext = false
    
    // TODO: Is this needed?
    // State to manage navigation to a custom view.
    // Triggered when the user wants to navigate to a custom screen.
    @State private var navigateToCustom = false
    
    // Icon display state variables
    @State private var showTrashIcon = false
    @State private var showGearIcon = false
    
    @State private var circleOffset: CGFloat = 0
    @State private var circleScale: CGFloat = 0
    
    
    // MARK: Return body
    var body: some View {
        
        ZStack {
            VStack {
                
                // MARK: Tab header
                /// User's name
                HStack {
                    Text(user.name + ",")
                        .multilineTextAlignment(.leading)
                        .font(.largeTitle.bold())
                        .foregroundColor(.orange)
                        .padding(.leading, 10)
                    Spacer()
                }
                /// Tab heading
                HStack {
                    Text("here is what you're listening to...")
                        .multilineTextAlignment(.leading)
                        .font(.largeTitle.bold())
                        .padding(.leading, 10)
                    Spacer()
                }
                
                // MARK: Listeners
                if !listeners.isEmpty {
                    /// List of listeners
                    ForEach(Array(listeners.enumerated()), id: \.element) { index, listener in
                        GenericListenerView(
                            listener: listener,
                            showTrashIcon: $showTrashIcon,
                            showGearIcon: $showGearIcon,
                            circleOffset: $circleOffset,
                            circleScale: $circleScale
                        )
                    }
                    
                } else {
                    /// Placeholder if user has no listeners
                    VStack {
                        Spacer()
                        Text("No listeners added")
                            .font(.title2)
                            .foregroundColor(.gray)
                        NavigationLink(destination: ListenerTypeSelection(), isActive: $navigateToNext) {
                            Text("Add a listener")
                                .padding()
                        }
                        .isDetailLink(false)
                        Spacer()
                    }
                }
                
                Spacer()
                
                // MARK: AddListenerButton
                /// Navigate user to root of `AddEventListener` flow
                NavigationLink(destination: ListenerTypeSelection(), isActive: $navigateToNext) {
                    HStack {
                        Spacer()
                        AddListenerButton()
                            .offset(y: -20)
                            .padding(.bottom, 20)
                            .padding(.trailing, 20)
                    }
                }
                .isDetailLink(false)
            }
            
            // TODO: Describe this part of UI
            HStack {
                // Trash icon located at the bottom
                if showTrashIcon {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 100, height: 100)
                        .overlay(
                            Image(systemName: "trash")
                                .foregroundColor(.white)
                        )
                        .scaleEffect(circleScale)
                        .offset(x: circleOffset / 2)
                        .transition(.scale)
                }
                
                Spacer()
                
                // Gear icon located at the bottom
                if showGearIcon {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 100, height: 100)
                        .overlay(
                            Image(systemName: "gearshape")
                                .foregroundColor(.white)
                        )
                        .scaleEffect(circleScale)
                        .offset(x: circleOffset / 2)
                        .transition(.scale)
                }
            }
            .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        }
        .preferredColorScheme(.dark)
    }
}

/// ``GenericListenerView`` represents a single listener in the list, with swipe actions for editing and deletion.
struct GenericListenerView: View {
    @Environment(\.managedObjectContext) var viewContext
    
    var listener: Listener
    
    @State private var offset = CGSize.zero
    @State private var isRemoved = false
    @State private var navigateToSetting = false
    @Binding var showTrashIcon: Bool
    @Binding var showGearIcon: Bool
    
    @Binding var circleOffset: CGFloat
    @Binding var circleScale: CGFloat
    
    // MARK: Return body
    var body: some View {
        ZStack {
            NavigationLink("", destination: ListenerSettings(listener: listener), isActive: $navigateToSetting)
                .opacity(0)
            
            ListenerRowItem(listener: listener)
        }
        .offset(x: offset.width, y: offset.height)
        .rotationEffect(Angle(degrees: Double(offset.width / 10)))
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                    showTrashIcon = gesture.translation.width < 0 // trash
                    showGearIcon = gesture.translation.width > 0   // gear
                    circleOffset = -gesture.translation.width
                    circleScale = max(0, min(abs(gesture.translation.width) / 50, 1))
                }
                .onEnded { gesture in
                    let swipeThreshold: CGFloat = 100.0
                    if gesture.translation.width < -swipeThreshold {
                        offset = CGSize(width: -1000, height: 0)
                        // TODO: The current gesture implementation has issues and requires further development.
                        // TODO: Fix the issue where the block disappears when swiping right to enter the settings view.
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            // Remove the listener from CoreData
                            viewContext.delete(listener)
                            try? viewContext.save()
                        }
                    } else if gesture.translation.width > swipeThreshold {
                        offset = CGSize(width: 1000, height: 0)
                        navigateToSetting = true
                    } else {
                        offset = .zero
                    }
                    showTrashIcon = false // hide
                    showGearIcon = false  // hide
                    circleOffset = 0
                    circleScale = 0
                    // TODO: Ensure interaction with the icon only leads to deletion or entering the settings view (when the block touches the icon).
                }
        )
        .animation(.easeInOut, value: offset)
    }
}

// MARK: - Previews
struct ListeningTab_Previews: PreviewProvider {
    static let coreDataProvider = CoreDataProvider.preview
    static let user = getDummyUser() // Create a constant user for preview
    static var previews: some View {
        // Must wrap in NavigationView to prevent "No entity found" warnings
        NavigationView {
            ListeningTab(user: .constant(user))
                .environment(\.managedObjectContext, coreDataProvider.container.viewContext)
        }
    }
}

func AddListenerButton() -> some View {
    // '+' symbol
    Image(systemName: "plus")
        .font(.system(size: 40))
        .frame(width: 60, height: 60)
        .foregroundColor(.white)
        .overlay(
            // Circular border
            Circle()
                .stroke(Color.white, lineWidth: 2)
        )
}

