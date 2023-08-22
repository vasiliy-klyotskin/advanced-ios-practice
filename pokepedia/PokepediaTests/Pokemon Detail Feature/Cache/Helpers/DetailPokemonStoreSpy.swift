//
//  DetailPokemonStoreSpy.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 8/22/23.
//

import Foundation
import Pokepedia

final class DetailPokemonStoreSpy {
    typealias ValidationRetrieval = DetailPokemonValidationRetrieval
    typealias Cache = DetailPokemonCache
    
    enum Message: Equatable {
        case retrieval
        case deletion
        case retrievalForId(Int)
        case deletionForId(Int)
        case insertionForId(Int, Cache)
    }
    
    var receivedMessages: [Message] = []
    var retrieveResult: Result<[ValidationRetrieval], Error> = .failure(anyNSError())
    var retrieveForIdResults: [Int: Cache?] = [:]
    
    func stubRetrieveForValidation(with error: NSError) {
        retrieveResult = .failure(error)
    }
    
    func stubEmptyRetrieveForValidation() {
        retrieveResult = .success([])
    }
    
    func stubRetrieveForValidationWith(_ retrieval: [ValidationRetrieval]) {
        retrieveResult = .success(retrieval)
    }
    
    func stubRetrieve(for id: Int, cache: Cache?) {
        retrieveForIdResults[id] = cache
    }
}

extension DetailPokemonStoreSpy: DetailPokemonStore {
    func retrieveForValidation() throws -> [ValidationRetrieval] {
        receivedMessages.append(.retrieval)
        return try retrieveResult.get()
    }
    
    func retrieve(for id: Int) -> Cache? {
        receivedMessages.append(.retrievalForId(id))
        return retrieveForIdResults[id]?.flatMap { $0 }
    }
    
    func deleteAll() {
        receivedMessages.append(.deletion)
    }
    
    func delete(for id: Int) {
        receivedMessages.append(.deletionForId(id))
    }
    
    func insert(_ cache: Cache, for id: Int) {
        receivedMessages.append(.insertionForId(id, cache))
    }
}
