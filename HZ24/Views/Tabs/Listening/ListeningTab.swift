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
    //test
    @State var isEditingMode: Bool = false
    
    
    
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
                
                if !isEditingMode {
                    /// Tab heading
                    HStack {
                        Text("here is what you're listening to...")
                            .multilineTextAlignment(.leading)
                            .font(.largeTitle.bold())
                            .padding(.leading, 10)
                        Spacer()
                    }
                } else {
                    HStack {
                    Text("swipe right to navigate to the settings page.")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.leading)
                        .font(.largeTitle.bold())
                        .padding(.leading, 10)
                        Spacer()
                }
                }
                
                // MARK: Listeners
                if !listeners.isEmpty {
                    /// List of listeners
                    ForEach(Array(listeners.enumerated()), id: \.element) { index, listener in
                        GenericListenerView(
                            listener: listener, isEditingMode: $isEditingMode
                        )
                    }
                    .contentShape(Rectangle())
                    .onLongPressGesture {
                        self.isEditingMode.toggle()
                    }
                    //Go back
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
                        NavigationLink(destination: ListenerTypeSelection(), isActive: $navigateToNext) {
                            Text("Add a listener")
                                .padding()
                        }
                        .isDetailLink(false)
                        Spacer()
                    }
                }
                
                Spacer()
                
                if !isEditingMode {
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
                
            }
        }
        .preferredColorScheme(.dark)
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
            // NavigationLink for gear icon
            NavigationLink("", destination: ListenerSettings(listener: listener), isActive: $navigateToSetting)
                .opacity(0)
            
            // Displaying the gear icon with its green background
            HStack {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(showGearIcon ? .green : .clear)
                    .frame(width: abs(offset.width + 30), height: 70)
                    .overlay(
                        Image(systemName: "gearshape")
                            .foregroundColor(.white)
                            .font(.system(size: 30, weight: .bold))
                            .opacity(showGearIcon ? 1 : 0)
                    )
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        // Animate the item back to its original position smoothly when the gear icon is clicked
                        self.offset = .zero
                        self.showGearIcon = false
                    }
                    
                    // After the animation completes, navigate to ListenerSettingsView
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.navigateToSetting = true
                    }
                }
            Spacer() // Pushes the gear icon to the left
        }
            ///Editing Mode
            if isEditingMode {
                ListenerRowItem(listener: listener)
                    .offset(x: offset.width) // Offset the view based on the swipe gesture's width.
                    .rotationEffect(isEditingMode ? Angle(degrees: danceTrigger ? 1 : -1) : Angle(degrees: 0)) // Rotate the view slightly for a 'dancing' effect when in editing mode.
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

