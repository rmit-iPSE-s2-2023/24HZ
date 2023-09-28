//
//  EventLog.swift
//  a1-s3713342
//
//  Created by Jin on 2023-08-23.
//

import Foundation

struct EventLog: Codable {
    let id: Int
    let eventTypeId: Int
    let txHash: String
    let blockTimestamp: TimeInterval
    let blockNumber: Int
    let blockHash: String
    let data: String
    let topic0: String
    let topic1: String
    let topic2: String
    let topic3: String
    let topic4: String
    let txIndex: Int
    let logIndex: Int
}
