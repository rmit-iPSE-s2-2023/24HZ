//
//  CapturedEventBlock.swift
//  a1-s3713342
//
//  Created by Jin on 2023-08-24.
//

import SwiftUI

struct CapturedEventBlockPadded: View {
    
    let eventData: EventData
    
    var body: some View {
        
        CapturedEventBlock(eventData: eventData)
            .padding(.leading, 40)
    }
}

struct CapturedEventBlock_Previews: PreviewProvider {
    
    static var previews: some View {
        let randomDummyEventData = getRandomDummyEventData()
        CapturedEventBlockPadded(eventData: randomDummyEventData)
    }
}
