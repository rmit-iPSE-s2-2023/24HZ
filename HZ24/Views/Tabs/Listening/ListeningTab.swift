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
            HStack {
                Text("here is what you're listening to...")
                    .multilineTextAlignment(.leading)
                    .font(.largeTitle.bold())
                Spacer()
            }
            
            ScrollView {
                // MARK: Listeners
                if !listeners.isEmpty {
                    /// List of listeners
                    ForEach(listeners, id: \.self) { listener in
                        NavigationLink(destination: ListenerSettings(listener: listener)) {
                            ListenerRowItem(listener: listener)
                        }
                        .foregroundColor(.primary)
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
                //TODO: Complex gesture
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


