//
//  LoadPokemonListFromCacheUseCaseTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 7/31/23.
//

import XCTest

protocol LocalPokemonListStore {
    func retrieve() throws
}

final class LocalPokemonListLoader {
    private let store: LocalPokemonListStore
    
    init(store: LocalPokemonListStore) {
        self.store = store
    }
    
    func load() throws {
        try store.retrieve()
    }
}

final class LoadPokemonListFromCacheUseCaseTests: XCTestCase {
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSut()
        
        XCTAssertTrue(store.receivedMessages.isEmpty)
    }
    
    func test_load_requestsCacheRetrieval() {
        let (sut, store) = makeSut()
        
        try? sut.load()
        
        XCTAssertEqual(store.receivedMessages, [.retrieval])
    }
    
    func test_load_failsOnRetrievalError() {
        let (sut, store) = makeSut()
        store.stubRetrieve(with: .failure(anyNSError()))
        
        XCTAssertThrowsError(try sut.load())
    }
    
    // MARK: - Helpers
    
    private func makeSut(file: StaticString = #filePath, line: UInt = #line) -> (LocalPokemonListLoader, PokemonListStoreMock) {
        let store = PokemonListStoreMock()
        let sut = LocalPokemonListLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
}

final class PokemonListStoreMock: LocalPokemonListStore {
    enum Message {
        case retrieval
    }
    
    var retrieveResult: Result<Any, Error> = .failure(anyNSError())
    var receivedMessages: [Message] = []
    
    func retrieve() throws {
        receivedMessages.append(.retrieval)
        switch retrieveResult {
        case .success(let success):
            break
        case .failure(let failure):
            throw failure
        }
    }
    
    func stubRetrieve(with result: Result<Any, Error>) {
        self.retrieveResult = result
    }
}
