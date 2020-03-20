//
//  DateUtility.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/19/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation

struct DateUtility {
    static func getFormattedDateAsString() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        let formattedDate = formatter.string(from: date)
        return formattedDate
    }
}
