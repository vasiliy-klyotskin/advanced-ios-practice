//
//  LocalSaverTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 5/20/23.
//

import XCTest
import Pokepedia

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
    
    typealias Saver = LocalSaver<LocalStub, ModelStub>
    
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
}
