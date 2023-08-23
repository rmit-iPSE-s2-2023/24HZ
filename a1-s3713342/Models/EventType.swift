//
//  EventType.swift
//  a1-s3713342
//
//  Created by Jin on 2023-08-23.
//

import Foundation

struct EventType: Codable {
    let id: Int
    let smartContractId: Int
    let name: String
    let description: String
    let methodId: Int
    let abi: String
}
