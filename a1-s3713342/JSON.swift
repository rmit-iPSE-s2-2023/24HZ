//
//  JSON.swift
//  a1-s3713342
//
//  Created by Jin on 2023-08-24.
//

import Foundation

func getDummyData(userId: Int = 1) -> DummyData {
    let user = getDummyUser(userId: userId)
    let eventLogs = getCapturedEventLogs(userId: userId, toTimeInterval: Constants.dummyCurrentTimeInterval)
    return DummyData(user: user, eventLogs: eventLogs)
}

func getRandomDummyEventData(userId: Int = 1, endTime: TimeInterval = Constants.dummyCurrentTimeInterval) -> EventData {
    print("Getting random dummy event data")
    let eventData = getEventData(userId: userId, endTime: endTime)!
    let randomEvenData = eventData.randomElement()!
    print(randomEvenData)
    return randomEvenData
}

func getDummyUser(userId: Int = 1) -> User {
    let users: [User] = Bundle.main.decode(file: "Users")
    
    let user = users.filter { user in
        user.id == userId
    }
    return user.first!
}

func getEventData(userId: Int = 1, endTime: TimeInterval = Constants.dummyCurrentTimeInterval) -> [EventData]? {
    
    guard let subscribedEventTypeIds = getSubscribedEventTypeIds(userId: userId) else {
        return nil
    }
    
    let subscribedEventTypes = getSubscribedEventTypes(eventTypeIds: subscribedEventTypeIds)
    
    guard let capturedEventLogs = getCapturedEventLogs(userId: userId, toTimeInterval: endTime) else {
        return nil
    }
    
    let smartContractIds = Set(subscribedEventTypes.map { $0.smartContractId })
    let smartContracts = getSmartContracts(smartContractIds: smartContractIds)
    
    let eventData = capturedEventLogs.map { capturedEventLog in
        let eventType = subscribedEventTypes.first(where: {capturedEventLog.eventTypeId == $0.id})!
        let smartContract = smartContracts.first(where: {eventType.smartContractId == $0.id})!
        return EventData(userId: userId,
                         eventTimestamp: capturedEventLog.blockTimestamp,
                         smartContract: smartContract,
                         eventLog: capturedEventLog,
                         eventType: eventType)
    }
    
    return eventData
}

func getSmartContracts(smartContractIds: Set<Int>) -> [SmartContract] {
    var smartContracts: [SmartContract] = Bundle.main.decode(file: "SmartContracts")
        
        smartContracts = smartContracts.filter { smartContractIds.contains($0.id) }
        
        return smartContracts
}

func getCapturedEventLogs(userId: Int, toTimeInterval: TimeInterval) -> [EventLog]? {
    // Get subscribed event types for the user
    guard let subscribedEventTypeIds = getSubscribedEventTypeIds(userId: userId) else {
        return nil
    }
    
    let eventLogs: [EventLog] = Bundle.main.decode(file: "EventLogs")
        
    // Calculate the timestamp 24 hours before toTimeInterval
    let twentyFourHoursAgo = toTimeInterval - (24 * 60 * 60)
    
    // Filter event logs based on event types and timestamp criteria
    let capturedEventLogs = eventLogs.filter { eventLog in
        subscribedEventTypeIds.contains(eventLog.eventTypeId) &&
        eventLog.blockTimestamp >= twentyFourHoursAgo &&
        eventLog.blockTimestamp <= toTimeInterval
    }
        
    return capturedEventLogs.isEmpty ? nil : capturedEventLogs
    
}

func getEventLogsBetweenTimeIntervals(eventLogs: [EventLog], startTime: TimeInterval, endTime: TimeInterval) -> [EventLog]? {
    let eventLogsBetweenTimeIntervals = eventLogs.filter { eventLog in
        eventLog.blockTimestamp >= startTime && eventLog.blockTimestamp < endTime
    }
    return eventLogsBetweenTimeIntervals
}

func getSubscribedEventTypes(eventTypeIds: [Int]) -> [EventType] {
    let eventTypes: [EventType] = Bundle.main.decode(file: "EventTypes")
    let subscribedEventTypes = eventTypes.filter { eventTypeIds.contains($0.id)
    }
    return subscribedEventTypes
}

func getSubscribedEventTypeIds(userId: Int = 1) -> [Int]? {
    let eventSubscriptions: [EventSubscription] = Bundle.main.decode(file: "EventSubscriptions")
    let subscribedEventTypeIds = eventSubscriptions
        .filter { $0.userId == userId }
        .map { $0.eventTypeId }
    
    return subscribedEventTypeIds.isEmpty ? nil : subscribedEventTypeIds
}

extension Bundle {
    func decode<T: Decodable>(file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: ".json") else {
            fatalError("Could not find \(file).")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Could not load \(file).")
        }
        
        let decoder = JSONDecoder()
        
        guard let decodedData = try? decoder.decode(T.self, from: data) else {
            fatalError("Could not decode \(file).")
        }
        
        return decodedData
    }
}
