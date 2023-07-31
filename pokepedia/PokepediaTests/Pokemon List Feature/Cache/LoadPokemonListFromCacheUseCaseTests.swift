//
//  LoadPokemonListFromCacheUseCaseTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 7/31/23.
//

import XCTest

protocol LocalPokemonListStore {
    func retrieve()
}

final class LocalPokemonListLoader {
    private let store: LocalPokemonListStore
    
    init(store: LocalPokemonListStore) {
        self.store = store
    }
    
    func load() {
        store.retrieve()
    }
}

final class LoadPokemonListFromCacheUseCaseTests: XCTestCase {
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSut()
        
        XCTAssertTrue(store.receivedMessages.isEmpty)
    }
    
    func test_load_requestsCacheRetrieval() {
        let (sut, store) = makeSut()
        
        sut.load()
        
        XCTAssertEqual(store.receivedMessages, [.retrieval])
    }
    
    // MARK: - Helpers
    
    private func makeSut(file: StaticString = #filePath, line: UInt = #line) -> (LocalPokemonListLoader, PokemonListStoreMock) {
        let mock = PokemonListStoreMock()
        let sut = LocalPokemonListLoader(store: mock)
        trackForMemoryLeaks(mock, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, mock)
    }
}

final class PokemonListStoreMock: LocalPokemonListStore {
    enum Message {
        case retrieval
    }
    
    var receivedMessages: [Message] = []
    
    func retrieve() {
        receivedMessages.append(.retrieval)
    }
}
