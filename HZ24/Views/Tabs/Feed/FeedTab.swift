//
//  FeedTab.swift
//  a1-s3713342
//
//  Created by Min on 22/8/23.
//

import SwiftUI

/// A View that displays Events that have been captured by the Listeners that the user has added.
///
/// For use in a TabView. Should show all the events that has been "captured" in the last 24 hours.
struct FeedTab: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    /// An array of `Date`/s to segment events by hour blocks.
    private var dateIntervals = getDateIntervalsForPast24Hours(fromDate: Date())
    
    /// Fetch ``Event``/s in descending order
    @FetchRequest(entity: Event.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Event.timestamp, ascending: false)])
    private var events: FetchedResults<Event>

    // MARK: - Return body
    var body: some View {
        VStack {
            
            // MARK: Tab header
            HStack {
                Text("Events captured in the Last 24 Hours")
                    .multilineTextAlignment(.leading)
                    .font(.largeTitle.bold())
                Spacer()
            }
            
            // MARK: Timeline
            ScrollView {
                
                VStack {
                    /// Display captured events segmented by hour blocks
                    ForEach(dateIntervals, id: \.self) { date in
                        let hourmarkLabel = dateToHourmarkLabel(date: date)
                        /// Filter events for the current hour block
                        let filteredEvents = events.filter { event in
                            let eventDate = event.timestamp!
                            let toDate = date
                            let fromDate = Calendar.current.date(byAdding: .hour, value: -1, to: date) ?? date
                            
                            return fromDate <= eventDate && eventDate < toDate
                        }
                        TimeSegment(hourmarkLabel: hourmarkLabel, events: filteredEvents)
                    }
                    
                    Spacer()
                }
            }
        }
        .padding()
    }
}

struct FeedTab_Previews: PreviewProvider {
    
    static let coredataProvider = CoreDataProvider.preview
    
    static var previews: some View {
        NavigationView {
            FeedTab()
                .environment(\.managedObjectContext, coredataProvider.container.viewContext)
        }
        .preferredColorScheme(.dark)
    }
}
