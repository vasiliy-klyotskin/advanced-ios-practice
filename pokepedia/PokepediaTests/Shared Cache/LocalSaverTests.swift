//
//  LocalSaverTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 5/20/23.
//

import XCTest
import Pokepedia

struct LocalInserting<Local> {
    let timestamp: Date
    let local: Local
}

protocol LocalSaverStore {
    associatedtype Local
    
    func insert(data: LocalInserting<Local>, for key: String)
    func delete(for key: String)
}

final class LocalSaver<Local, Model, Store: LocalSaverStore> where Store.Local == Local {
    typealias Mapping = (Model) -> Local
    
    private let store: Store
    private let mapping: Mapping
    private let current: () -> Date
    
    init(
        store: Store,
        mapping: @escaping Mapping,
        current: @escaping () -> Date = Date.init
    ) {
        self.store = store
        self.mapping = mapping
        self.current = current
    }
    
    func save(_ model: Model, for key: String) {
        store.delete(for: key)
        let timestamp = current()
        let local = mapping(model)
        let inserting = LocalInserting(timestamp: timestamp, local: local)
        store.insert(data: inserting, for: key)
    }
}

final class LocalSaverTests: XCTestCase {
    func test_init_hasNoSideEffects() {
        let (_, store) = makeSut()
        
        XCTAssertTrue(store.messages.isEmpty)
    }
    
    func test_save_replacesOldCacheWithNewOneForKey() {
        let timestamp = Date()
        let model = ModelStub()
        let local = LocalStub()
        let key = anyKey()
        let (sut, store) = makeSut(
            mapping: mappingStub(model: model, local: local),
            current: timestamp
        )
        
        sut.save(model, for: key)
        
        XCTAssertEqual(store.messages, [.delete(key), .insert(local, timestamp, key)])
    }
    
    // MARK: - Helpers
    
    typealias Saver = LocalSaver<LocalStub, ModelStub, StoreMock>
    
    private func makeSut(
        file: StaticString = #filePath,
        line: UInt = #line,
        mapping: ((ModelStub) -> LocalStub)? = nil,
        current: Date = .init()
    ) -> (Saver, StoreMock) {
        let store = StoreMock()
        let sut = Saver(
            store: store,
            mapping: mapping ?? { _ in .init() },
            current: { current }
        )
        trackForMemoryLeaks(store)
        trackForMemoryLeaks(sut)
        return (sut, store)
    }
    
    private func mappingStub(
        file: StaticString = #filePath,
        line: UInt = #line,
        model: ModelStub,
        local: LocalStub
    ) -> (ModelStub) -> LocalStub {
        { actualModel in
            XCTAssertEqual(model, actualModel, "Mapping should be called with right model")
            return local
        }
    }
    
    private func anyKey() -> String {
        anyId()
    }
}
