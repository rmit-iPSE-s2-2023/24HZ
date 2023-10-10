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
    let kind: String = "MyTextWidgets"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            HZ24WidgetsEntryView(entry: entry)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .configurationDisplayName("My Widget")
        .description("This widget shows the latest event.")
    }
}




