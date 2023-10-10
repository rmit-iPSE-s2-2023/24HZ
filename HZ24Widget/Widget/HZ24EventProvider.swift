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
        let event = try? getLatestEvent(from: PersistenceController.shared.container.viewContext)
        return SimpleEntry(date: Date(), event: event)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        do {
            let event = try getLatestEvent(from: PersistenceController.shared.container.viewContext)
            let entry = SimpleEntry(date: Date(), event: event)
            completion(entry)
        } catch {
            print(error)
        }
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        do {
            let event = try getLatestEvent(from: PersistenceController.shared.container.viewContext)
            let entry = SimpleEntry(date: Date(), event: event)
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        } catch {
            print(error)
        }
    }
    
    func getLatestEvent(from context: NSManagedObjectContext) throws -> Event? {
        let request: NSFetchRequest<Event> = Event.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        request.fetchLimit = 1
        
        let results = try context.fetch(request)
        return results.first
    }
}

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

func eventTimestamp(for event: Event) -> String {
    if let date = event.timestamp {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: date)
    } else {
        return "Unknown"
    }
}

