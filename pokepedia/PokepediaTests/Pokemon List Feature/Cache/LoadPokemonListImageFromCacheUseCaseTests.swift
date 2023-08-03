//
//  LoadPokemonListImageFromCacheUseCaseTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 8/3/23.
//

import XCTest
import Pokepedia

final class PokemonListimageLoader {
    private let store: PokemonListImageStoreSpy

    init(store: PokemonListImageStoreSpy) {
        self.store = store
    }
    
    func loadImageData(from url: URL) throws -> Any? {
        store.retrieveImage(for: url)
    }
}

final class LoadPokemonListImageFromCacheUseCaseTests: XCTestCase {
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSut()
        
        XCTAssertTrue(store.receivedMessages.isEmpty)
    }
    
    func test_load_requestsStoredDataForURL() {
        let (sut, store) = makeSut()
        let url = anyURL()
        
        _ = try? sut.loadImageData(from: url)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve(dataFor: url)])
    }
    
    // MARK: - Helpers
    
    private func makeSut(file: StaticString = #filePath, line: UInt = #line) -> (PokemonListimageLoader, PokemonListImageStoreSpy) {
        let store = PokemonListImageStoreSpy()
        let sut = PokemonListimageLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
}

final class PokemonListImageStoreSpy {
    enum Message: Equatable {
        case retrieve(dataFor: URL)
    }
    
    var receivedMessages: [Message] = []
    
    func retrieveImage(for url: URL) -> Data? {
        receivedMessages.append(.retrieve(dataFor: url))
        return nil
    }
}
