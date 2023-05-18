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
    
    func load() throws {
        try store.retrieve()
    }
}

final class LocalLoaderTests: XCTestCase {
    func test_init_hasNoSideEffects() {
        let (_, store) = makeSut()
        
        XCTAssertEqual(store.messages.count, 0)
    }
    
    func test_load_retrievesData() throws {
        let (sut, store) = makeSut()
        
        try sut.load()
        
        XCTAssertEqual(store.messages, [.retrieve])
    }
    
    func test_load_deliversErrorOnRetrievalError() throws {
        let (sut, store) = makeSut()
        
        store.stubRetrieve(result: .failure(anyNSError()))
        
        XCTAssertThrowsError(
            try sut.load()
        )
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
    var retrieveStub: Result<Any, Error>?
    
    func retrieve() throws {
        messages.append(.retrieve)
        _ = try retrieveStub?.get()
    }
    
    func stubRetrieve(result: Result<Any, Error>) {
        retrieveStub = result
    }
}
