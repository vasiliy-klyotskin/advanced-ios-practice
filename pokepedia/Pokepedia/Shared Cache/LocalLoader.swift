//
//  LocalLoader.swift
//  Pokepedia
//
//  Created by Василий Клецкин on 5/19/23.
//

import Foundation

public struct LocalRetrieval<Local> {
    public let local: Local
    public let timestamp: Date
    
    public init(local: Local, timestamp: Date) {
        self.local = local
        self.timestamp = timestamp
    }
}

public protocol LocalLoaderStore {
    associatedtype Local
    
    func retrieve(for key: String) throws -> LocalRetrieval<Local>?
}

public final class LocalLoader<Local, Model> {
    public typealias Validation = (Date) -> Bool
    public typealias Mapping = (Local) -> Model
    
    enum Error: Swift.Error {
        case empty
        case expired
    }
    
    private let retrieve: (String) throws -> LocalRetrieval<Local>?
    private let mapping: Mapping
    private let validation: Validation
    
    public init<Store: LocalLoaderStore>(
        store: Store,
        mapping: @escaping Mapping,
        validation: @escaping Validation
    ) where Store.Local == Local {
        self.retrieve = store.retrieve
        self.validation = validation
        self.mapping = mapping
    }
    
    public func load(for key: String) throws -> Model {
        let retrieved = try retrieve(key)
        guard let retrieved = retrieved else { throw Error.empty }
        try checkExpiration(of: retrieved.timestamp)
        return mapping(retrieved.local)
    }

    private func checkExpiration(of timestamp: Date) throws {
        if !validation(timestamp) {
            throw Error.expired
        }
    }
}
