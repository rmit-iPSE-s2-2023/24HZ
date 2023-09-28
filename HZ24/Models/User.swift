//
//  User.swift
//  a1-s3713342
//
//  Created by Jin on 2023-08-23.
//

import Foundation

struct User: Codable {
    let id: Int
    let email: String
    let password: String
    let name: String
    let pfpurl: String
    let registrationTimestamp: TimeInterval
}
