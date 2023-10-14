//
//  ListeningTab.swift
//  a1-s3713342
//
//  Created by Min on 22/8/23.
//

import SwiftUI
import CoreData
import Combine

/// A view that displays all the event listeners the user has added.
///
/// For use in a TabView.
struct ListeningTab: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: Listener.entity(), sortDescriptors: [])
    private var listeners: FetchedResults<Listener>
    
    // TODO: Is this needed?
    /// State to manage navigation to the next view.
    ///
    /// Triggered when the user wants to navigate to the next screen in a sequence.
    @State private var navigateToAddListenerFlow = false
    
    @State var isEditingMode: Bool = false
    
    // MARK: - Return body
    var body: some View {
        VStack {

                // MARK: Tab header
                HStack {
                    Text("Hey" + ",")
                        .font(.largeTitle.bold())
                        .foregroundColor(.accentColor)
                    Spacer()
                }
            if !isEditingMode {
                HStack {
                    Text("here is what you're listening to...")
                        .multilineTextAlignment(.leading)
                        .font(.largeTitle.bold())
                        .padding(.leading, 1)
                    Spacer()
                }
            } else {
                /// Tab heading in editing mode
                HStack {
                Text("swipe right to navigate to the settings page.")
                    .foregroundColor(.red)
                    .multilineTextAlignment(.leading)
                    .font(.largeTitle.bold())
                    .padding(.leading, 1)
                    Spacer()
            }
            }
            
            ScrollView {
                // MARK: Listeners
                if !listeners.isEmpty {
                    /// List of listeners
                    ForEach(listeners, id: \.self) { listener in
                        if !isEditingMode {
                            NavigationLink(destination: ListenerSettings(listener: listener)) {
                                GenericListenerView(listener: listener, isEditingMode: $isEditingMode)
                            }
                            .foregroundColor(.primary)
                    } else {
                         // In editing mode, we only display the listener view without navigation capability
                         GenericListenerView(listener: listener, isEditingMode: $isEditingMode)
                             .contentShape(Rectangle())
                             .onTapGesture {
                                 // No action on tap when in editing mode
                             }
                     }
                 }
                    // Long press gesture to toggle editing mode
                    .simultaneousGesture(LongPressGesture().onEnded { _ in
                        self.isEditingMode.toggle()
                    })
                    
                    /// Go back button
                    if isEditingMode {
                        Button(action: {
                            self.isEditingMode = false
                        }) {
                            Text("Go Back")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(8)
                        }
                        .padding()
                    }
                    
                } else {
                    /// Placeholder if user has no listeners
                    VStack {
                        Spacer()
                        Text("No listeners added")
                            .font(.title2)
                            .foregroundColor(.gray)
                        NavigationLink(destination: ListenerTypeSelection(), isActive: $navigateToAddListenerFlow) {
                            Text("Add a listener")
                                .padding()
                        }
                        .isDetailLink(false)
                        Spacer()
                    }
                }
            }
            
            Spacer()
            
        }
        .padding(.horizontal, 8)
        .overlay(
            VStack {
                Spacer()
                // MARK: Add listener button
                if !isEditingMode {
                    /// Navigate user to root of `AddEventListener` flow
                HStack {
                    Spacer()
                    NavigationLink(destination: ListenerTypeSelection(), isActive: $navigateToAddListenerFlow) {
                        AddListenerButton()
                            .foregroundColor(.primary)
                    }
                    .isDetailLink(false)
                }
                .padding(.bottom, 32)
                .padding(.trailing, 16)
            }
            }
            
        )
        // End of VStack (parent)
    }
}

/// ``GenericListenerView`` represents a single listener in the list, with swipe actions for editing.
struct GenericListenerView: View {
    @Environment(\.managedObjectContext) var viewContext
    /// The listener being represented by this view
    var listener: Listener
    /// The offset for the swipe gesture.
    @State private var offset = CGSize.zero
    /// A binding to determine if the app is in editing mode
    @Binding var isEditingMode: Bool
    @State private var showGearIcon = false
    @State private var animateDance = false
    @State private var navigateToSetting = false
    
    /// Trigger for the Items animation
    @State var danceTrigger = false
    
    var body: some View {
        ZStack {
            //TODO: GEAR ICON to navigate Listener settings
            // Displaying the gear icon with its green background
            HStack {
                ///Editing Mode
                if isEditingMode {
                    ListenerRowItem(listener: listener)
                        .offset(x: offset.width) // Offset the view based on the swipe gesture's width.
                        .rotationEffect(isEditingMode ? Angle(degrees: danceTrigger ? 1 : 1) : Angle(degrees: 0)) // Rotate the view slightly for a 'dancing' effect when in editing mode.
                        .animation(Animation.easeInOut(duration: 0.2).repeatForever(autoreverses: true), value: danceTrigger) // Apply the 'dancing' animation.
                        .onAppear {
                            danceTrigger = isEditingMode // Start the 'dancing' animation when the view appears if in editing mode.
                        }
                        .onChange(of: isEditingMode) { newValue in
                            danceTrigger = newValue // Update the 'dancing' animation state based on the editing mode.
                        }
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    if isEditingMode {
                                        if gesture.translation.width > 0 {
                                            offset.width = gesture.translation.width // Update the offset based on the user's swipe.
                                            showGearIcon = true // Show the gear icon when swiped.
                                        }
                                    }
                                }
                                .onEnded { gesture in
                                    let swipeThreshold: CGFloat = 100.0
                                    if gesture.translation.width > swipeThreshold {
                                        offset.width = 50 // Set the offset to show the gear icon completely.
                                        showGearIcon = true
                                    } else {
                                        offset = .zero // Reset the offset if the swipe is less than the threshold.
                                        showGearIcon = false // Hide the gear icon if the swipe is less than the threshold.
                                    }
                                }
                        )
                        .onTapGesture {
                            offset = .zero
                            isEditingMode = false
                            showGearIcon = false
                        }
                } else {
                    ListenerRowItem(listener: listener)
                        .onAppear {
                            showGearIcon = false
                            danceTrigger = false
                            offset = .zero // Reset position and states when the view reappears.
                        }
                }
            }
        }
    }
}


// MARK: - Previews
struct ListeningTab_Previews: PreviewProvider {
    static let coreDataProvider = CoreDataProvider.preview
    static var previews: some View {
        // Must wrap in NavigationView to prevent "No entity found" warnings
        NavigationView {
            ListeningTab()
                .environment(\.managedObjectContext, coreDataProvider.container.viewContext)
        }
        
        ListeningTab()
            .environment(\.managedObjectContext, coreDataProvider.container.viewContext)
    }
}


