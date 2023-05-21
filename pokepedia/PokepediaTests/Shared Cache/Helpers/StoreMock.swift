//
//  StoreMock.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 5/19/23.
//

import Foundation
import Pokepedia

final class StoreMock: LocalLoaderStore, LocalSaverStore, LocalValidatorStore {
    struct Unexpected: Error {}
    enum Message: Equatable {
        case retrieve(String)
        case delete(String)
        case insert(LocalStub, Date, String)
    }
    
    var messages: [Message] = []
    var retrieveStubs = [String: Result<StoreRetrieval<LocalStub>?, Error>]()
    
    func retrieve(for key: String) throws -> StoreRetrieval<LocalStub>? {
        messages.append(.retrieve(key))
        if let stub = retrieveStubs[key] {
            return try stub.get()
        }
        throw Unexpected()
    }
    
    func retrieve(for key: String) -> Date? {
        let a: StoreRetrieval<LocalStub>? = try? retrieve(for: key)
        return a.map { $0.timestamp }
    }
    
    func delete(for key: String) {
        messages.append(.delete(key))
    }
    
    func insert(data: LocalInserting<LocalStub>, for key: String) {
        messages.append(.insert(data.local, data.timestamp, key))
    }
    
    func stubRetrieve(result: Result<StoreRetrieval<LocalStub>?, Error>, for key: String) {
        retrieveStubs[key] = result
    }
}

struct LocalStub: Equatable {
    let id: UUID = .init()
}
struct ModelStub: Equatable {
    let id: UUID = .init()
}
