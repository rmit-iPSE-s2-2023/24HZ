//
//  TimeSegment.swift
//  a1-s3713342
//
//  Created by Jin on 2023-08-23.
//

import SwiftUI
import CoreData

struct TimeSegment: View {

    var hourmarkLabel: String
    var events: [Event]

    @State private var selectedEvent: Event?
    
    var body: some View {
        
        // TODO: Use custom layout for iOS 16+
//        #if swift(>=5.5) && canImport(_Concurrency) && canImport(Layout)
//        if #available(iOS 16.0, *) {
//            IndentedWithHeaderLayout(indentSize: 50) {
//
//                /// Hourmark label
//                Text(timeIntervalToHourmarkLabel(timeInterval: toTimestamp))
//                    .font(.caption)
//                    .foregroundStyle(.gray)
//
//                HorizontalDivider()
//
//                /// Array of event blocks
//                ForEach(filteredEventData, id: \.eventLog.id) { event in
//                    CapturedEventBlock(eventData: event)
//                        .onTapGesture {
//                            self.selectedEvent = event
//                        }
//                }
//                .sheet(item: $selectedEvent) { event in
//                    EventDetailView(event: event)
//                }
//
//            }
//        } else {
//                EmptyView()
//        }
//        #endif
            
        // fallback for iOS 15-
        VStack {
            
            Hourmark(label: hourmarkLabel)
            
            ForEach(events, id: \.id) { event in
                EventRowItem(event: event)
                    .padding(.leading, 40)
                    .onTapGesture {
                        self.selectedEvent = event
                    }
            }
        }
        .sheet(item: $selectedEvent) { event in
            EventDetails(event: event)
        }
        .preferredColorScheme(.dark)
    }

}

struct TimeSegment_Previews: PreviewProvider {
    
    static let coredataProvider = CoreDataProvider.preview
    static let events: [Event] = PreviewModels.makeNewTokenEvents(3)
    
    static var previews: some View {
        TimeSegment(hourmarkLabel: "11:00", events: events)
            .environment(\.managedObjectContext, coredataProvider.container.viewContext)
    }
}

