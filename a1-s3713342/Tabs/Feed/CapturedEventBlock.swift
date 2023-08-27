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

struct CapturedEventBlock: View {
    
    let eventData: EventData
    
    var body: some View {
        
        // TODO: - Determine whether event was captured by Generic or Custom event listener
        let isGeneric = eventData.eventType.id > 10000    // Fix post-prototype
        
        HStack {
            VStack(alignment: .leading) {
                
                let secondaryText = isGeneric ? eventData.eventType.name : eventData.smartContract.tokenName
                let primaryText = isGeneric ? eventData.smartContract.tokenName :  eventData.eventType.name
                
                Text(secondaryText)
                    .font(.subheadline)
                    .foregroundColor(Color.white)
                
                Text(primaryText)
                    .font(.title.bold())
                
                Spacer()
            }
            .frame(height: 80)

            
            Spacer()
            if isGeneric {
                VStack {
                    Text("New Token")
                        .font(.callout.bold())
                        .foregroundColor(Color.black)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color("newTokenBadge"))
                        .clipShape(RoundedRectangle(cornerRadius: 50))
                    
                    Spacer()
                }
            }

            
        }
        .frame(height: 80)
        .padding(8)
        .background(Color.orange)
        .cornerRadius(10)
    }
}

struct CapturedEventBlockIndentUnspecified_Previews: PreviewProvider {
    
    static var previews: some View {
        let randomDummyEventData = getRandomDummyEventData()
        CapturedEventBlock(eventData: randomDummyEventData)
    }
}
