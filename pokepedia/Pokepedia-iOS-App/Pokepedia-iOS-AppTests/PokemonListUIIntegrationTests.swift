//
//  PokemonListUIIntegrationTests.swift
//  Pokepedia-iOS-AppTests
//
//  Created by Василий Клецкин on 5/28/23.
//

import XCTest
import UIKit
import Pokepedia_iOS_App
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
    
    // MARK: - Helpers
    
    private func makeSut(file: StaticString = #filePath, line: UInt = #line) -> (PokemonListViewController, MockLoader) {
        let loader = MockLoader()
        let sut = PokemonListUIComposer.compose(loader: loader.load)
        trackForMemoryLeaks(loader, file: file)
        trackForMemoryLeaks(sut, line: line)
        return (sut, loader)
    }
    
    private var pokemonListTitle: String {
        PokemonListPresenter.title
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
    }
}

extension UIControl {
    func simulate(event: UIControl.Event) {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: event)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}

extension UIRefreshControl {
    func simulatePullToRefresh() {
        simulate(event: .valueChanged)
    }
}

extension PokemonListViewController {
    func simulateUserInitiatedReload() {
        refreshControl?.simulatePullToRefresh()
    }
}
