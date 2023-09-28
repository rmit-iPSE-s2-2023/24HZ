//
//  ERCType.swift
//  a1-s3713342
//
//  Created by Jin on 2023-08-24.
//

import Foundation

// TODO: Make this a computed property of ERCInterfaceId
enum ERCType: String {
    case erc721 = "ERC-721"
    case erc20 = "ERC-20"
    case erc1155 = "ERC-1155"
}

enum ERCInterfaceId: String, CaseIterable {
    case erc20 = "0x36372b07"
    case erc721 = "0x80ac58cd"
    case erc721metadata = "0x5b5e139f"
    case erc1155 = "0xd9b67a26"
}
