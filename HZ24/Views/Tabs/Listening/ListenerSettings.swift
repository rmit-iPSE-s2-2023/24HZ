//
//  BlockSettingView.swift
//  a1-s3713342
//
//  Created by Min on 2023/08/14.
//

import SwiftUI

struct ListenerSettings: View {
    
    @Environment(\.managedObjectContext) var viewContext
    
    /// Core Data MO: ``Listener``
    var listener: Listener
    
    @State private var deleteAlert = false  // To control the alert visibility
    
    ///
    @State private var isListening: Bool
    /// Preferences for ``ExistingTokenListener``
    @State private var listenForMetadataEvents: Bool
    @State private var listenForMintCommentEvents: Bool
    
    @State private var eventsOnFeed: Bool = true
    @State private var dailyEmail: Bool = false
    @State private var everyEventEmail: Bool = false
    @State private var pushNotifications: Bool = false
    
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
    
    var body: some View {
        
        VStack {
            
            /// Title of ``Listener``
            HStack {
                Text(listener.displayTitle ?? "Unknown")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding(.leading)
                Spacer()
            }
            .padding(.bottom, 8)
            
            if let listener = listener as? ExistingTokenListener {
                HStack {
                    Text("\(listener.contractAddress ?? "")")
                        .font(.subheadline)
                        .padding(.leading)
                        .foregroundColor(.secondary)
                    Spacer()
                }
            }
            
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
//                List {
//                    Toggle(isOn: $isListening) {
//                        Text("Listener")
//                    }
//                    .onChange(of: isListening) { newValue in
//                        /// Update MO
//                        listener.isListening = newValue
//                        do {
//                            try viewContext.save()
//                        } catch {
//                            print(error)
//                        }
//                    }
//                }
//                .navigationTitle("Listener")
//                .navigationBarTitleDisplayMode(.inline)
                /// ABI Event Type Preferences
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

                
                /// Notificaiton Settings
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


