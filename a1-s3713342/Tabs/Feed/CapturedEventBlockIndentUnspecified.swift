//
//  CapturedEventBlock.swift
//  a1-s3713342
//
//  Created by Jin on 2023-08-24.
//
/// Similar to CaptureEventBlock. This struct does not specify a leading padding for indentation.
/// Instead, the indentation for display in TimeSegment is calculated by use of a custom layout.
///

import SwiftUI

struct CapturedEventBlockIndentUnspecified: View {
    
    let eventData: EventData
    
    var body: some View {
        
        // Determine whether this event was captured by a custom listener or a generic listener
        let isCustom = eventData.eventType.id < 10000    // TODO: Fix post-prototype stage
        
        HStack {
            VStack(alignment: .leading) {
                let secondaryText = isCustom ? eventData.smartContract.tokenName : eventData.eventType.name
                let primaryText = isCustom ? eventData.eventType.name : eventData.smartContract.tokenName
                
                Text(secondaryText)
                    .font(.body)
                    .foregroundColor(Color.white)
                
                Text(primaryText)
                    .font(.title.bold())
                
                Spacer()
            }
            .frame(height: 80)

            
            Spacer()
            VStack {
                Text(isCustom ? "Custom" : "Generic")
                    .foregroundColor(Color.white)
                
                Text("ERC-721")
            }
            
        }
        .padding(8)
        .background(Color.orange)
        .cornerRadius(10)
    }
}

struct CapturedEventBlockIndentUnspecified_Previews: PreviewProvider {
    
    static var previews: some View {
        let randomDummyEventData = getRandomDummyEventData()
        CapturedEventBlockIndentUnspecified(eventData: randomDummyEventData)
    }
}
