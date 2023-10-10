//
//  HZ24Widget.swift
//  HZ24Widget
//
//  Created by Min on 09/10/23.
//

import WidgetKit
import SwiftUI
import Intents
import CoreData


@main
struct HZ24Widgets: Widget {
    let persistenceController = PersistenceController.shared
    let kind: String = "24HZ"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            HZ24WidgetsEntryView(entry: entry)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .configurationDisplayName("Latest Event")
        .description("Quickly view the latest event right from your home screen.")
    }
}




