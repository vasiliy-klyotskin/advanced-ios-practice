//
//  CoreDataStore.swift
//  Pokepedia
//
//  Created by Василий Клецкин on 7/29/23.
//

import Foundation

public struct CoreDataStore: LocalLoaderStore, LocalSaverStore, LocalValidatorStore {
    public typealias Local = Data
    
    public init() {}
    
    public func delete(for key: String) {
        
    }
    
    public func retrieveTimestamp(for key: String) -> Date? {
        nil
    }
    
    public func retrieve(for key: String) -> Pokepedia.LocalRetrieval<Local>? {
        nil
    }
    
    public func insert(_ data: Pokepedia.LocalInserting<Local>, for key: String) {
        
    }
}
