//
//  utils.swift
//  a1-s3713342
//
//  Created by Jin on 2023-08-23.
//

import Foundation

// MARK: - Date Conversions
/// A method to converts a `Date` to a display `String` in the format "HH:mm".
func dateToHourmarkLabel(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    let hourmarkLabel = dateFormatter.string(from: date)
    return hourmarkLabel
}

/// A method to get the hourly `Date` marks for the last 24 hours before given Date.
func getDateIntervalsForPast24Hours(fromDate date: Date) -> [Date] {
    
    let finalHourmarkDate = dateOfPreviousHourMark(to: date)
    
    let secondsInHour: TimeInterval = 60 * 60
    let twentyFourHoursInSeconds: TimeInterval = 24 * secondsInHour
    
    let endTime = finalHourmarkDate.timeIntervalSince1970
    let startTime = endTime - twentyFourHoursInSeconds
    
    var dateIntervals: [Date] = [date]
    
    var currentTime = endTime
    while currentTime >= startTime {
        dateIntervals.append(Date(timeIntervalSince1970: currentTime))
        currentTime -= secondsInHour
    }
    
    return dateIntervals
}

/// A method to get the `Date` of the last hour mark.
///
/// Example: Given a `Date` that represents 7.20am, it will return the `Date` for 7am; the hour mark.
func dateOfPreviousHourMark(to date: Date) -> Date {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
    return calendar.date(from: components) ?? date
}
