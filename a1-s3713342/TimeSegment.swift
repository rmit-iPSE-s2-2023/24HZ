//
//  TimeSegment.swift
//  a1-s3713342
//
//  Created by Jin on 2023-08-23.
//

import SwiftUI

struct TimeSegment: View {
    
    // Parameters
    var filteredEventData: [EventData]
    let toTimestamp: TimeInterval
    let fromTimestamp: TimeInterval
    let date: Date
    
    init(toTimestamp: TimeInterval, eventData events: [EventData]) {
        self.toTimestamp = toTimestamp
        self.fromTimestamp = timeIntervalOfPreviousHourMark(toTimestamp: toTimestamp)
        self.date = Date(timeIntervalSince1970: toTimestamp)
        // Capture eventData in a local variable before using it in the closure
        self.filteredEventData = []
        self.filteredEventData = events.filter { event in
            return event.eventTimestamp < toTimestamp && event.eventTimestamp >= self.fromTimestamp
        }
    }
    
    var body: some View {

        VStack {
            Hourmark(label: timeIntervalToHourmarkLabel(timeInterval: toTimestamp))
            ForEach(filteredEventData, id: \.eventLog.id) { event in
                CapturedEventBlock(eventData: event)
            }
        }
        .background(Color.black)
    }
}

struct TimeSegment_Previews: PreviewProvider {
    static var previews: some View {
        let eventData = getEventData()
        TimeSegment(toTimestamp: Constants.dummyCurrentTimeInterval, eventData: eventData!)
    }
}

//struct EventLogListItemView: View {
//
//    let isGeneric: Bool
//    let eventLog: EventLog
//    let eventData: EventData
//
//    var body: some View {
//        HStack {
//            VStack(alignment: .leading) {
//                let secondaryText = isGeneric ? "Generic EventType" : "Token Name"
//                let primaryText = isGeneric ? "Token Name" : "EventType Name"
//                Text(secondaryText)
//                    .font(.body)
//                    .foregroundColor(Color.white)
//
//                Text(primaryText)
//                    .font(.title.bold())
//                Spacer()
//            }
//            .frame(height: 80)
//
//            Spacer()
//            VStack {
//                Text("Generic")
//                    .foregroundColor(Color.white)
//                Text("ERC-721")
//            }
//
//        }
//        .padding(8)
//        .background(Color.purple)
//        .cornerRadius(10)
//        .padding(.leading, 40)
//    }
//}
