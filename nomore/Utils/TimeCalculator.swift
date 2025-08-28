//
//  TimeCalculator.swift
//  nomore
//
//  Created by Aa on 2025-08-21.
//

import Foundation

func calculateTimeComponents(from startDate: Date, to endDate: Date = Date(), calendar: Calendar = .current) -> TimeComponents {
    var from = startDate
    var months = 0
    var days = 0
    var hours = 0
    var minutes = 0
    var seconds = 0

    // Count months by adding months until we exceed endDate
    while let next = calendar.date(byAdding: .month, value: 1, to: from), next <= endDate {
        from = next
        months += 1
    }

    // Days
    while let next = calendar.date(byAdding: .day, value: 1, to: from), next <= endDate {
        from = next
        days += 1
    }

    // Hours
    while let next = calendar.date(byAdding: .hour, value: 1, to: from), next <= endDate {
        from = next
        hours += 1
    }

    // Minutes
    while let next = calendar.date(byAdding: .minute, value: 1, to: from), next <= endDate {
        from = next
        minutes += 1
    }

    // Seconds
    while let next = calendar.date(byAdding: .second, value: 1, to: from), next <= endDate {
        from = next
        seconds += 1
    }

    return TimeComponents(months: months, days: days, hours: hours, minutes: minutes, seconds: seconds)
}
