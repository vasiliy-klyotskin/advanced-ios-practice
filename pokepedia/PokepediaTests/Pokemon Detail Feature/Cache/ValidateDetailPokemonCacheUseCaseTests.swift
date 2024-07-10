//
//  ValidateDetailPokemonCacheUseCaseTests.swift
//  PokepediaTests
//
//  Created by Vasiliy Klyotskin on 8/22/23.
//

import XCTest
import Pokepedia

final class ValidateDetailPokemonCacheUseCaseTests: XCTestCase {
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSut()
        
        XCTAssertTrue(store.receivedMessages.isEmpty)
    }
    
    func test_validateCache_deletesCacheOnRetrievalError() {
        let (sut, store) = makeSut()
        store.stubRetrieveForValidation(with: anyNSError())

        sut.validateCache()

        XCTAssertEqual(store.receivedMessages, [.retrieval, .deletion])
    }

    func test_validateCache_doesNotDeleteCacheOnEmptyCache() {
        let (sut, store) = makeSut()
        store.stubEmptyRetrieveForValidation()

        sut.validateCache()

        XCTAssertEqual(store.receivedMessages, [.retrieval])
    }

    func test_validateCache_deletesCacheOnlyForExpiredIds() {
        let fixedCurrentDate = Date()
        let (sut, store) = makeSut(currentDate: { fixedCurrentDate })
        let expired = fixedCurrentDate.minusDetailCacheMaxAge().adding(seconds: -1)
        let notExpired = fixedCurrentDate.minusDetailCacheMaxAge().adding(seconds: 1)
        let expirationDate = fixedCurrentDate.minusDetailCacheMaxAge()
        store.stubRetrieveForValidationWith([
            .init(timestamp: expired, id: 0),
            .init(timestamp: expirationDate, id: 1),
            .init(timestamp: notExpired, id: 2),
            .init(timestamp: expirationDate, id: 3),
            .init(timestamp: expired, id: 4),
            .init(timestamp: notExpired, id: 5),
        ])

        sut.validateCache()

        XCTAssertEqual(store.receivedMessages, [
            .retrieval,
            .deletionForId(0),
            .deletionForId(1),
            .deletionForId(3),
            .deletionForId(4),
        ])
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
}
