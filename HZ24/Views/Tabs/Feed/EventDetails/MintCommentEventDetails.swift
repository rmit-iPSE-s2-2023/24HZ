//
// MintCommentEventDetails.swift
// HZ24
// 
// Created by jin on 2023-10-12
//

import SwiftUI

struct MintCommentEventDetails: View {
    
    var event: MintCommentEvent
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            /// Event type; the ABI type of the captured event.
            KeyValueGroup(key: "Event type", value: event.abiEventName ?? "Unknown")
            /// Comment
            if let update = event.mintComment {
                KeyValueGroup(key: "Comment", value: update)
            }
            // TODO: Fetch and display ENS
            /// Sender's contract address
            if let update = event.sender {
                KeyValueGroup(key: "Sender", value: update)
            }
            /// Quantity
            KeyValueGroup(key: "Mint quantity", value: String(event.quantity))
        }
        // End of VStack (parent)
    }
}

struct MintCommentEventDetails_Previews: PreviewProvider {
    static let event = PreviewModels.mintCommentEvent
    
    static var previews: some View {
        MintCommentEventDetails(event: event)
    }
}
