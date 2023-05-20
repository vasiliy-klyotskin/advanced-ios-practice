//
//  LocalSaver.swift
//  Pokepedia
//
//  Created by Василий Клецкин on 5/20/23.
//

import Foundation

public struct LocalInserting<Local> {
    public let timestamp: Date
    public let local: Local
    
    public init(timestamp: Date, local: Local) {
        self.timestamp = timestamp
        self.local = local
    }
}

public protocol LocalSaverStore {
    associatedtype Local
    
    func insert(data: LocalInserting<Local>, for key: String)
    func delete(for key: String)
}

public final class LocalSaver<Local, Model, Store: LocalSaverStore> where Store.Local == Local {
    public typealias Mapping = (Model) -> Local
    
    private let store: Store
    private let mapping: Mapping
    private let current: () -> Date
    
    public init(
        store: Store,
        mapping: @escaping Mapping,
        current: @escaping () -> Date = Date.init
    ) {
        self.store = store
        self.mapping = mapping
        self.current = current
    }
    
    public func save(_ model: Model, for key: String) {
        store.delete(for: key)
        let timestamp = current()
        let local = mapping(model)
        let inserting = LocalInserting(timestamp: timestamp, local: local)
        store.insert(data: inserting, for: key)
    }
}
