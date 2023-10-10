//
//  HZ24EventProvider.swift
//  HZ24WidgetExtension
//
//  Created by Min on 09/10/23.
//

import WidgetKit
import CoreData

struct SimpleEntry: TimelineEntry {
    let date: Date
    let event: Event?
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        let event = try? getLatestEvent()
        return SimpleEntry(date: Date(), event: event)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        do {
            let event = try getLatestEvent()
            let entry = SimpleEntry(date: Date(), event: event)
            completion(entry)
        } catch {
            print(error)
        }
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        do {
            let event = try getLatestEvent()
            let entry = SimpleEntry(date: Date(), event: event)
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        } catch {
            print(error)
        }
    }
    
    func getLatestEvent() throws -> Event? {
        let context = PersistenceController.preview.container.viewContext
        let request: NSFetchRequest<Event> = Event.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        request.fetchLimit = 1
        let result = try context.fetch(request)
        return result.first
    }
}


