//
//  DetailPokemonStoreSpy.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 8/22/23.
//

import Foundation
import Pokepedia

final class DetailPokemonStoreSpy: DetailPokemonStore {
    typealias ValidationRetrieval = LocalDetailPokemonLoader.ValidationRetrieval
    typealias Insertion = LocalDetailPokemonLoader.Insertion
    
    enum Message: Equatable {
        case retrieval
        case deletion
        case deletionForId(Int)
        case insertionForId(Int, Insertion)
    }
    
    var receivedMessages: [Message] = []
    var retrieveResult: Result<[ValidationRetrieval], Error> = .failure(anyNSError())
    var deletionForIdResult: Result<Void, Error> = .failure(anyNSError())
    
    func retrieve() throws -> [ValidationRetrieval] {
        receivedMessages.append(.retrieval)
        return try retrieveResult.get()
    }
    
    func deleteAll() {
        receivedMessages.append(.deletion)
    }
    
    func delete(for id: Int) throws {
        receivedMessages.append(.deletionForId(id))
        try deletionForIdResult.get()
    }
    
    func insert(_ cache: Pokepedia.LocalDetailPokemonLoader.Insertion, for id: Int) {
        receivedMessages.append(.insertionForId(id, cache))
    }
    
    // MARK: - Stub Retrieve
    
    func stubRetrieve(with error: NSError) {
        retrieveResult = .failure(error)
    }
    
    func stubEmptyRetrieve() {
        retrieveResult = .success([])
    }
    
    func stubRetrieveWith(_ retrieval: [ValidationRetrieval]) {
        retrieveResult = .success(retrieval)
    }
    
    // MARK: - Stub Deletion For ID
    
    func stubDeletion(for id: Int, with error: NSError) {
        deletionForIdResult = .failure(error)
    }
    
    func stubDeletionWithSuccess(for id: Int) {
        deletionForIdResult = .success(())
    }
}
