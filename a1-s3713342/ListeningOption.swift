//
//  ListeningOption.swift
//  a1-s3713342
//
//  Created by 민철 on 2023/08/12.
//

import SwiftUI

struct ListeningOption: Identifiable {
    var id = UUID()
    var name: String
    var feed24Hz: Bool = true // Default value is true
    var onceADayEmail: Bool = false
    var everyEventEmail: Bool = false
    var mobileNotification: Bool = false
}
