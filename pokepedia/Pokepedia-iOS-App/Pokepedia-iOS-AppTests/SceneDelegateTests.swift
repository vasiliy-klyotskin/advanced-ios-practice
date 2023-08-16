//
//  SceneDelegateTests.swift
//  Pokepedia-iOS-AppTests
//
//  Created by Василий Клецкин on 8/16/23.
//

import XCTest
import Pokepedia_iOS_App

final class SceneDelegateTests: XCTestCase {
    func test_configureWindow_makesWindowKeyAndVisible() throws {
        let window = WindowSpy()
        let sut = SceneDelegate()
        sut.window = window
        
        sut.configureWindow()
        
        XCTAssertEqual(window.makeKeyAndVisibleCallCount, 1, "Expected to make window key and visible")
    }

    // MARK: - Helpers
    
    final class WindowSpy: UIWindow {
        var makeKeyAndVisibleCallCount = 0
        
        override func makeKeyAndVisible() {
            super.makeKeyAndVisible()
            makeKeyAndVisibleCallCount += 1
        }
    }
}
