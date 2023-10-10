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
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            HStack{
                VStack(alignment: .leading, spacing: 3) {
                    if let event = entry.event {
                        Text(event.tokenName ?? "No Recent Event")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(Color.orange
                            )
                        
                        Text(event.tokenSymbol ?? "")
                            .font(.subheadline)
                            .foregroundColor(Color.white)
                        
                        Spacer()
                        
                        Text(eventDescription(for: event))
                            .font(.caption)
                            .foregroundColor(Color.gray)
                        
                        HStack {
                            VStack(alignment: .trailing) {
                                Text("Captured at \(eventTimestamp(for: event))")
                                    .font(.caption2)
                                    .foregroundColor(Color.gray)
                            }
                        }
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

        Group {
            HZ24WidgetsEntryView(entry: SimpleEntry(date: Date(), event: event))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .previewDisplayName("Small Widget")

            HZ24WidgetsEntryView(entry: SimpleEntry(date: Date(), event: event))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
                .previewDisplayName("Medium Widget")

            HZ24WidgetsEntryView(entry: SimpleEntry(date: Date(), event: event))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
                .previewDisplayName("Large Widget")
        }
    }
}
