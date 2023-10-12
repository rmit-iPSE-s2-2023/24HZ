//
// MetadataEventDetails.swift
// HZ24
// 
// Created by jin on 2023-10-12
// 

struct KeyValueGroup: View {
    var key: String
    var value: String
    
    var body: some View {
        VStack(alignment:.leading, spacing: 6) {
            HStack {
                Text(key)
                    .font(.headline)
                Spacer()
            }
            Text(value)
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
}

import SwiftUI

struct MetadataEventDetails: View {
    
    var event: MetadataEvent
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            /// Event type; the ABI type of the captured event.
            KeyValueGroup(key: "Event type", value: event.abiEventName ?? "Unknown")
            /// Updated Animation
            if let update = event.updatedAnimationURI {
                KeyValueGroup(key: "Updated animation URI", value: update)
            }
            /// Updated Contract URI
            if let update = event.updatedContractURI {
                KeyValueGroup(key: "Updated contract URI", value: update)
            }
            /// Updated Freeze At
            if let update = event.updatedContractURI {
                KeyValueGroup(key: "Updated contract URI", value: update)
            }
            /// Updated Image URI
            if let update = event.updatedImageURI {
                KeyValueGroup(key: "Updated image URI", value: update)
            }
            /// Updated Metadata Base
            if let update = event.updatedImageURI {
                KeyValueGroup(key: "Updated image URI", value: update)
            }
            /// Updated Metadata Base
            if let update = event.updatedMetadataBase {
                KeyValueGroup(key: "Updated metadata URI", value: update)
            }
            /// Updated Metadata Extension
            if let update = event.updatedMetadataExtension {
                KeyValueGroup(key: "Updated metadata extension", value: update)
            }
            /// Updated Name
            if let update = event.updatedName {
                KeyValueGroup(key: "Updated token name", value: update)
            }
            /// Updated Description
            if let update = event.updatedNewDescription {
                KeyValueGroup(key: "Updated token description", value: update)
            }
        }
//        .padding()
//        .background(.secondary.opacity(0.13))
//        .cornerRadius(13)
        // End of VStack (parent)
    }
}

struct MetadataEventDetails_Previews: PreviewProvider {
    static let event = PreviewModels.metadataEvent
    
    static var previews: some View {
        MetadataEventDetails(event: event)
    }
}
