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
        let dateString = Date().iso8601withFractionalSeconds
        return dateString
    }
}

extension ISO8601DateFormatter {
    convenience init(_ formatOptions: Options, timeZone: TimeZone = TimeZone(secondsFromGMT: 0)!) {
        self.init()
        self.formatOptions = formatOptions
        self.timeZone = timeZone
    }
}

extension Formatter {
    static let iso8601withFractionalSeconds = ISO8601DateFormatter([.withInternetDateTime, .withFractionalSeconds])
}

extension Date {
    var iso8601withFractionalSeconds: String { return Formatter.iso8601withFractionalSeconds.string(from: self) }
}

extension String {
    var iso8601withFractionalSeconds: Date? { return Formatter.iso8601withFractionalSeconds.date(from: self) }
}
