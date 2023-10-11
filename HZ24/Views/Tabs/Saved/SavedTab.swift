//
//  SavedTab.swift
//  a1-s3713342
//
//  Created by Min on 22/8/23.
//

import SwiftUI

/// This View displays Events that have been explicitly saved by the user.
///
/// For use in a TabView.
struct SavedTab: View {
    
    // Fetch saved events from Core Data
    // MARK: Data Fetch
    @FetchRequest(entity: Event.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Event.timestamp, ascending: false)],
                  predicate: NSPredicate(format: "saved == %@", NSNumber(value: true)))
    private var savedEvents: FetchedResults<Event>
    
    // MARK: State
    @State private var selectedEvent: Event?
    
    // MARK: - Return body
    var body: some View {
        
        VStack(spacing: 20) {
            
            // MARK: Tab header
            HStack {
                Text("Saved events")
                    .multilineTextAlignment(.leading)
                    .font(.largeTitle.bold())
                Spacer()
            }
            
            // MARK: Saved Events
            ScrollView {
                
                /// If user has not saved any events, display placeholder content to guide on actions to take next.
                if savedEvents.isEmpty {
                    SavedTabPlaceholder()
                }
                
                VStack(alignment: .leading) {
                    
                    ForEach(savedEvents, id: \.id) { event in
                        EventRowItem(event: event)
                            .onTapGesture {
                                self.selectedEvent = event
                            }
                            .background(Color.orange)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                }
                
            }
            .sheet(item: $selectedEvent) { event in
                // TODO: If an Event has already been saved, this should be reflected in the detail view. e.g. button disabled or display differently to indicate it's already been saved. Maybe replace "Save" text with "Saved" or "Unsave" even..
                EventDetails(event: event)
            }
            // End of ScrollView
            
            Spacer()
        }
        .padding(.horizontal, 8)
        // End of VStack (parent)
    }
}

/// Placeholder content to display when user has no events saved.
///
/// This view should guide the user on what actions to take next.
struct SavedTabPlaceholder: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            Text("Events you save will show up on this tab.")
            /// A view that displays steps a user should take to show something instead of this placeholder view.

            HStack {
                Image(systemName: "info.circle")
                    .padding()
                Divider()
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("To save events:")
                        VStack(alignment: .leading, spacing: 2) {
                            Text("1. Navigate to **Feed**")
                            Text("2. Tap on an _Event_")
                            Text("3. Tap _Save_.")
                        }
                        .padding(.leading, 16)

                    }
                    Spacer()
                }
            }
            .padding()
            .background(.indigo.opacity(0.6))
            .border(.black)
            .cornerRadius(13)
            
            
            // TODO: Provide animation here for sake of assessment 2
        }
        .padding()
        .foregroundColor(.secondary)
        // End of VStack (parent)
    }
}

// MARK: - Previews
struct SavedTab_Previews: PreviewProvider {
    static var previews: some View {
        SavedTab()
    }
}

