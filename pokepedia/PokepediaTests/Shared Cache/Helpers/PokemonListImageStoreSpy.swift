//
//  ImageStoreSpy.swift
//  PokepediaTests
//
//  Created by Vasiliy Klyotskin on 8/3/23.
//

import Pokepedia
import Foundation

final class ImageStoreSpy: ImageStore {
    enum Message: Equatable {
        case retrieve(dataFor: URL)
        case insert(data: Data, url: URL)
    }
    
    var receivedMessages: [Message] = []
    var retrieveResult: Result<Data?, Error> = .failure(anyNSError())
    var insertResult: Result<Void, Error> = .failure(anyNSError())
    
    func retrieveImage(for url: URL) throws -> Data? {
        receivedMessages.append(.retrieve(dataFor: url))
        return try retrieveResult.get()
    }
    
    func insertImage(data: Data, for url: URL) throws {
        receivedMessages.append(.insert(data: data, url: url))
        try insertResult.get()
    }
    
    func stubRetrieveWith(error: Error) {
        retrieveResult = .failure(error)
    }
    
    func stubRetrieveWithEmpty() {
        retrieveResult = .success(nil)
    }
    
    func stubRetrievalWith(data: Data) {
        retrieveResult = .success(data)
    }
    
    func stubInsertionWith(error: Error) {
        insertResult = .failure(error)
    }
    
    func stubInsertionWithSuccess() {
        insertResult = .success(())
    }
}
