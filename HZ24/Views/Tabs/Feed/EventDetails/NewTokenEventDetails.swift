//
// NewTokenEventDetails.swift
// HZ24
// 
// Created by jin on 2023-10-12
// 



import SwiftUI

struct NewTokenEventDetails: View {
    
    var event: NewTokenEvent
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            /// Contract deployer's address
            // TODO: Also display ENS, if available
            KeyValueGroup(key: "Deployed by", value: event.deployerAddress ?? "Unknown")
            
        }
        // End of VStack (parent)
    }
}

struct NewTokenEventDetails_Previews: PreviewProvider {
    static let event = PreviewModels.newTokenEvent
    static var previews: some View {
        NewTokenEventDetails(event: event)
    }
}
