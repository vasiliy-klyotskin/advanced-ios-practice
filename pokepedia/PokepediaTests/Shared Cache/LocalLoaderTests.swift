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
        let (_, store) = makeSut()
        
        XCTAssertEqual(store.messages.count, 0)
    }
    
    func test_load_retrievesData() {
        let (sut, store) = makeSut()
        
        sut.load()
        
        XCTAssertEqual(store.messages, [.retrieve])
    }
    
    // MARK: - Helpers
    
    private func makeSut(file: StaticString = #filePath, line: UInt = #line) -> (LocalLoader, StoreMock) {
        let store = StoreMock()
        let sut = LocalLoader(store: store)
        trackForMemoryLeaks(store)
        trackForMemoryLeaks(sut)
        return (sut, store)
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
