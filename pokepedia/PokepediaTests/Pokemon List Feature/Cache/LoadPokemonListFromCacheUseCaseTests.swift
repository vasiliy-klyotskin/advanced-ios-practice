//
//  LoadPokemonListFromCacheUseCaseTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 7/31/23.
//

import XCTest
import Pokepedia

enum PokemonListCachePolicy {
    private static let calendar = Calendar(identifier: .gregorian)
    
    private static var maxCacheAgeInDays: Int {
        return 7
    }
    
    static func validate(_ timestamp: Date, against date: Date) -> Bool {
        guard let maxCacheAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: timestamp) else {
            return false
        }
        return date < maxCacheAge
    }
}


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

typealias CachedPokemonList = (local: LocalPokemonList, timestamp: Date)

protocol LocalPokemonListStore {
    func retrieve() throws -> CachedPokemonList?
}

final class LocalPokemonListLoader {
    private let store: LocalPokemonListStore
    private let currentDate: () -> Date
    
    init(store: LocalPokemonListStore, currentDate: @escaping () -> Date = Date.init) {
        self.store = store
        self.currentDate = currentDate
    }
    
    func load() throws -> PokemonList? {
        let cache = try store.retrieve()
        guard let cache else { return nil }
        if PokemonListCachePolicy.validate(cache.timestamp, against: currentDate()) {
            return cache.local.model
        } else {
            return nil
        }
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
        store.stubRetrieve(with: anyNSError())
        
        XCTAssertThrowsError(try sut.load())
    }
    
    func test_load_deliversNoListOnEmptyCache() throws {
        let (sut, store) = makeSut()
        store.stubEmptyRetrieve()
        
        let list = try sut.load()
        
        XCTAssertEqual(list, nil)
    }
    
    func test_load_deliversCachedListOnNonExpiredCache() throws {
        let list = pokemonList()
        let fixedCurrentDate = Date()
        let nonExpiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: 1)
        let (sut, store) = makeSut(currentDate: { fixedCurrentDate })
        store.stubRetrieveWith(local: list.local, timestamp: nonExpiredTimestamp)
        
        let result = try sut.load()
        
        XCTAssertEqual(result, list.model)
    }
    
    func test_load_deliversNoCachedListOnCacheExpiration() throws {
        let list = pokemonList()
        let fixedCurrentDate = Date()
        let expirationDateTimestamp = fixedCurrentDate.minusFeedCacheMaxAge()
        let (sut, store) = makeSut(currentDate: { fixedCurrentDate })
        store.stubRetrieveWith(local: list.local, timestamp: expirationDateTimestamp)
        
        let result = try sut.load()
        
        XCTAssertEqual(result, nil)
    }
    
    func test_load_deliversNoListOnExpiredCache() throws {
        let list = pokemonList()
        let fixedCurrentDate = Date()
        let expiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: -1)
        let (sut, store) = makeSut(currentDate: { fixedCurrentDate })
        store.stubRetrieveWith(local: list.local, timestamp: expiredTimestamp)
        
        let result = try sut.load()
        
        XCTAssertEqual(result, nil)
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
    
    var retrieveResult: Result<CachedPokemonList?, Error> = .failure(anyNSError())
    var receivedMessages: [Message] = []
    
    func retrieve() throws -> CachedPokemonList? {
        receivedMessages.append(.retrieval)
        switch retrieveResult {
        case .success(let success):
            return success
        case .failure(let failure):
            throw failure
        }
    }
    
    func stubRetrieve(with error: Error) {
        self.retrieveResult = .failure(error)
    }
    
    func stubRetrieveWith(local: LocalPokemonList, timestamp: Date) {
        self.retrieveResult = .success((local, timestamp))
    }
    
    func stubEmptyRetrieve() {
        self.retrieveResult = .success(nil)
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
