//
//  AddListenerFlowView1.swift
//  a1-s3713342
//
//  Created by Min on 2023/08/12.
//

import SwiftUI

// MARK: - Step 1 of AddListener flow for NewTokenListener
struct TokenTypeSelection: View {
    
    /// Get a reference to viewContext
    @Environment(\.managedObjectContext) private var viewContext
    
    /// Fetch ``NewTokenListener``/s user has already opted into
    @FetchRequest(entity: NewTokenListener.entity(), sortDescriptors: [])
    private var fetchedListeners: FetchedResults<NewTokenListener>
    
    // MARK: States
    /// Show alert if user selects listener type they are already subscribed to
    @State private var showAlert = false
    /// Keep states to track user selection
    @State private var addCoins = false
    @State private var addMediaWorks = false
    /// State to use for `isActive` argument on `NavigationView`
    @State private var goToNextScreen = false
    
    // MARK: Return body
    var body: some View {
        
        VStack {
            Spacer()
            
            /// Form question
            HStack {
                Text("What type of tokens are you interested in?")
                    .font(.title)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            
            /// ``NewTokenListener``'s ``ERCInterfaceId`` options
            /// Note: ``ERCInterfaceId``/s for ``NewtokenListener``/s that user has already opted in to should be pre-selected here
            /// "Listen for new Coins"
            NewTokenListenerTypeOption(markdown: "New **Coins**", ercInterfaceIds: [ERCInterfaceId.erc20], toggleState: $addCoins)
            /// "Listen for new Media Works"
            NewTokenListenerTypeOption(markdown: "New **Media Works**", ercInterfaceIds: [ERCInterfaceId.erc721, ERCInterfaceId.erc1155], toggleState: $addMediaWorks)
            
            Spacer()
            
            /// Navigate user to next screen **AND** simulatenously perform action. Not using `.simulatenousGesture` here as user may navigate with accessibility features so will have to target multiple gestures.
            /// Note: Using deprecated `NavigationLink` variant as `NavigationStack` is unavailable for target iOS version
            NavigationLink("Continue", isActive: Binding<Bool>(get: { goToNextScreen }, set: { goToNextScreen = $0; print("Navigating to next screen"); createNewTokenListeners() })) {
                NotificationSelection()
            }
            
        }
        // FIXME: Not sure if .alert is the right way to inform user here..
        .alert("Already listening", isPresented: $showAlert, presenting: "hello") { details in
            Button {
                //
            } label: {
                Text("OK")
            }
        }
        .padding(.horizontal, 16)
        .navigationTitle("Select token type")
        .navigationBarTitleDisplayMode(.inline)
        // End of VStack (parent)
    }
    
    // MARK: Validations
    private func alreadyListeningTo(ercInterfaceIds: [ERCInterfaceId]) -> Bool {
        let fetchedInterfaceIds = fetchedListeners.map { newTokenListener in
            return newTokenListener.ercInterfaceId!
        }
        return ercInterfaceIds.allSatisfy { ercInterfaceId in
            fetchedInterfaceIds.contains(ercInterfaceId.rawValue)
        }
    }
    
    // MARK: Core Data
    private func createNewTokenListeners() {
        var ercInterfaceIds = [ERCInterfaceId]()
        if addCoins {
            ercInterfaceIds += [ERCInterfaceId.erc20]
        }
        if addMediaWorks {
            ercInterfaceIds += [ERCInterfaceId.erc721, ERCInterfaceId.erc1155]
        }
        // Create and insert objects into context
        for ercInterfaceId in ercInterfaceIds {
            let newTokenListener = NewTokenListener(context: viewContext)
            /// ``Listener`` parent entity attribute/s
            newTokenListener.createdAt = Date()
            newTokenListener.displayTitle = ercInterfaceId.displayTitle
            newTokenListener.isListening = true
            newTokenListener.ercInterfaceId = ercInterfaceId.rawValue
        }
        print(fetchedListeners.count)
    }
    
    // MARK: View components
    private func NewTokenListenerTypeOption(markdown: String, ercInterfaceIds: [ERCInterfaceId], toggleState: Binding<Bool>) -> some View {
        Button(action: {
            /// If user is already listening to it, gently alert user if they press the option again
            if alreadyListeningTo(ercInterfaceIds: ercInterfaceIds) {
                showAlert.toggle()
            } else {
                /// Toggle the corresponding state.
                toggleState.wrappedValue.toggle()
            }
        }) {
            FormOption(optionText: markdown, isSelected: toggleState.wrappedValue)
        }
    }
}

// MARK: - Preview
struct AddNewTokenListenerTypeSelection_Previews: PreviewProvider {
    
    static let coreDataProvider = CoreDataProvider.preview
    
    static var previews: some View {
        NavigationView {
            TokenTypeSelection()
        }
        .environment(\.managedObjectContext, coreDataProvider.container.viewContext)
    }
}
