//
//  FeedTab.swift
//  a1-s3713342
//
//  Created by Min on 22/8/23.
//

import SwiftUI

struct FeedTabWithCoreData: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    /// Get an array of `Date`/s to segment events by hour blocks
    private var dateIntervals = getDateIntervalsForPast24Hours(fromDate: Date())
    
    /// Fetch ``Event``/s in descending order
    @FetchRequest(entity: Event.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Event.timestamp, ascending: false)])
    private var events: FetchedResults<Event>

    // MARK: - Return body
    var body: some View {
        VStack {
            
            // MARK: Tab title
            HStack {
                Text("Events captured in the Last 24 Hours")
                    .multilineTextAlignment(.leading)
                    .font(.largeTitle.bold())
                    .padding(.leading, 10)
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
                        TimeSegmentWithCoreData(hourmarkLabel: hourmarkLabel, events: filteredEvents)
                    }
                    
                    Spacer()
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct FeedTabWithCoreData_Previews: PreviewProvider {
    
    static let coredataProvider = CoreDataProvider.preview
    
    static var previews: some View {
        NavigationView {
            FeedTabWithCoreData()
                .environment(\.managedObjectContext, coredataProvider.container.viewContext)
        }
    }
}
