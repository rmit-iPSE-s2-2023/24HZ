//
//  data.swift
//  a1-s3713342
//
//  Created by Jin on 2023-08-23.
//

import Foundation

func getDummyUser(userId: Int = 1) -> User? {
    guard let url = Bundle.main.url(forResource: "Users", withExtension: "json", subdirectory: "DummyData") else {
        fatalError("JSON file not found")
    }
    
    do {
        let jsonData = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let users = try decoder.decode([User].self, from: jsonData)
        
        let user = users.filter { user in
            user.id == userId
        }
        
        return user[0]
        
    } catch {
        print("Error decoding JSON: \(error)")
        return nil
    }
}


func getCapturedEventLogs(userId: Int, toTimeInterval: TimeInterval) -> [EventLog]? {
    // Get subscribed event types for the user
    guard let eventTypes = getSubscribedEventTypes(userId: userId) else {
        return nil
    }
    
    // Load JSON data from the file
    guard let url = Bundle.main.url(forResource: "EventLogs", withExtension: "json", subdirectory: "DummyData") else {
        return nil // JSON file not found
    }
    
    do {
        let jsonData = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let eventLogs = try decoder.decode([EventLog].self, from: jsonData)
        
        // Calculate the timestamp 24 hours before toTimeInterval
        let twentyFourHoursAgo = toTimeInterval - (24 * 60 * 60)
        
        // Filter event logs based on event types and timestamp criteria
        let capturedEventLogs = eventLogs.filter { eventLog in
            eventTypes.contains(eventLog.eventTypeId) &&
            eventLog.blockTimestamp >= twentyFourHoursAgo &&
            eventLog.blockTimestamp <= toTimeInterval
        }
        
        return capturedEventLogs.isEmpty ? nil : capturedEventLogs
    } catch {
        print("Error decoding JSON: \(error)")
        return nil
    }
}

func getEventLogsBetweenTimeIntervals(eventLogs: [EventLog], startTime: TimeInterval, endTime: TimeInterval) -> [EventLog]? {
    let eventLogsBetweenTimeIntervals = eventLogs.filter { eventLog in
        eventLog.blockTimestamp >= startTime && eventLog.blockTimestamp < endTime
    }
    return eventLogsBetweenTimeIntervals
}

func getSubscribedEventTypes(userId: Int) -> [Int]? {
    guard let url = Bundle.main.url(forResource: "EventSubscriptions", withExtension: "json", subdirectory: "DummyData") else {
        return nil // JSON file not found
    }
    
    do {
        let jsonData = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let eventSubscriptions = try decoder.decode([EventSubscription].self, from: jsonData)
        
        let subscribedEventTypes = eventSubscriptions
            .filter { $0.userId == userId }
            .map { $0.eventTypeId }
        
        return subscribedEventTypes.isEmpty ? nil : subscribedEventTypes
    } catch {
        print("Error decoding JSON: \(error)")
        return nil
    }
}

// Usage
//if let subscribedEventTypes = getSubscribedEventTypes(userId: 1) {
//    print("Subscribed Event Types: \(subscribedEventTypes)")
//} else {
//    print("No subscribed event types found for the user.")
//}

