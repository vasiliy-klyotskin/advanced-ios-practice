//
//  LoadDetailPokemonUseCaseTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 8/22/23.
//

import XCTest
import Pokepedia

final class LoadDetailPokemonUseCaseTests: XCTestCase {
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSut()
        
        XCTAssertTrue(store.receivedMessages.isEmpty)
    }
    
    func test_load_requestsCacheRetrieval() {
        ids.forEach { id in
            let (sut, store) = makeSut()

            _ = try? sut.load(for: id)

            XCTAssertEqual(store.receivedMessages, [.retrievalForId(id)])
        }
    }

    func test_load_failsOnEmptyRetrieval() {
        ids.forEach { id in
            let (sut, store) = makeSut()
            store.stubRetrieve(for: id, cache: nil)

            expect(sut, for: id, toCompleteWith: .failure(anyNSError()))
        }
    }


    func test_load_deliversCachedDetailOnNonExpiredCache() {
        ids.forEach { id in
            let fixedCurrentDate = Date()
            let detail = localDetail(for: id)
            let nonExpiredTimestamp = fixedCurrentDate.minusDetailCacheMaxAge().adding(seconds: 1)
            let (sut, store) = makeSut(currentDate: { fixedCurrentDate })
            
            store.stubRetrieve(for: id, cache: .init(timestamp: nonExpiredTimestamp, local: detail.local))
            
            expect(sut, for: id, toCompleteWith: .success(detail.model))
        }
    }
    
    func test_load_deliversNoCachedDetailOnCacheExpiration() {
        ids.forEach { id in
            let fixedCurrentDate = Date()
            let detail = localDetail(for: id)
            let expirationTimestamp = fixedCurrentDate.minusDetailCacheMaxAge()
            let (sut, store) = makeSut(currentDate: { fixedCurrentDate })
            
            store.stubRetrieve(for: id, cache: .init(timestamp: expirationTimestamp, local: detail.local))
            
            expect(sut, for: id, toCompleteWith: .failure(anyNSError()))
        }
    }

    func test_load_deliversNoDetailOnExpiredCache() {
        ids.forEach { id in
            let fixedCurrentDate = Date()
            let detail = localDetail(for: id)
            let expiredTimestamp = fixedCurrentDate.minusDetailCacheMaxAge()
            let (sut, store) = makeSut(currentDate: { fixedCurrentDate })
            
            store.stubRetrieve(for: id, cache: .init(timestamp: expiredTimestamp, local: detail.local))
            
            expect(sut, for: id, toCompleteWith: .failure(anyNSError()))
        }
    }

    // MARK: - Helpers
    
    private func makeSut(
        currentDate: @escaping () -> Date = Date.init,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (LocalDetailPokemonLoader, DetailPokemonStoreSpy) {
        let store = DetailPokemonStoreSpy()
        let sut = LocalDetailPokemonLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private let ids = [0, 1, 2]
    
    private func expect(
        _ sut: LocalDetailPokemonLoader,
        for id: Int,
        toCompleteWith expectedResult: Result<DetailPokemon, Error>,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let receivedResult = Result { try sut.load(for: id) }
        switch (receivedResult, expectedResult) {
        case let (.success(receivedDetail), .success(expectedDetail)):
            XCTAssertEqual(receivedDetail, expectedDetail, file: file, line: line)
        case (.failure, .failure):
            break
        default:
            XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
        }
    }
}
