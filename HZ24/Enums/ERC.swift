//
//  ERCType.swift
//  a1-s3713342
//
//  Created by Jin on 2023-08-24.
//

import Foundation

/// Types of ERC interfaces.
///
/// This enum's raw value represents the ERC interface signatures. A computed property is implemented for display purposes.
enum ERCInterfaceId: String, CaseIterable {
    case erc20 = "0x36372b07"
    case erc721 = "0x80ac58cd"
    case erc1155 = "0xd9b67a26"
    /// For future reference:
    //    case erc721metadata = "0x5b5e139f"
    
    /// A display value for an ERC interface.
    var displayTitle: String {
          switch self {
          case .erc20:
               return "Coins"
          case .erc721:
               return "Media Works: 721s"
          case .erc1155:
               return "Media Works: 1155s"
          }
     }
}
