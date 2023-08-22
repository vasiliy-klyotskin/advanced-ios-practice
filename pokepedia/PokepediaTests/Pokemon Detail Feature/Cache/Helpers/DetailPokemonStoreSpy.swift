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
    
    enum Message: Equatable {
        case retrieval
        case deletion
        case deletionForId(Int)
    }
    
    var retrieveResult: Result<[ValidationRetrieval], Error> = .failure(anyNSError())
    
    func retrieve() throws -> [ValidationRetrieval] {
        receivedMessages.append(.retrieval)
        return try retrieveResult.get()
    }
    
    func deleteAll() {
        receivedMessages.append(.deletion)
    }
    
    func delete(for id: Int) {
        receivedMessages.append(.deletionForId(id))
    }
    
    func stubRetrieve(with error: NSError) {
        retrieveResult = .failure(error)
    }
    
    func stubEmptyRetrieve() {
        retrieveResult = .success([])
    }
    
    func stubRetrieveWith(_ retrieval: [ValidationRetrieval]) {
        retrieveResult = .success(retrieval)
    }
    
    var receivedMessages: [Message] = []
}
