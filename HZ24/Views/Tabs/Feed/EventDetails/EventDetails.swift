//
//  EventDetailView.swift
//  a1-s3713342
//
//  Created by Jin on 2023-08-26.
//

import SwiftUI

/// A view that displays detailed information about an event.
///
/// Should be used as content for a sheet.
struct EventDetails: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    
    var event: Event
    
    // MARK: State
    @State private var showAdditionalInfo = false
    
    private func navTitle() -> String {
        if event is NewTokenEvent {
            return "New Token"
        } else if event is MetadataEvent {
            return "Metadata Update"
        } else if event is MintCommentEvent {
            return "Mint w/ Comment"
        } else {
            return event.entity.name ?? "Event"
        }
    }
    
    private func title() -> String {
        event.tokenName ?? "Unknown Token"
    }
    
    private func timestamp() -> String {
        if let date = event.timestamp {
            return dateToHourmarkLabel(date: date)
        } else {
            return "Unknown"
        }
    }
    
    private func saveEvent() -> Void {
        /// Save event
        event.saved = true
        dismiss()
        do {
            try viewContext.save()
        } catch {
            print(error)
        }
    }
    
    // MARK: - Return body
    var body: some View {
        
        // MARK: Event Details
        NavigationView {
            List {
                
                /// Heading: title
                HStack {
                    Text(title())
                        .font(.largeTitle.bold())
                        .foregroundColor(.accentColor)
                    Spacer()
                }
                
                HStack {
                    /// Symbol
                    if let symbol = event.tokenSymbol {
                        Text(symbol)
                            .opacity(0.5)
                    }
                    Spacer()
                    
                    /// Timestamp
                    HStack {
                        Text("Captured at")
                            .foregroundColor(.secondary)
                        Text("\(timestamp())")
                            .foregroundColor(.accentColor)
                    }
                    .font(.subheadline)

                }
                
                // MARK: Event-specific info
                /// Event specific information
                Section {
                    
                    /// for ``NewTokenEvent``
                    if let event = event as? NewTokenEvent {
                        NewTokenEventDetails(event: event)
                    }
                    
                    /// for ``metadataEvent``
                    if let event = event as? MetadataEvent {
                        MetadataEventDetails(event: event)
                    }
                    
                    if let event = event as? MintCommentEvent {
                        MintCommentEventDetails(event: event)
                    }
                    
                    /// for
                    
                } header: {
                    Text("Event info")
                }
                // End of VStack (Event-specific info)
                
                
                // MARK: On-chain info
                /// Section showing technical blockchain info
                // TODO: This section should be expandable to abstract away technical information for more friendly experience
                Section {
                    if showAdditionalInfo {
                        BlockchainInfo(event: event)
                    }
                } header: {
                    Button {
                        withAnimation {
                            showAdditionalInfo.toggle()
                        }
                    } label: {
                        HStack {
                            Text("Additional info")
                                .foregroundColor(.secondary)
                                .font(.footnote)
                            Spacer()
                            Image(systemName: showAdditionalInfo ? "chevron.down" : "chevron.right")
                        }
                        
                    }
                }
            }
            .listStyle(.insetGrouped)
            // End of List
            // MARK: Toolbar
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
            .navigationTitle(navTitle())
            .navigationBarTitleDisplayMode(.inline)

        }
        .overlay(alignment: .bottom, content: {
            // MARK: Save button
            Button(action: saveEvent) {
                Label("Save", systemImage: "bookmark")
            }
            .buttonStyle(.bordered)
        })
        .preferredColorScheme(.dark)
        // End of NavigationView (parent)
    }
}

struct EventDetails_Previews: PreviewProvider {
    static let coredataProvider = CoreDataProvider.preview
    
    static let newTokenEvent = PreviewModels.newTokenEvent
    static let metadataEvent = PreviewModels.metadataEvent
    static let mintCommentEvent = PreviewModels.mintCommentEvent
    
    static var previews: some View {
        
        NavigationView {
            Text("Parent View")
                .sheet(item: .constant(newTokenEvent)) { event in
                    EventDetails(event: event)
                }
        }
        .environment(\.managedObjectContext, coredataProvider.container.viewContext)
        .previewDisplayName("NewTokenEvent")
        
        Text("Parent View")
            .sheet(item: .constant(metadataEvent)) { event in
                EventDetails(event: event)
            }
            .environment(\.managedObjectContext, coredataProvider.container.viewContext)
            .previewDisplayName("MetadataEvent")
        
        Text("Parent View")
            .sheet(item: .constant(mintCommentEvent)) { event in
                EventDetails(event: event)
            }
            .environment(\.managedObjectContext, coredataProvider.container.viewContext)
            .previewDisplayName("MintCommentEvent")

    }
}


