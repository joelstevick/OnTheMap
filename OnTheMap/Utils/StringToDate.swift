//
//  StringToDate.swift
//  OnTheMap
//
//  Created by Joel Stevick on 5/14/22.
//

import Foundation

func stringToDate(isoDate: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
    if let date = dateFormatter.date(from:isoDate) {
        return date
    } else {
        print("Date CONVERSION ERROR", isoDate)
        return dateFormatter.date(from: "2000-01-01T00:00:00Z")!
    }
    
}
