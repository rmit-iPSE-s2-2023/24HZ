//
//  FeedTab.swift
//  a1-s3713342
//
//  Created by 민철 on 22/8/23.
//

import SwiftUI

struct FeedTab: View {
    
    let user: User?
    let eventLogs: [EventLog]?
    let currentTime: TimeInterval = Constants.dummyCurrentTimeInterval
    
    init() {
        user = getDummyUser(userId: 1)
        if let unwrappedUser = user {
            eventLogs = getCapturedEventLogs(userId: unwrappedUser.id, toTimeInterval: Constants.dummyCurrentTimeInterval)
        } else {
            eventLogs = nil
        }
    }
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack {
                    if let unwrappedUser = user {
                        Text(unwrappedUser.email)
                            .foregroundColor(Color.white)
                    } else {
                        Text("User not found")
                            .foregroundColor(Color.white)
                    }
                    
                    if let unwrappedEventLogs = eventLogs {
                        Text("\(unwrappedEventLogs.count)")
                            .foregroundColor(Color.white)
                    } else {
                        Text("0 Events found")
                            .foregroundColor(Color.white)
                    }
                    
                    Text("Events captured in the Last 24 Hours")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                    
                    // Divide captured EventLogs by hour blocks
                    let timeIntervals = getTimeIntervalsForPast24Hours(from: currentTime)
                    
                    ForEach(timeIntervals, id: \.self) { timeInterval in
                        TimeSegment(toTimestamp: timeInterval, eventLogs: eventLogs)
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

struct FeedTab_Previews: PreviewProvider {
    static var previews: some View {
        FeedTab()
    }
}
