//
//  LoadDetailPokemonUseCaseTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 8/21/23.
//

import XCTest

final class DetailPokemonStoreSpy {
    enum Message: Equatable {
        case retrieve(Int)
    }
    
    var retrieveResults: [Int: Result<Any?, NSError>] = [:]
    
    func stubRetrieve(for id: Int, with error: NSError) {
        retrieveResults[id] = .failure(error)
    }
    
    func stubEmptyRetrieve(for id: Int) {
        retrieveResults[id] = .success(nil)
    }
    
    func retrieve(for id: Int) throws -> Any? {
        receivedMessages.append(.retrieve(id))
        let result = retrieveResults[id] ?? .failure(anyNSError())
        return try result.get()
    }
    
    var receivedMessages: [Message] = []
}

final class LocalDetailPokemonLoader {
    enum Error: Swift.Error { case empty }
    
    private let store: DetailPokemonStoreSpy
    
    init(store: DetailPokemonStoreSpy) {
        self.store = store
    }
    
    func load(for id: Int) throws -> Any {
        let local = try store.retrieve(for: id)
        guard let local else { throw Error.empty }
        return local
    }
}

final class LoadDetailPokemonUseCaseTests: XCTestCase {
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSut()
        
        XCTAssertTrue(store.receivedMessages.isEmpty)
    }
    
    func test_load_requestsCacheRetrieval() {
        ids.forEach { id in
            let (sut, store) = makeSut()
            
            _ = try? sut.load(for: id)
            
            XCTAssertEqual(store.receivedMessages, [.retrieve(id)], "Expected retrieve to be called with id: \(id)")
        }
    }
    
    func test_load_failsOnRetrievalError() {
        ids.forEach { id in
            let (sut, store) = makeSut()
            let retrieveError = anyNSError()
            store.stubRetrieve(for: id, with: anyNSError())
            
            expect(sut, for: id, toCompleteWith: .failure(retrieveError))
        }
    }
    
    func test_load_deliversNoPokemonOnEmptyCache() {
        ids.forEach { id in
            let (sut, store) = makeSut()
            store.stubEmptyRetrieve(for: id)
            
            expect(sut, for: id, toCompleteWith: .failure(anyNSError()))
        }
    }
//    
//    func test_load_deliversCachedListOnNonExpiredCache() {
//        let list = pokemonList()
//        let fixedCurrentDate = Date()
//        let nonExpiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: 1)
//        let (sut, store) = makeSut(currentDate: { fixedCurrentDate })
//        store.stubRetrieveWith(local: list.local, timestamp: nonExpiredTimestamp)
//        
//        expect(sut, toCompleteWith: .success(list.model))
//    }
//    
//    func test_load_deliversNoCachedListOnCacheExpiration() {
//        let list = pokemonList()
//        let fixedCurrentDate = Date()
//        let expirationDateTimestamp = fixedCurrentDate.minusFeedCacheMaxAge()
//        let (sut, store) = makeSut(currentDate: { fixedCurrentDate })
//        store.stubRetrieveWith(local: list.local, timestamp: expirationDateTimestamp)
//        
//        expect(sut, toCompleteWith: .failure(anyNSError()))
//    }
//    
//    func test_load_deliversNoListOnExpiredCache() {
//        let list = pokemonList()
//        let fixedCurrentDate = Date()
//        let expiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: -1)
//        let (sut, store) = makeSut(currentDate: { fixedCurrentDate })
//        store.stubRetrieveWith(local: list.local, timestamp: expiredTimestamp)
//        
//        expect(sut, toCompleteWith: .failure(anyNSError()))
//}
    
    // MARK: - Helpers
    
    private let ids = [0, 1, 2, 3]
    
    private func makeSut(
        currentDate: @escaping () -> Date = Date.init,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (LocalDetailPokemonLoader, DetailPokemonStoreSpy) {
        let store = DetailPokemonStoreSpy()
        let sut = LocalDetailPokemonLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(
        _ sut: LocalDetailPokemonLoader,
        for id: Int,
        toCompleteWith expectedResult: Result<Any?, Error>,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let receivedResult = Result { try sut.load(for: id) }
        switch (receivedResult, expectedResult) {
//        case let (.success(receivedImages), .success(expectedImages)):
//            XCTAssertEqual(receivedImages, expectedImages, file: file, line: line)
        case (.failure, .failure):
            break
        default:
            XCTFail("Expected result \(expectedResult), got \(receivedResult) instead. Id: \(id)", file: file, line: line)
        }
    }
}
