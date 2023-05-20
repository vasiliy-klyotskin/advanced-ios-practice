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
}

public final class LocalLoader<Local, Model, Store: LocalLoaderStore> where Store.Local == Local {
    public typealias Validation = (_ timestamp: Date, _ against: Date) -> Bool
    public typealias Mapping = (Local) -> Model
    
    enum Error: Swift.Error {
        case empty
        case expired
    }
    
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
        let retrieved = try store.retrieve(for: key)
        guard let retrieved = retrieved else { throw Error.empty }
        try checkExpiration(of: retrieved.timestamp)
        return mapping(retrieved.local)
    }

    private func checkExpiration(of timestamp: Date) throws {
        if !validation(timestamp, current()) {
            throw Error.expired
        }
    }
}
