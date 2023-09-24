//
//  SmartContract.swift
//  a1-s3713342
//
//  Created by Jin on 2023-08-23.
//

import Foundation

struct SmartContract: Codable {
    let id: Int
    let address: String
    let chainId: Int
    let tokenName: String
    let tokenSymbol: String
    let deploymentBlock: Int
    let deploymentTx: String
    let deploymentTimestamp: TimeInterval
}
