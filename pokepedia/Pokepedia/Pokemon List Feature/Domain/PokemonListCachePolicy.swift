//
//  PokemonListCachePolicy.swift
//  Pokepedia
//
//  Created by Vasiliy Klyotskin on 7/8/23.
//

import Foundation

enum PokemonListCachePolicy {
    private static let calendar = Calendar(identifier: .gregorian)
    
    private static var maxCacheAgeInDays: Int {
        return 7
    }
    
    static func validate(_ timestamp: Date, against date: Date) -> Bool {
        guard let maxCacheAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: timestamp) else {
            return false
        }
        return date < maxCacheAge
    }
}
