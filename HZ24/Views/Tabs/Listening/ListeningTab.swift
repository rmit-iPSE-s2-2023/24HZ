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
                    .font(.title.bold())
                Spacer()
            }
            
            // MARK: Listeners
            if !listeners.isEmpty {
                /// List of listeners
                ForEach(listeners, id: \.self) { listener in
                    NavigationLink(destination: ListenerSettings(listener: listener)) {
                        ListenerRowItem(listener: listener)
                    }
                    .foregroundColor(.white)
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
            
            Spacer()
            
            // MARK: Add listener button
            /// Navigate user to root of `AddEventListener` flow
            NavigationLink(destination: ListenerTypeSelection(), isActive: $navigateToAddListenerFlow) {
                HStack {
                    Spacer()
                    AddListenerButton()
                        .offset(y: -20)
                        .padding(.bottom, 20)
                        .padding(.trailing, 20)
                        .foregroundColor(.white)
                }
            }
            .isDetailLink(false)
        }
        .padding(.horizontal, 8)
        // End of VStack (parent)
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
        .preferredColorScheme(.dark)
    }
}


