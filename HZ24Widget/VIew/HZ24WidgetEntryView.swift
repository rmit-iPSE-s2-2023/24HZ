//
//  HZ24WidgetEntryView.swift
//  HZ24WidgetExtension
//
//  Created by Min on 09/10/23.
//

import SwiftUI
import WidgetKit

struct HZ24WidgetsEntryView: View {
    var entry: Provider.Entry
    
    // e
    func eventDescription(for event: Event) -> String {
        if event is NewTokenEvent {
            return "new token event"
        } else if event is MetadataEvent {
            return "metadata event"
        } else if event is MintCommentEvent {
            return "mint comment event"
        } else {
            return "unknown event"
        }
    }
    
    var body: some View {
        ZStack {
            // Set the background to black
            Color.black.edgesIgnoringSafeArea(.all)
            HStack{
                VStack(alignment: .leading, spacing: 3) {
                    if let event = entry.event {
                        // Display tokenName in bold red
                        Text(event.tokenName ?? "No Recent Event")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(Color.red)
                        
                        // Display tokenSymbol in white with a smaller font
                        Text(event.tokenSymbol ?? "")
                            .font(.subheadline)
                            .foregroundColor(Color.white)
                        
                        Spacer()
                        
                        // Display the event type at the bottom
                        Text(eventDescription(for: event))
                            .font(.caption)
                            .foregroundColor(Color.gray)
                    } else {
                        Text("No Recent Event Test")
                            .foregroundColor(Color.white)
                    }
                }
                .padding()
                Spacer()
            }
        }
    }
}

struct HZ24Widgets_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let event = try? Provider().getLatestEvent(from: context)
        return HZ24WidgetsEntryView(entry: SimpleEntry(date: Date(), event: event))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
