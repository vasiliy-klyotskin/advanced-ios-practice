//
//  LocalLoader.swift
//  Pokepedia
//
//  Created by Василий Клецкин on 5/19/23.
//

import Foundation

public struct StoreRetrieval<Local> {
    let local: Local
    let timestamp: Date
    
    public init(local: Local, timestamp: Date) {
        self.local = local
        self.timestamp = timestamp
    }
}

public protocol LocalLoaderStore {
    associatedtype Local
    
    func retrieve(for key: String) throws -> StoreRetrieval<Local>?
    func delete(for key: String)
}

public final class LocalLoader<Local, Model, Store: LocalLoaderStore> where Store.Local == Local {
    public typealias Validation = (_ timestamp: Date, _ against: Date) -> Bool
    public typealias Mapping = (Local) -> Model
    
    struct EmptyCache: Error {}
    
    private let store: Store
    private let mapping: Mapping
    private let validation: Validation
    private let current: () -> Date
    
    public init(
        store: Store,
        mapping: @escaping Mapping,
        validation: @escaping Validation,
        current: @escaping () -> Date
    ) {
        self.store = store
        self.validation = validation
        self.current = current
        self.mapping = mapping
    }
    
    public func load(for key: String) throws -> Model {
        let result = try store.retrieve(for: key)
        guard let result = result else { throw EmptyCache() }
        if !validation(result.timestamp, current()) {
            store.delete(for: key)
            throw NSError()
        } else {
            return mapping(result.local)
        }
    }
}
