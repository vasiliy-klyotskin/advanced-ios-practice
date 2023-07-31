//
//  Date+Cache.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 7/31/23.
//

import Foundation

extension Date {
    func minusFeedCacheMaxAge() -> Date {
        return adding(days: -feedCacheMaxAgeInDays)
    }
    
    private var feedCacheMaxAgeInDays: Int {
        return 7
    }
    
    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }

    func adding(days: Int, calendar: Calendar = Calendar(identifier: .gregorian)) -> Date {
        return calendar.date(byAdding: .day, value: days, to: self)!
    }
}
