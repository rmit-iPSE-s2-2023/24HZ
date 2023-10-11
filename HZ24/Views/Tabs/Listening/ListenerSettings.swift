//
//  BlockSettingView.swift
//  a1-s3713342
//
//  Created by Min on 2023/08/14.
//

import SwiftUI

/// A view to configure preferences for an event Listener, such as disabling it, or deleting it.
struct ListenerSettings: View {
    
    @Environment(\.managedObjectContext) var viewContext
    
    // MARK: Parameters
    var listener: Listener
    
    // MARK: State
    @State private var deleteAlert = false  // To control the alert visibility
    
    /// Preference for ``Listener``
    @State private var isListening: Bool
    /// Preferences for ``ExistingTokenListener``
    @State private var listenForMetadataEvents: Bool
    @State private var listenForMintCommentEvents: Bool
    // TODO: Implement email/push notification functionality
    /// Notifications
    @State private var eventsOnFeed: Bool = true
    @State private var dailyEmail: Bool = false
    @State private var everyEventEmail: Bool = false
    @State private var pushNotifications: Bool = false
    
    // MARK: Initializer
    init(listener: Listener) {
        self.listener = listener
        _isListening = State(initialValue: listener.isListening)
        if let listener = listener as? ExistingTokenListener {
            _listenForMetadataEvents = State(initialValue: listener.listeningForMetadataEvents)
            _listenForMintCommentEvents = State(initialValue: listener.listeningForMintCommentEvents)
        } else {
            _listenForMetadataEvents = State(initialValue: false)
            _listenForMintCommentEvents = State(initialValue: false)
        }
    }
    
    // MARK: - Return body
    var body: some View {
        
        VStack {
            
            // MARK: Listener title
            HStack {
                Text(listener.displayTitle ?? "Unknown")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding(.leading)
                Spacer()
            }
            .padding(.bottom, 8)
            
            /// Display contract address for ``existingTokenListener``
            if let listener = listener as? ExistingTokenListener {
                HStack {
                    Text("\(listener.contractAddress ?? "")")
                        .font(.subheadline)
                        .padding(.leading)
                        .foregroundColor(.secondary)
                    Spacer()
                }
            }
            
            // MARK: Listener preferences
            List {
                /// Setting to enable/mute the ``Listener``
                Section {
                    NavigationLink(destination: ListenerEnable(listener: listener)) {
                        HStack {
                            Text("Listener")
                            Spacer()
                            Text(listener.isListening ? "On" : "Off")
                                .foregroundStyle(.gray)
                        }
                    }
                }
                
                /// ABI Event Type Preferences for ``ExistingTokenListener``
                if let listener = listener as? ExistingTokenListener {
                    Section("Event Types") {
                        Toggle(isOn: $listenForMetadataEvents) {
                            Text("Metadata updates")
                        }
                        .onChange(of: listenForMetadataEvents) { newValue in
                            listener.listeningForMetadataEvents = newValue
                            do {
                                try viewContext.save()
                            } catch {
                                print(error)
                            }
                        }
                        Toggle(isOn: $listenForMintCommentEvents) {
                            Text("Mints with comments")
                        }
                        .onChange(of: listenForMintCommentEvents) { newValue in
                            listener.listeningForMintCommentEvents = newValue
                            do {
                                try viewContext.save()
                            } catch {
                                print(error)
                            }
                        }
                    }
                }

                /// Notificaiton preferences
                Section("Notifications") {
                    Toggle(isOn: $eventsOnFeed) {
                        Text("Feed")
                    }
                    Toggle(isOn: $dailyEmail) {
                        Text("Daily email")
                    }
                    Toggle(isOn: $everyEventEmail) {
                        Text("Email for every event")
                    }
                    Toggle(isOn: $pushNotifications) {
                        Text("Push")
                    }
                    
                }
                .disabled(true)
            }
            .listStyle(.insetGrouped)
            
            Spacer()

            // MARK: Delete button
            /// Delete button to remove ``Listener`` from store
            // DeleteListenerButton
            Button {
                /// Show alert to delete ``Listener``
                deleteAlert.toggle()
            } label: {
                Text("Delete this listener")
                    .font(.title3)
                    .foregroundColor(.red)
                    .padding()
            }
            .alert("Delete listener?", isPresented: $deleteAlert) {
                // Delete
                Button("Delete", role: .destructive) {
                    /// Delete ``Listener``
                    viewContext.delete(listener)
                    do {
                        try viewContext.save()
                    } catch {
                        print(error)
                    }
                    
                }
                Button("Cancel", role: .cancel) {
                    deleteAlert.toggle()
                }
                
                
            // Cancel
            } message: {
                Text("Would you like to stop listening to this listener?")
            }
        }
        .navigationTitle("Listener settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}


// MARK: - Previews
struct ListenerSettings_Previews: PreviewProvider {
    static let coreDataProvider = CoreDataProvider.preview
    static var listener: NewTokenListener {
        let listener = NewTokenListener(context: coreDataProvider.container.viewContext)
        listener.createdAt = Date()
        listener.displayTitle = ERCInterfaceId.erc20.displayTitle
        listener.isListening = true
        return listener
    }
    static let existingTokenListener = PreviewModels.enjoyEthereumListener
    
    static var previews: some View {
        NavigationView {
            ListenerSettings(listener: listener)
                .environment(\.managedObjectContext, coreDataProvider.container.viewContext)
        }
        
        NavigationView {
            ListenerSettings(listener: existingTokenListener)
                .environment(\.managedObjectContext, coreDataProvider.container.viewContext)
        }
        
        ListenerSettings(listener: listener)
            .environment(\.managedObjectContext, coreDataProvider.container.viewContext)
        
        ListenerSettings(listener: existingTokenListener)
            .environment(\.managedObjectContext, coreDataProvider.container.viewContext)
        
        
    }
}


