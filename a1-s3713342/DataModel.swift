//
//  DataModel.swift
//  a1-s3713342
//
//  Created by Min on 2023/08/14.
//

import Foundation

enum BlockType: String, CaseIterable {
    case zoraNFTs = "Zora NFTs"
    case coins = "Coins"
    case customNFTs = "Custom NFTs"
}

enum NotificationSetting: String, CaseIterable {
    case eventsFeed = "I want events on my 24HZ feed"
    case onceADayEmail = "I also want once-a-day email"
    case emailEveryEvent = "I also want an email for every event"
    case mobileNotifications = "I also want mobile notifications"
}

struct Block {
    var type: BlockType
    var settings: [NotificationSetting]
}

