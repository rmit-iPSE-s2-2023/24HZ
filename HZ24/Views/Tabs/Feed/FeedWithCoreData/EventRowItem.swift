//
//  CapturedEventBlock.swift
//  a1-s3713342
//
//  Created by Jin on 2023-08-24.
//
/// Similar to CaptureEventBlock. This struct does not specify a leading padding for indentation.
/// Instead, the indentation for display in TimeSegment is calculated by use of a custom layout.
///

import SwiftUI

struct EventRowItem: View {
    
    let event: Event
    
    private func subheadline() -> String {
        if let event = event as? NewTokenEvent {
            return ERCInterfaceId(rawValue: event.ercInterfaceId!)?.displayTitle ?? ""
        } else {
            return event.tokenName ?? "Unknown Token"
        }
    }
    
    private func title() -> String {
        if let event = event as? NewTokenEvent {
            return event.tokenName ?? "New Coin"
        } else if let _ = event as? MetadataEvent {
            return "Metadata Update"
        } else if let _ = event as? MintCommentEvent {
            return "Minted w/ Comment"
        } else {
            return "Unknown"
        }
    }
    
    var body: some View {
        
        HStack {
            
            // Left
            VStack(alignment: .leading) {
                
                /// Subheadline (secondary) text
                Text(subheadline())
                    .font(.subheadline)
                
                /// Title (primary) text
                Text(title())
                    .font(.title.bold())
                    .foregroundColor(.black)

                Spacer()
            }
            
            Spacer()
            
            // Right
            // MARK: New Token badge
            if event is NewTokenEvent {
                VStack {
                    Text("New Token")
                        .font(.callout.bold())
                        .foregroundColor(Color.black)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color("newTokenBadge"))
                        .clipShape(RoundedRectangle(cornerRadius: 50))
                    
                    Spacer()
                }
            }
            
        }
        .frame(height: 80)
        .padding(8)
        .background(Color.orange)
        .cornerRadius(10)
        .preferredColorScheme(.dark)
    }
}

struct EventRowItem_Previews: PreviewProvider {
    
    static let coredataProvider = CoreDataProvider.preview
    static let newTokenEvent = PreviewModels.newTokenEvent
    static let metadataEvent = PreviewModels.metadataEvent
    
    static var previews: some View {
        EventRowItem(event: newTokenEvent)
            .previewDisplayName("NewTokenEvent")
        
        EventRowItem(event: metadataEvent)
            .previewDisplayName("MetadataEvent")

    }
}
