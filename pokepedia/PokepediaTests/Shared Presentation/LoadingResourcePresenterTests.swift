//
//  LoadingResourcePresenterTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 5/22/23.
//

import XCTest
import Pokepedia

final class LoadingResourcePresenterTests: XCTestCase {
    func test_init_hasNoSideEffects() {
        let (_, view) = makeSut()
        
        XCTAssertEqual(view.messages, [])
    }
    
    func test_didStartLoading_hidesErrorAndStartsLoading() {
        let (sut, view) = makeSut()
        
        sut.didStartLoading()
        
        XCTAssertEqual(view.messages, [
            .display(errorMessage: nil),
            .display(isLoading: true)
        ])
    }
    
    func test_didFinishWithError_finishesLoadingAndShowsError() {
        let (sut, view) = makeSut()
        let message = localized("GENERIC_CONNECTION_ERROR")
        
        sut.didFinishLoadingWithError()
        
        XCTAssertEqual(view.messages, [
            .display(errorMessage: message),
            .display(isLoading: false)
        ])
    }
    
    // MARK: - Helpers
    
    typealias Presenter = LoadingResourcePresenter
    
    private func makeSut(file: StaticString = #filePath, line: UInt = #line) -> (Presenter, ResourceViewMock){
        let view = ResourceViewMock()
        let sut = Presenter(view: view, errorView: view, loadingView: view)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }
    
    private func localized(_ key: String, file: StaticString = #file, line: UInt = #line) -> String {
        let table = "Shared"
        let bundle = Bundle(for: Presenter.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }
        return value
    }
}

final class ResourceViewMock: ResourceView, ResourceLoadingView, ResourceErrorView {
    enum Message: Hashable, Equatable {
        case display(errorMessage: String?)
        case display(isLoading: Bool)
    }
    
    var messages: Set<Message> = []
    
    func display(loadingViewModel: Bool) {
        messages.insert(.display(isLoading: loadingViewModel))
    }
    
    func display(errorViewModel: String?) {
        messages.insert(.display(errorMessage: errorViewModel))
    }
}
