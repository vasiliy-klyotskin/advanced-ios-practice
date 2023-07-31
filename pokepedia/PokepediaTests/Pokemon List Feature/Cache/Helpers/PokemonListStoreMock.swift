//
//  PokemonListStoreMock.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 7/31/23.
//

import Foundation
import Pokepedia

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
