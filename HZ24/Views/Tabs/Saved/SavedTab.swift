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
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 15) {
                Text("To save events:")
                    .font(.title2)
                
                Text("1. Navigate to **Feed**")
                    .padding(.leading, 20)
                
                Text("2. Tap on an _Event_")
                    .padding(.leading, 20)
                
                Text("3. Tap _Save_")
                    .padding(.leading, 20)
                
            }
            .frame(width: 330, alignment: .leading)
            .padding(.vertical, 40)
            .padding(.horizontal, 20)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.primary, lineWidth: 2)
                
            )
            
            // TODO: Provide animation here for sake of assessment 2
            VStack(spacing: 15) {
                Image(systemName: "video")
                    .resizable()
                    .foregroundColor(.secondary)
                    .frame(width: 100, height: 70) // Adjust this to fit the icon's aspect ratio
                Text("<helper_animation>")
                    .foregroundColor(.secondary)
            }
            .frame(width: 330, height: 200)
            .padding(.vertical, 40)
            .padding(.horizontal, 20)
            .overlay(
                Rectangle()
                    .stroke(.foreground, lineWidth: 2)
            )
        }
    }
}

// MARK: - Previews
struct SavedTab_Previews: PreviewProvider {
    static var previews: some View {
        SavedTab()
            .preferredColorScheme(.dark)
    }
}

