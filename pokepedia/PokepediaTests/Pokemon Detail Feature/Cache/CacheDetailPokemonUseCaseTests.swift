//
//  CacheDetailPokemonUseCaseTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 8/22/23.
//

import Pokepedia
import Foundation
import XCTest

final class CacheDetailPokemonUseCaseTests: XCTestCase {
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSut()
        
        XCTAssertTrue(store.receivedMessages.isEmpty)
    }
    
    func test_save_doesNotRequestCacheInsertionOnDeletionError() {
        let ids = [0, 1 ,2, 3]
        
        for id in ids {
            let (sut, store) = makeSut()
            store.stubDeletion(for: id, with: anyNSError())

            sut.save(detail: localDetail(for: id).model)

            XCTAssertEqual(store.receivedMessages, [.deletionForId(id)], "Expected no insertion request for id: \(id)")
        }
    }

    func test_save_requestsNewCacheInsertionWithTimestampOnSuccessfulDeletion() {
        let ids = [0, 1 ,2, 3]
        
        for id in ids {
            let currentDate = Date()
            let (sut, store) = makeSut(currentDate: { currentDate })
            let detail = localDetail(for: id)
            store.stubDeletionWithSuccess(for: id)

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
    
    private func localDetail(for id: Int) -> (model: DetailPokemon, local: LocalDetailPokemon) {
        let model: DetailPokemon = .init(
            info: .init(
                imageUrl: URL(string: "http://detail-\(id).com")!,
                id: id,
                name: "name \(id)",
                genus: "genus \(id)",
                flavorText: "flavor \(id)"
            ),
            abilities: [.init(
                title: "titile \(id)",
                subtitle: "subtitle \(id)",
                damageClass: "damage \(id)",
                damageClassColor: "damage color \(id)",
                type: "type \(id)",
                typeColor: "type color \(id)"
            )]
        )
        let local: LocalDetailPokemon = .init(
            info: .init(
                imageUrl: URL(string: "http://detail-\(id).com")!,
                id: id,
                name: "name \(id)",
                genus: "genus \(id)",
                flavorText: "flavor \(id)"
            ),
            abilities: [.init(
                title: "titile \(id)",
                subtitle: "subtitle \(id)",
                damageClass: "damage \(id)",
                damageClassColor: "damage color \(id)",
                type: "type \(id)",
                typeColor: "type color \(id)"
            )]
        )
        return (model, local)
    }
}
