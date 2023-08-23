//
//  TimeSegment.swift
//  a1-s3713342
//
//  Created by Jin on 2023-08-23.
//

import SwiftUI

struct TimeSegment: View {
    
    // Parameters
    let eventLogs: [EventLog]?
    let toTimestamp: TimeInterval
    let fromTimestamp: TimeInterval
    let date: Date
    let hourmarkLabel: String
    
    init(toTimestamp: TimeInterval, eventLogs: [EventLog]? = []) {
        self.toTimestamp = toTimestamp
        self.fromTimestamp = timeIntervalOfPreviousHourMark(toTimestamp: toTimestamp)
        self.date = Date(timeIntervalSince1970: toTimestamp)
        self.hourmarkLabel = timeIntervalToHourmarkLabel(timeInterval: toTimestamp)
        if let unwrappedEventLogs = eventLogs {
            self.eventLogs = getEventLogsBetweenTimeIntervals(eventLogs: unwrappedEventLogs, startTime: fromTimestamp, endTime: toTimestamp)
        } else {
            self.eventLogs = nil
        }
    }
    
    var body: some View {

        VStack {
            Hourmark(label: hourmarkLabel)
            if let unwrappedEventLogs = eventLogs {
                ForEach(unwrappedEventLogs, id: \.id) { log in
                    Text(log.txHash)
                        .font(.title)
                        .foregroundColor(Color.white)
                }
            }
        }
        .background(Color.black)
    }
}

struct TimeSegment_Previews: PreviewProvider {
    static var previews: some View {
        TimeSegment(toTimestamp: Constants.dummyCurrentTimeInterval)
    }
}
