//
//  Date+Cache.swift
//  PokepediaTests
//
//  Created by Vasiliy Klyotskin on 8/22/23.
//

import Foundation

extension Date {
    func minusDetailCacheMaxAge() -> Date {
        return adding(days: -detailCacheMaxAgeInDays)
    }
    
    private var detailCacheMaxAgeInDays: Int {
        return 1
    }
}
