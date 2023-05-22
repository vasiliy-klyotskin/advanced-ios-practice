//
//  LoadingResourcePresenterTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 5/22/23.
//

import XCTest
import Pokepedia

protocol ResourceView {
    
}

protocol ResourceLoadingView {
    func display(loadingViewModel: Bool)
}

protocol ResourceErrorView {
    func display(errorViewModel: String?)
}

final class LoadingResourcePresenter {
    private let errorView: ResourceErrorView
    private let loadingView: ResourceLoadingView
    
    init(
        view: ResourceView,
        errorView: ResourceErrorView,
        loadingView: ResourceLoadingView
    ) {
        self.errorView = errorView
        self.loadingView = loadingView
    }
    
    func didStartLoading() {
        errorView.display(errorViewModel: nil)
        loadingView.display(loadingViewModel: true)
    }
}

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
    
    // MARK: - Helpers
    
    typealias Presenter = LoadingResourcePresenter
    
    private func makeSut(file: StaticString = #filePath, line: UInt = #line) -> (Presenter, ResourceViewMock){
        let view = ResourceViewMock()
        let sut = Presenter(view: view, errorView: view, loadingView: view)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
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
