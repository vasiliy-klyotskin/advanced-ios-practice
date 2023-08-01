//
//  PokemonListStoreMock.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 7/31/23.
//

import Foundation
import Pokepedia

final class PokemonListStoreMock: LocalPokemonListStore {
    enum Message: Equatable {
        case retrieval
        case deletion
        case insertion(timestamp: Date, local: LocalPokemonList)
    }
    
    var retrieveResult: Result<CachedPokemonList?, Error> = .failure(anyNSError())
    var deletionResult: Result<Void, Error> = .failure(anyNSError())
    var insertionResult: Result<Void, Error> = .failure(anyNSError())
    var receivedMessages: [Message] = []
    
    func retrieve() throws -> CachedPokemonList? {
        receivedMessages.append(.retrieval)
        return try retrieveResult.get()
    }
    
    func delete() throws {
        receivedMessages.append(.deletion)
        try deletionResult.get()
    }
    
    func insert(local: LocalPokemonList, timestamp: Date) throws {
        receivedMessages.append(.insertion(timestamp: timestamp, local: local))
        try insertionResult.get()
    }
    
    // MARK: - Retrieval
    
    func stubRetrieve(with error: Error) {
        self.retrieveResult = .failure(error)
    }
    
    func stubRetrieveWith(local: LocalPokemonList, timestamp: Date) {
        self.retrieveResult = .success((local, timestamp))
    }
    
    func stubEmptyRetrieve() {
        self.retrieveResult = .success(nil)
    }
    
    // MARK: - Deletion
    
    func stubDeletion(with error: Error) {
        self.deletionResult = .failure(error)
    }
    
    func stubDeletionWithSuccess() {
        self.deletionResult = .success(())
    }
    
    // MARK: - Insertion
    
    func stubInsertion(with error: Error) {
        self.insertionResult = .failure(error)
    }
}
