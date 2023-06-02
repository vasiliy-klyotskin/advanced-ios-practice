//
//  SharedTestHelpers.swift
//  Pokepedia-iOS-AppTests
//
//  Created by Василий Клецкин on 5/30/23.
//

import UIKit

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
