//
//  LoadPokemonListFromCacheUseCaseTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 7/31/23.
//

import XCTest
import Pokepedia


public typealias LocalPokemonList = [LocalPokemonListItem]

public struct LocalPokemonListItem {
    public let id: String
    public let name: String
    public let imageUrl: URL
    public let physicalType: LocalPokemonListItemType
    public let specialType: LocalPokemonListItemType?
    
    public init(
        id: String,
        name: String,
        imageUrl: URL,
        physicalType: LocalPokemonListItemType,
        specialType: LocalPokemonListItemType?
    ) {
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
        self.physicalType = physicalType
        self.specialType = specialType
    }
}

extension LocalPokemonList {
    var model: PokemonList {
        map {
            .init(
                id: $0.id,
                name: $0.name,
                imageUrl: $0.imageUrl,
                physicalType: .init(color: $0.physicalType.color, name: $0.physicalType.name),
                specialType: $0.specialType.map { .init(color: $0.color, name: $0.name) }
            )
        }
    }
}

public struct LocalPokemonListItemType {
    public let color: String
    public let name: String
    
    public init(color: String, name: String) {
        self.color = color
        self.name = name
    }
}

protocol LocalPokemonListStore {
    func retrieve() throws -> LocalPokemonList?
}

final class LocalPokemonListLoader {
    private let store: LocalPokemonListStore
    
    init(store: LocalPokemonListStore) {
        self.store = store
    }
    
    func load() throws -> PokemonList? {
        try store.retrieve()?.model
    }
}

final class LoadPokemonListFromCacheUseCaseTests: XCTestCase {
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSut()
        
        XCTAssertTrue(store.receivedMessages.isEmpty)
    }
    
    func test_load_requestsCacheRetrieval() {
        let (sut, store) = makeSut()
        
        _ = try? sut.load()
        
        XCTAssertEqual(store.receivedMessages, [.retrieval])
    }
    
    func test_load_failsOnRetrievalError() {
        let (sut, store) = makeSut()
        store.stubRetrieve(with: .failure(anyNSError()))
        
        XCTAssertThrowsError(try sut.load())
    }
    
    func test_load_deliversNoListOnEmptyCache() throws {
        let (sut, store) = makeSut()
        store.stubRetrieve(with: .success(nil))
        
        let list = try sut.load()
        
        XCTAssertEqual(list, nil)
    }
    
    func test_load_deliversCachedListOnNonExpiredCache() throws {
        let list = pokemonList()
        let fixedCurrentDate = Date()
        let nonExpiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: 1)
        let (sut, store) = makeSut(currentDate: { fixedCurrentDate })
        store.stubRetrieve(with: .success(list.local))
        
        let result = try sut.load()
        
        XCTAssertEqual(result, list.model)
    }
    
    // MARK: - Helpers
    
    private func makeSut(
        currentDate: () -> Date = Date.init,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (LocalPokemonListLoader, PokemonListStoreMock) {
        let store = PokemonListStoreMock()
        let sut = LocalPokemonListLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func pokemonList() -> (local: LocalPokemonList, model: PokemonList) {
        let url = anyURL()
        let local: LocalPokemonList = [
            .init(
                id: "an id",
                name: "a name",
                imageUrl: url,
                physicalType: .init(
                    color: "physical color",
                    name: "name of physical color"
                ),
                specialType: .init(
                    color: "special colorr",
                    name: "name of special color"
                )
            )
        ]
        let model: PokemonList = [
            .init(
                id: "an id",
                name: "a name",
                imageUrl: url,
                physicalType: .init(
                    color: "physical color",
                    name: "name of physical color"
                ),
                specialType: .init(
                    color: "special colorr",
                    name: "name of special color"
                )
            )
        ]
        return (local, model)
    }
}

final class PokemonListStoreMock: LocalPokemonListStore {
    enum Message {
        case retrieval
    }
    
    var retrieveResult: Result<LocalPokemonList?, Error> = .failure(anyNSError())
    var receivedMessages: [Message] = []
    
    func retrieve() throws -> LocalPokemonList? {
        receivedMessages.append(.retrieval)
        switch retrieveResult {
        case .success(let success):
            return success
        case .failure(let failure):
            throw failure
        }
    }
    
    func stubRetrieve(with result: Result<LocalPokemonList?, Error>) {
        self.retrieveResult = result
    }
}

extension Date {
    func minusFeedCacheMaxAge() -> Date {
        return adding(days: -feedCacheMaxAgeInDays)
    }
    
    private var feedCacheMaxAgeInDays: Int {
        return 7
    }
    
    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }

    func adding(days: Int, calendar: Calendar = Calendar(identifier: .gregorian)) -> Date {
        return calendar.date(byAdding: .day, value: days, to: self)!
    }
}
