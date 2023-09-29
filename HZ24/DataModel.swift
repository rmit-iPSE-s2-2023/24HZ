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

struct Block {
    var type: BlockType
    var settings: [NotificationSetting]
}

