//
//  PokemonListUIIntegrationTests.swift
//  Pokepedia-iOS-AppTests
//
//  Created by Василий Клецкин on 5/28/23.
//

import XCTest
import UIKit
import Pokepedia_iOS_App
import Pokepedia_iOS
import Pokepedia
import Combine

final class PokemonListUIIntegrationTests: XCTestCase {
    func test_pokemonList_hasTitle() throws {
        let (sut, _) = makeSut()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.title, pokemonListTitle)
    }
    
    func test_loadListActions_requestListFromLoader() {
        let (sut, loader) = makeSut()
        XCTAssertEqual(loader.loadListCallCount, 0, "Expected no loading requests before view is loaded")
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadListCallCount, 1, "Expected a loading request once view is loaded")
        
        sut.simulateUserInitiatedReload()
        XCTAssertEqual(loader.loadListCallCount, 1, "Expected no request until previous completes")
        
        loader.completeListLoading(at: 0)
        sut.simulateUserInitiatedReload()
        XCTAssertEqual(loader.loadListCallCount, 2, "Expected another loading request once user initiates a reload")
        
        loader.completeListLoading(at: 1)
        sut.simulateUserInitiatedReload()
        XCTAssertEqual(loader.loadListCallCount, 3, "Expected yet another loading request once user initiates another reload")
    }
    
    func test_loadingListIndicator_isVisibleWhileLoadingList() {
        let (sut, loader) = makeSut()
        
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once view is loaded")
        
        loader.completeListLoading(at: 0)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once loading completes successfully")
        
        sut.simulateUserInitiatedReload()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once user initiates a reload")
        
        loader.completeListLoadingWithError(at: 1)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once user initiated loading completes with error")
    }
    
    func test_loadListCompletion_rendersErrorMessageOnErrorUntilNextReload() {
        let (sut, loader) = makeSut()
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.errorMessage, nil, "Expected no error message once view is loaded")
        
        loader.completeListLoadingWithError(at: 0)
        XCTAssertEqual(sut.errorMessage, loadError, "Expected error message once loading completes with error")
        
        sut.simulateUserInitiatedReload()
        XCTAssertEqual(sut.errorMessage, nil, "Expected no error message once list is reloaded")
    }
    
    // MARK: - Helpers
    
    private func makeSut(file: StaticString = #filePath, line: UInt = #line) -> (PokemonListViewController, MockLoader) {
        let loader = MockLoader()
        let sut = PokemonListUIComposer.compose(loader: loader.load)
        trackForMemoryLeaks(loader, file: file)
        trackForMemoryLeaks(sut, line: line)
        return (sut, loader)
    }
    
    private final class MockLoader {
        var loadListCallCount: Int { requests.count }
        var requests = [PassthroughSubject<PokemonList, Error>]()
        
        func load() -> AnyPublisher<PokemonList, Error> {
            let request = PassthroughSubject<PokemonList, Error>()
            requests.append(request)
            return request.eraseToAnyPublisher()
        }
        
        func completeListLoading(at index: Int) {
            requests[index].send([])
            requests[index].send(completion: .finished)
        }
        
        func completeListLoadingWithError(at index: Int) {
            requests[index].send(completion: .failure(anyNSError()))
        }
    }
}
