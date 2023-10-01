//
// ListenerEnable.swift
// HZ24
// 
// Created by jin on 2023-10-01
// 



import SwiftUI

// FIXME: By applying the save with .onChange, user is popped back into ``ListenerSettings`` view. This shouldn't happen.
struct ListenerEnable: View {
    @Environment(\.managedObjectContext) var viewContext
    
    /// Core Data MO: ``Listener``
    var listener: Listener
    
    @State private var isListening: Bool
    
    init(listener: Listener) {
        self.listener = listener
        _isListening = State(initialValue: listener.isListening)
    }
    
    var body: some View {
        List {
            Toggle(isOn: $isListening) {
                Text("Listener")
            }
            .onChange(of: isListening) { newValue in
                /// Update MO
                listener.isListening = newValue
                do {
                    try viewContext.save()
                } catch {
                    print(error)
                }
            }
        }
        .navigationTitle("Listener")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ListenerEnable_Previews: PreviewProvider {
    static let coreDataProvider = CoreDataProvider.preview
    static var listener: NewTokenListener {
        let listener = NewTokenListener(context: coreDataProvider.container.viewContext)
        listener.createdAt = Date()
        listener.displayTitle = ERCInterfaceId.erc20.displayTitle
        listener.isListening = true
        return listener
    }
    static var previews: some View {
        // preview
        
        NavigationView {
            ListenerEnable(listener: listener)
                .environment(\.managedObjectContext, coreDataProvider.container.viewContext)
        }
        
        ListenerEnable(listener: listener)
            .environment(\.managedObjectContext, coreDataProvider.container.viewContext)

    }
}
