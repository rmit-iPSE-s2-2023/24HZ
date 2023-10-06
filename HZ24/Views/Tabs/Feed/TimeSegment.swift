//
//  TimeSegment.swift
//  a1-s3713342
//
//  Created by Jin on 2023-08-23.
//

import SwiftUI

struct TimeSegment: View {
    
    /// Parameters
    var filteredEventData: [EventData]
    let toTimestamp: TimeInterval
    @State var selectedEvent: EventData?
    
    init(toTimestamp: TimeInterval, eventData events: [EventData]) {
        self.toTimestamp = toTimestamp
        
        // Capture eventData in a local variable before using it in the closure
        self.filteredEventData = []
        let fromTimestamp = timeIntervalOfPreviousHourMark(toTimestamp: toTimestamp)
        self.filteredEventData = events.filter { event in
            return event.eventTimestamp < toTimestamp && event.eventTimestamp >= fromTimestamp
        }
    }
    
    var body: some View {
        // Use custom layout for iOS 16+
        #if swift(>=5.5) && canImport(_Concurrency) && canImport(Layout)
        if #available(iOS 16.0, *) {
            IndentedWithHeaderLayout(indentSize: 50) {
                
                /// Hourmark label
                Text(timeIntervalToHourmarkLabel(timeInterval: toTimestamp))
                    .font(.caption)
                    .foregroundStyle(.gray)
                
                HorizontalDivider()
                
                /// Array of event blocks
                ForEach(filteredEventData, id: \.eventLog.id) { event in
                    CapturedEventBlock(eventData: event)
                        .onTapGesture {
                            self.selectedEvent = event
                        }
                }
                .sheet(item: $selectedEvent) { event in
                    EventDetailView(event: event)
                }
                
            }
        } else {
                EmptyView()
        }
        #endif
            
        // fallback for iOS 15-
        VStack {
            Hourmark(label: timeIntervalToHourmarkLabel(timeInterval: toTimestamp))
            ForEach(filteredEventData, id: \.eventLog.id) { event in
                CapturedEventBlockPadded(eventData: event)
                    .onTapGesture {
                        self.selectedEvent = event
                    }
            }
            .sheet(item: $selectedEvent) { event in
                EventDetailView(event: event)
            }
            }
    }

}

struct HorizontalDivider: View {
    var body: some View {
        VStack {
            Divider()
                .background(.gray)
        }
    }
}

struct TimeSegment_Previews: PreviewProvider {
    static var previews: some View {
        let eventData = getEventData()
        TimeSegment(toTimestamp: Constants.dummyCurrentTimeInterval, eventData: eventData!)
    }
}

