//
//  AddListenerFlowView2.swift
//  a1-s3713342
//
//  Created by Min on 2023/08/12.
//

import SwiftUI

// MARK: - Last step of AddListener flow
/// User selects how they would like event notifications delivered
// TODO: Implement functionality for emails and push notifications
// FIXME: Currently events are only loaded in ``FeedTab``
struct NotificationSelection: View {
    
    /// Get a reference to viewContext
    @Environment(\.managedObjectContext) private var viewContext
    
    /// Notification preference or user to specify
    @State private var selectedNotificationSettings: [NotificationSetting] = [.eventsFeed]
    @State private var showAlert = false
    @State private var saveError = false
    @State private var noChanges = false
    @State private var goToNextScreen = false
    
    var body: some View {
        
        VStack {
            Spacer()
            
            /// Form question
            HStack {
                Text("How would you like to be notified?")
                    .font(.title)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            
            /// List of options for notification settings
            ForEach(NotificationSetting.allCases, id: \.self) { option in
                NotificationOption(option: option)
            }
            
            Spacer()
            
            /// Navigate user to success screen **AND** save ``NewTokenListener`` in context to store
            /// Note: Using deprecated `NavigationLink` variant as `NavigationStack` is unavailable for target iOS version
            NavigationLink("Save", isActive: Binding<Bool>(get: { goToNextScreen }, set: { goToNextScreen = $0; print("Navigating to next screen"); saveNewTokenListeners() })) {
                Success()
            }
            
            Spacer()
            
        }
        .padding(.horizontal, 16)
        .navigationTitle("Select notifications")
        .navigationBarTitleDisplayMode(.inline)
        // End of VStack (parent)
    }
    
    // MARK: Core Data
    private func saveNewTokenListeners() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                saveError.toggle()
            }
        } else {
            noChanges.toggle()
        }
    }
    
    // Refactored notification setting button
    private func NotificationOption(option: NotificationSetting) -> some View {
        Button(action: {
            // FIXME: Implement functionality for email/push notifications
            if option != .eventsFeed {
                showAlert.toggle()
            }
        }) {
            FormOption(optionText: option.rawValue, isSelected: selectedNotificationSettings.contains(option))
        }
        .opacity(option == NotificationSetting.eventsFeed ? 1 : 0.5)
        .alert("Currently not supported", isPresented: $showAlert, presenting: "hello") { details in
            Button {
                //
            } label: {
                Text("OK")
            }
        }
    }
}

// MARK: - NotificationSetting options
enum NotificationSetting: String, CaseIterable {
    case eventsFeed = "via my **24HZ Feed**"
    case onceADayEmail = "**Once-a-Day Email**"
    case emailEveryEvent = "an **Email for Every Event**"
    case mobileNotifications = "**Push Notifications**"
}

// MARK: - Previews
struct AddListenerNotificationTypeSelection_Previews: PreviewProvider {
    
    static let coreDataProvider = CoreDataProvider.preview
    
    static var previews: some View {
        
        /// Wrapped view to enable navigation
        NavigationView {
            NotificationSelection()
        }
        .environment(\.managedObjectContext, coreDataProvider.container.viewContext)
        .previewDisplayName("Wrapped in NavView")
        
        /// Unwrapped view for meaningful view debugging with: `Editor > Canvas > Show Selection`
        NotificationSelection()
            .environment(\.managedObjectContext, coreDataProvider.container.viewContext)
            .previewDisplayName("Unwrapped")
        
    }
}

