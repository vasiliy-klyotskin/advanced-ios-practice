//
//  LocalLoaderTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 5/18/23.
//

import XCTest

final class LocalLoader {
    init(store: StoreMock) {
        
    }
}

final class LocalLoaderTests: XCTestCase {
    func test_init_hasNoSideEffects() throws {
        let store = StoreMock()
        
        _ = LocalLoader(store: store)
        
        XCTAssertEqual(store.messages.count, 0)
    }
}

final class StoreMock {
    var messages: [Any] = []
}
