//
//  LoadingResourcePresenterTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 5/22/23.
//

import XCTest
import Pokepedia

protocol ResourceView {}

final class LoadingResourcePresenter {
    init(view: ResourceView) {}
}

final class LoadingResourcePresenterTests: XCTestCase {
    func test_init_hasNoSideEffects() {
        let (_, view) = makeSut()
        
        XCTAssertEqual(view.messages, [])
    }
    
    // MARK: - Helpers
    
    typealias Presenter = LoadingResourcePresenter
    
    private func makeSut(file: StaticString = #filePath, line: UInt = #line) -> (Presenter, ResourceViewMock){
        let view = ResourceViewMock()
        let sut = Presenter(view: view)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }
}

final class ResourceViewMock: ResourceView {
    enum Message: Equatable {}
    let messages: [Message] = []
}
