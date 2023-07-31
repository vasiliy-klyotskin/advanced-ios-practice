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
    
    func insert(_ data: LocalInserting<Local>, for key: String)
    func delete(for key: String)
}

public final class LocalSaver<Local, Model>  {
    public typealias Mapping = (Model) -> Local
    
    private let insert: (_ data: LocalInserting<Local>, _ key: String) -> Void
    private let delete: (_ key: String) -> Void
    private let mapping: Mapping
    private let current: () -> Date
    
    public init<Store: LocalSaverStore>(
        store: Store,
        mapping: @escaping Mapping,
        current: @escaping () -> Date = Date.init
    ) where Store.Local == Local {
        self.insert = store.insert
        self.delete = store.delete
        self.mapping = mapping
        self.current = current
    }
    
    public func save(_ model: Model, for key: String) {
        delete(key)
        let timestamp = current()
        let local = mapping(model)
        let inserting = LocalInserting(timestamp: timestamp, local: local)
        insert(inserting, key)
    }
}
