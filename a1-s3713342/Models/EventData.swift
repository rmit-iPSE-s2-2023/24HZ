//
//  EventData.swift
//  a1-s3713342
//
//  Created by Jin on 2023-08-24.
//

import Foundation

struct EventData: Codable, Identifiable {
    var id = UUID()
    
    let userId: Int
    let eventTimestamp: TimeInterval
//    let eventListenerType: String
    let smartContract: SmartContract
    let eventLog: EventLog
    let eventType: EventType
    
    static let getDummyEventData: [EventData] = Bundle.main.decode(file: "EventData.json")
}
