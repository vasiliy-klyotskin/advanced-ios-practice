//
//  CacheDetailPokemonUseCaseTests.swift
//  PokepediaTests
//
//  Created by Vasiliy Klyotskin on 8/22/23.
//

import Pokepedia
import Foundation
import XCTest

final class CacheDetailPokemonUseCaseTests: XCTestCase {
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSut()
        
        XCTAssertTrue(store.receivedMessages.isEmpty)
    }

    func test_save_requestsNewCacheInsertionWithTimestampOnSuccessfulDeletion() {
        ids.forEach { id in
            let currentDate = Date()
            let (sut, store) = makeSut(currentDate: { currentDate })
            let detail = localDetail(for: id)

            sut.save(detail: detail.model)

            XCTAssertEqual(store.receivedMessages, [.deletionForId(id), .insertionForId(id, .init(timestamp: currentDate, local: detail.local))], "Expected no insertion request for id: \(id)")
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
    
    private let ids = [0, 1, 2, 3]
}
