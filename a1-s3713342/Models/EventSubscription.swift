//
//  EventSubscription.swift
//  a1-s3713342
//
//  Created by Jin on 2023-08-23.
//

import Foundation

struct EventSubscription: Codable {
    let id: Int
    let userId: Int
    let eventTypeId: Int
    let subscriptionTimestamp: TimeInterval
}
