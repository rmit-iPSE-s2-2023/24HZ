//
//  ListeningTab.swift
//  a1-s3713342
//
//  Created by Min on 22/8/23.
//

import SwiftUI
import CoreData
import Combine

struct ListeningTab: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    // MARK: - Properties
    
    // Binding to an array of blocks that the user has added.
    // This will be a shared state between different views.
    // TODO: This should be Core Data ``Listener``s
    @FetchRequest(entity: Listener.entity(), sortDescriptors: [])
    private var listeners: FetchedResults<Listener>
    
    // TODO: Get rid of this, no user info will be stored
    @Binding var user: User
    
    // State to manage navigation to the next view.
    // Triggered when the user wants to navigate to the next screen in a sequence.
    // TODO: Is this needed?
    @State private var navigateToNext = false
    
    // TODO: Is this needed?
    // State to manage navigation to a custom view.
    // Triggered when the user wants to navigate to a custom screen.
    @State private var navigateToCustom = false
    
    var body: some View {
        VStack {
            
            HStack {
                Text(user.name + ",")
                    .multilineTextAlignment(.leading)
                    .font(.largeTitle.bold())
                    .foregroundColor(.orange)
                Spacer()
            }
            
            HStack {
                Text("here is what you're listening to...")
                    .multilineTextAlignment(.leading)
                    .font(.largeTitle.bold())
                Spacer()
            }
            
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
                    NavigationLink(destination: ListenerTypeSelection(), isActive: $navigateToNext) {
                        Text("Add a listener")
                            .padding()
                    }
                    .isDetailLink(false)
                    Spacer()
                }
            }
            
            Spacer()
            
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
        .padding()
    }
}

// MARK: - Previews
struct ListeningTab_Previews: PreviewProvider {
    static let coreDataProvider = CoreDataProvider.preview
    static let user = getDummyUser() // Create a constant user for preview
    static var previews: some View {
        // Must wrap in NavigationView to prevent "No entity found" warnings
        NavigationView {
            ListeningTab(user: .constant(user))        .environment(\.managedObjectContext, coreDataProvider.container.viewContext)
        }
        .preferredColorScheme(.dark)
    }
}

func AddListenerButton() -> some View {
    // '+' symbol
    Image(systemName: "plus")
        .font(.system(size: 40))
        .frame(width: 60, height: 60)
        .foregroundColor(.white)
        .background(Color.black)
        .overlay(
            // Circular border
            Circle()
                .stroke(Color.white, lineWidth: 2)
        )
}

