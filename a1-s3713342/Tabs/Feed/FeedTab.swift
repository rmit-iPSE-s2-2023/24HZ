//
//  FeedTab.swift
//  a1-s3713342
//
//  Created by 민철 on 22/8/23.
//

import SwiftUI

struct FeedTab: View {
    
    @Binding var user: User
    @Binding var currentTime: TimeInterval
    @State var eventData: [EventData] = getEventData()!

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            ScrollView {
                
                VStack {
                    
                    Text("Events captured in the Last 24 Hours")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                    
                    // Get an array of TimeIntervals to segment events by hour blocks
                    let timeIntervals = getTimeIntervalsForPast24Hours(from: currentTime)
                    
                    // Display captured events segmented by hour blocks
                    ForEach(timeIntervals, id: \.self) { timeInterval in
                        TimeSegment(toTimestamp: timeInterval, eventData: eventData)
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

struct FeedTab_Previews: PreviewProvider {
    static var previews: some View {
        let user = getDummyUser() // Create a constant user for preview
        let currentTime = Constants.dummyCurrentTimeInterval // Create a constant currentTime for preview
        
        return FeedTab(user: .constant(user), currentTime: .constant(currentTime))
    }
}
