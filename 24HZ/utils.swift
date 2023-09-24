//
//  utils.swift
//  a1-s3713342
//
//  Created by Jin on 2023-08-23.
//

import Foundation

func timeIntervalOfPreviousHourMark(toTimestamp: TimeInterval) -> TimeInterval {
    let date = Date(timeIntervalSince1970: toTimestamp)
    
    let calendar = Calendar.current
    let components = calendar.dateComponents([.hour, .minute], from: date)
    
    guard let hour = components.hour, let minute = components.minute else {
        return toTimestamp // Return the input timestamp if components extraction fails
    }
    
    let adjustedHour: Int
    
    if minute == 0 {
        adjustedHour = hour - 1
    } else {
        adjustedHour = hour
    }
    
    let previousHourDate = calendar.date(bySettingHour: adjustedHour, minute: 0, second: 0, of: date) ?? date
    return previousHourDate.timeIntervalSince1970
}

func timeIntervalToHourmarkLabel(timeInterval: TimeInterval) -> String {
    let date = Date(timeIntervalSince1970: timeInterval)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    let hourmarkLabel = dateFormatter.string(from: date)
    return hourmarkLabel
}

func getTimeIntervalsForPast24Hours(from time: TimeInterval) -> [TimeInterval] {
    
    let finalHourmarkTimeInterval = timeIntervalOfPreviousHourMark(toTimestamp: time)
    
    let secondsInHour: TimeInterval = 60 * 60
    let twentyFourHoursInSeconds: TimeInterval = 24 * secondsInHour
    
    let endTime = finalHourmarkTimeInterval
    let startTime = endTime - twentyFourHoursInSeconds
    
    var timeIntervals: [TimeInterval] = [time]
    
    var currentTime = endTime
    while currentTime >= startTime {
        timeIntervals.append(currentTime)
        currentTime -= secondsInHour
    }
    
    return timeIntervals
}


//let timestamp = Date().timeIntervalSince1970 // Current timestamp
//let previousHourTimestamp = timeIntervalOfPreviousHourMark(from: timestamp)
