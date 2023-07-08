//
//  SharedTestHelpers.swift
//  Pokepedia-iOS-AppTests
//
//  Created by Василий Клецкин on 5/30/23.
//

import UIKit
import Pokepedia

func anyURL() -> URL {
    .init(string: "http://any-url.com")!
}

func anyData() -> Data {
    .init("any \(anyId()) data".utf8)
}

func anyDate() -> Date {
    .distantPast
}

func anyId() -> String {
    UUID().uuidString
}

func anyName() -> String {
    "name \(anyId())"
}

func anyNSError() -> NSError {
    .init(domain: "any domain", code: 1)
}

func makeListPokemon(specialType: PokemonListItemType? = nil) -> PokemonListItem {
    .init(
        id: anyId(),
        name: anyName(),
        imageUrl: anyURL(),
        physicalType: itemType(),
        specialType: specialType
    )
}

func itemType() -> PokemonListItemType {
    .init(color: anyId(), name: anyName())
}

extension UIView {
    public func isVisible() -> Bool {
        guard window != nil else { return false }
        var currentView: UIView = self
        while let superview = currentView.superview {
            if (superview.bounds).intersects(currentView.frame) == false {
                return false;
            }
            if currentView.isHidden {
                return false
            }
            currentView = superview
        }
        return true
    }
}

extension UIControl {
    func simulate(event: UIControl.Event) {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: event)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}

extension UIRefreshControl {
    func simulatePullToRefresh() {
        simulate(event: .valueChanged)
    }
}

extension Date {
    func plusFeedCacheMaxAge() -> Date {
        return adding(days: feedCacheMaxAgeInDays)
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
