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
        let message = localized(
            "GENERIC_CONNECTION_ERROR",
            table: "Shared",
            bundleType: Presenter.self
        )
        
        sut.didFinishLoadingWithError()
        
        XCTAssertEqual(view.messages, [
            .display(errorMessage: message),
            .display(isLoading: false)
        ])
    }
    
    func test_didFinishWithResource_finishesLoadingAndDisplaysResource() {
        let (sut, view) = makeSut {
            $0 + " view model"
        }
        
        sut.didFinishLWithResource("resource")
        
        XCTAssertEqual(view.messages, [
            .display(isLoading: false),
            .display(viewModel: "resource view model")
        ])
    }
    
    func test_didFinishLoadingWithMapperError_displaysLocalizedErrorMessageAndStopsLoading() {
        let (sut, view) = makeSut { _ in
            throw anyNSError()
        }
        let message = localized(
            "GENERIC_CONNECTION_ERROR",
            table: "Shared",
            bundleType: Presenter.self
        )
        
        sut.didFinishLWithResource("resource")
        
        XCTAssertEqual(view.messages, [
            .display(errorMessage: message),
            .display(isLoading: false)
        ])
    }
    
    // MARK: - Helpers
    
    typealias Presenter = LoadingResourcePresenter<String, ResourceViewMock>
    
    private func makeSut(
        mapping: @escaping (String) throws -> String = { _ in "" },
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (Presenter, ResourceViewMock){
        let view = ResourceViewMock()
        let sut = Presenter(view: view, errorView: view, loadingView: view, mapping: mapping)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }
}

final class ResourceViewMock: ResourceView, ResourceLoadingView, ResourceErrorView {
    typealias Resource = String
    
    enum Message: Hashable, Equatable {
        case display(errorMessage: String?)
        case display(isLoading: Bool)
        case display(viewModel: String)
    }
    
    var messages: Set<Message> = []
    
    func display(loadingViewModel: LoadingViewModel) {
        messages.insert(.display(isLoading: loadingViewModel.isLoading))
    }
    
    func display(errorViewModel: ErrorViewModel) {
        messages.insert(.display(errorMessage: errorViewModel.errorMessage))
    }
    
    func display(viewModel: String) {
        messages.insert(.display(viewModel: viewModel))
    }
}
