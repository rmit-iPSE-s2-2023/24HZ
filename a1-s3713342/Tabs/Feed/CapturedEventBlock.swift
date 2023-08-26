//
//  CapturedEventBlock.swift
//  a1-s3713342
//
//  Created by Jin on 2023-08-24.
//

import SwiftUI

struct CapturedEventBlock: View {
    
    let eventData: EventData
    
    var body: some View {
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
        .padding(.leading, 40)
    }
}

struct CapturedEventBlock_Previews: PreviewProvider {
    
    static var previews: some View {
        let randomDummyEventData = getRandomDummyEventData()
        CapturedEventBlock(eventData: randomDummyEventData)
    }
}
