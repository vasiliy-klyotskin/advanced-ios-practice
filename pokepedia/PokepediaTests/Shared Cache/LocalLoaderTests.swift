//
//  LocalLoaderTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 5/18/23.
//

import XCTest

final class LocalLoader {
    private let store: StoreMock
    
    init(store: StoreMock) {
        self.store = store
    }
    
    func load() {
        store.retrieve()
    }
}

final class LocalLoaderTests: XCTestCase {
    func test_init_hasNoSideEffects() {
        let store = StoreMock()
        
        _ = LocalLoader(store: store)
        
        XCTAssertEqual(store.messages.count, 0)
    }
    
    func test_load_retrievesData() {
        let store = StoreMock()
        let sut = LocalLoader(store: store)
        
        sut.load()
        
        XCTAssertEqual(store.messages, [.retrieve])
    }
}

final class StoreMock {
    enum Message {
        case retrieve
    }
    var messages: [Message] = []
    
    func retrieve() {
        messages.append(.retrieve)
    }
}
