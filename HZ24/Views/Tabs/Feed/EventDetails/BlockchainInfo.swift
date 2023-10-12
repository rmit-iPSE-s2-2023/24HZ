//
// BlockchainInfo.swift
// HZ24
// 
// Created by jin on 2023-10-12
// 



import SwiftUI

/// A view that displays general blockchain information about an event.
struct BlockchainInfo: View {
    
    var event: Event
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let value = event.blockHash {
                KeyValueGroupForAdditionalInfo(key: "Block hash", value: value)
            }
            /// Block number
            KeyValueGroupForAdditionalInfo(key: "Block number", value: String(event.blockNumber))
            /// Contract address
            if let value = event.contractAddress {
                KeyValueGroupForAdditionalInfo(key: "Contract address", value: value)
            }
            /// ``ERCInterfaceId``
            if let value = event.ercInterfaceId {
                KeyValueGroupForAdditionalInfo(key: "ERC Interface", value: ERCInterfaceId(rawValue: value)?.displayTitle ?? "Unknown")
            }
            /// times
            if let value = event.transactionHash {
                KeyValueGroupForAdditionalInfo(key: "Transaction hash", value: value)
            }
        }
    }
}

/// A view that displays a key-value pair as a group.
struct KeyValueGroupForAdditionalInfo: View {
    
    var key: String
    var value: String
    
    var body: some View {
        Group {
            HStack {
                Text(key)
                    .font(.subheadline)
                Spacer()
            }
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}

struct BlockchainInfo_Previews: PreviewProvider {
    static let event = PreviewModels.newTokenEvent
    static var previews: some View {
        BlockchainInfo(event: event)
    }
}
