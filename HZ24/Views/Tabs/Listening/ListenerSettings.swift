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
    @State private var isListening: Bool
    
    @State private var eventsOnFeed: Bool = true
    @State private var dailyEmail: Bool = false
    @State private var everyEventEmail: Bool = false
    @State private var pushNotifications: Bool = false
    
    init(listener: Listener) {
        self.listener = listener
        _isListening = State(initialValue: listener.isListening)
    }
    
    var body: some View {
        ZStack {
            // Background color
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack() {
                
                /// Title of ``Listener``
                HStack {
                    Text(listener.displayTitle ?? "Unknown")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.leading)
                    Spacer()
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
                //                DeleteListenerButton
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
        }
        .preferredColorScheme(.dark)    // TODO: Make light/dark color variants. Defaulting everything to dark mode for now
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
    
    static var previews: some View {
        NavigationView {
            ListenerSettings(listener: listener)
                .environment(\.managedObjectContext, coreDataProvider.container.viewContext)
        }
        
        ListenerSettings(listener: listener)
            .environment(\.managedObjectContext, coreDataProvider.container.viewContext)
    }
}


