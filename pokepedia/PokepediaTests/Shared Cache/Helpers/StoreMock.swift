//
//  StoreMock.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 5/19/23.
//

import Foundation
import Pokepedia

final class StoreMock: LocalLoaderStore, LocalSaverStore, LocalValidatorStore {
    typealias Key = String
    typealias Timestamp = Date
    
    struct Unexpected: Error {}
    
    enum Message: Equatable {
        case retrieve(Key)
        case delete(Key)
        case insert(LocalStub, Timestamp, Key)
    }
    
    var messages: [Message] = []
    var retrieveStubs = [Key: Result<StoreRetrieval<LocalStub>?, Error>]()
    
    func retrieve(for key: String) throws -> StoreRetrieval<LocalStub>? {
        messages.append(.retrieve(key))
        if let stub = retrieveStubs[key] {
            return try stub.get()
        }
        throw Unexpected()
    }
    
    func retrieve(for key: Key) -> Timestamp? {
        let a: StoreRetrieval<LocalStub>? = try? retrieve(for: key)
        return a.map { $0.timestamp }
    }
    
    func delete(for key: Key) {
        messages.append(.delete(key))
    }
    
    func insert(data: LocalInserting<LocalStub>, for key: Key) {
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
