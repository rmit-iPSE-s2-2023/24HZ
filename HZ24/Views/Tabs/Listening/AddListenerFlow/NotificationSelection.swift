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
        ZStack {
            /// Background
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                /// Form question
                HStack {
                    Text("How would you like to be notified?")
                        .foregroundColor(.white)
                        .font(.title)
                    Spacer()
                }
//                .frame(maxWidth: .infinity)
                
                /// List of options for notification settings
                ForEach(NotificationSetting.allCases, id: \.self) { option in
                    NotificationOption(option: option)
                }
                
                Spacer() // Empty space at the bottom
                
                /// Navigate user to success screen **AND** save ``NewTokenListener`` in context to store
                /// Note: Using deprecated `NavigationLink` variant as `NavigationStack` is unavailable for target iOS version
                NavigationLink("Save", isActive: Binding<Bool>(get: { goToNextScreen }, set: { goToNextScreen = $0; print("Navigating to next screen"); saveNewTokenListeners() })) {
                    Success()
                }
            }
        }
        // FIXME: Debugging
        .onAppear {
            print(viewContext.hasChanges)
        }
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
            CheckableFormOption(isChecked: selectedNotificationSettings.contains(option))
                .overlay(Text(try! AttributedString(markdown: option.rawValue)).font(.title3).foregroundColor(.black))
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
    case eventsFeed = "I want events on my **24HZ Feed**"
    case onceADayEmail = "I also want **Once-a-Day Email**"
    case emailEveryEvent = "I also want an **Email for Every Event**"
    case mobileNotifications = "I also want **Mobile Notifications**"
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

