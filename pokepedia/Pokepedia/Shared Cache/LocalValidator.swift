//
//  LocalValidator.swift
//  Pokepedia
//
//  Created by Василий Клецкин on 5/21/23.
//

import Foundation

public protocol LocalValidatorStore {
    func retrieveTimestamp(for key: String) -> Date?
    func delete(for key: String)
}

public final class LocalValidator {
    public typealias Validation = (Date) -> Bool
    
    private let validation: Validation
    private let store: LocalValidatorStore
    
    public init(store: LocalValidatorStore, validation: @escaping Validation) {
        self.validation = validation
        self.store = store
    }
    
    public func validate(for key: String) {
        guard let timestamp = store.retrieveTimestamp(for: key) else { return }
        guard !validation(timestamp) else { return }
        store.delete(for: key)
    }
}
