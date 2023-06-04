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
    // MARK: - Pokemon List
    
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
        XCTAssertEqual(sut.errorMessage, loadError, "Expected error message once loading completes with error first time")
        
        sut.simulateUserInitiatedReload()
        XCTAssertEqual(sut.errorMessage, nil, "Expected no error message after user initiated reloading")
        
        loader.completeListLoadingWithError(at: 1)
        XCTAssertEqual(sut.errorMessage, loadError, "Expected error message once loading completes with error second time")
    }
    
    func test_loadListCompletion_rendersSuccessfullyLoadedList() {
        let pokemon0 = makeListPokemon(specialType: nil)
        let pokemon1 = makeListPokemon(specialType: itemType())
        let (sut, loader) = makeSut()
        
        sut.loadViewIfNeeded()
        assertThat(sut, isRendering: [])
        
        loader.completeListLoading(with: [pokemon0, pokemon1], at: 0)
        assertThat(sut, isRendering: [pokemon0, pokemon1])
        
        sut.simulateUserInitiatedReload()
        loader.completeListLoadingWithError(at: 1)
        assertThat(sut, isRendering: [pokemon0, pokemon1])
        
        sut.simulateUserInitiatedReload()
        loader.completeListLoading(with: [pokemon0], at: 2)
        assertThat(sut, isRendering: [pokemon0])
    }
    
    func test_loadListCompletion_dispatchesFromBackgroundToMainThread() {
        let (sut, loader) = makeSut()
        sut.loadViewIfNeeded()
        
        let exp = expectation(description: "Wait for background queue")
        DispatchQueue.global().async {
            loader.completeListLoading(at: 0)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Pokemon Item
    
    func test_pokemonItemView_loadsImageURLWhenVisible() {
        let pokemon0 = makeListPokemon()
        let pokemon1 = makeListPokemon()
        let (sut, loader) = makeSut()
        
        sut.loadViewIfNeeded()
        loader.completeListLoading(with: [pokemon0, pokemon1], at: 0)
        
        XCTAssertEqual(loader.imageUrls, [], "Expected no image URL requests until views become visible")
        
        sut.simulateFeedImageViewVisible(at: 0)
        XCTAssertEqual(loader.imageUrls, [pokemon0.imageUrl], "Expected first image URL request once first view becomes visible")
        
        sut.simulateFeedImageViewVisible(at: 1)
        XCTAssertEqual(loader.imageUrls, [pokemon0.imageUrl, pokemon1.imageUrl], "Expected second image URL request once second view also becomes visible")
    }
    
    func test_pokemonItemViewLoadingIndicator_isVisibleWhileLoadingImage() {
        let pokemon0 = makeListPokemon()
        let pokemon1 = makeListPokemon()
        let (sut, loader) = makeSut()
        
        sut.loadViewIfNeeded()
        loader.completeListLoading(with: [pokemon0, pokemon1], at: 0)
        
        let view0 = sut.simulateFeedImageViewVisible(at: 0)
        let view1 = sut.simulateFeedImageViewVisible(at: 1)
        XCTAssertEqual(view0?.isLoading, true, "Expected loading indicator for first view while loading first image")
        XCTAssertEqual(view1?.isLoading, true, "Expected loading indicator for second view while loading second image")
        
        loader.completeImageLoading(at: 0)
        XCTAssertEqual(view0?.isLoading, false, "Expected no loading indicator for first view once first image loading completes successfully")
        XCTAssertEqual(view1?.isLoading, true, "Expected no loading indicator for second view once first image loading completes successfully")
        
        loader.completeImageLoadingWithError(at: 1)
        XCTAssertEqual(view0?.isLoading, false, "Expected no loading indicator state change for first view once second image loading completes with error")
        XCTAssertEqual(view1?.isLoading, false, "Expected loading indicator state change for second view on retry action")
        
        view0?.simulateReload()
        XCTAssertEqual(view0?.isLoading, true, "Expected loading indicator state change for first view once first image reloaded")
        XCTAssertEqual(view1?.isLoading, false, "Expected loading indicator state change for second view once first image reloaded")
    }
    
    func test_pokemonImageReloadControl_isVisibleWhenImageLoadingFailed() {
        let pokemon0 = makeListPokemon()
        let pokemon1 = makeListPokemon()
        let (sut, loader) = makeSut()
        
        sut.loadViewIfNeeded()
        loader.completeListLoading(with: [pokemon0, pokemon1], at: 0)
        
        let view0 = sut.simulateFeedImageViewVisible(at: 0)
        let view1 = sut.simulateFeedImageViewVisible(at: 1)
        XCTAssertEqual(view0?.isReloadControlShown, false, "Expected no reload control for first view while loading first image")
        XCTAssertEqual(view1?.isReloadControlShown, false, "Expected no reload control for second view while loading second image")
        
        loader.completeImageLoadingWithError(at: 0)
        XCTAssertEqual(view0?.isReloadControlShown, true, "Expected reload control for first view once first image loading completes with error")
        XCTAssertEqual(view1?.isReloadControlShown, false, "Expected no reload control indicator for second view once first image loading completes with error")
        
        loader.completeImageLoading(at: 1)
        XCTAssertEqual(view0?.isReloadControlShown, true, "Expected reload control for first view once second image loading completes with success")
        XCTAssertEqual(view1?.isReloadControlShown, false, "Expected no reload control indicator for second view once second image loading completes with success")
        
        view0?.simulateReload()
        XCTAssertEqual(view0?.isReloadControlShown, false, "Expected no reload control for first view once first view reloaded")
        XCTAssertEqual(view1?.isReloadControlShown, false, "Expected no reload control for second view once first view reloaded")
    }
    
    // MARK: - Helpers
    
    private func makeSut(file: StaticString = #filePath, line: UInt = #line) -> (PokemonListViewController, MockLoader) {
        let loader = MockLoader()
        let sut = PokemonListUIComposer.compose(
            loader: loader.load,
            imageLoader: loader.loadImage
        )
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
    
    private func makeListPokemon(specialType: PokemonListItemType? = nil) -> PokemonListItem {
        .init(
            id: anyId(),
            name: anyName(),
            imageUrl: anyURL(),
            physicalType: itemType(),
            specialType: specialType
        )
    }
    
    private func itemType() -> PokemonListItemType {
        .init(color: anyId(), name: anyName())
    }
    
    private var pokemonListTitle: String {
        PokemonListPresenter.title
    }
    
    private var loadError: String {
        LoadingResourcePresenter<Any, DummyView>.loadError
    }
    
    private final class MockLoader {
        var loadListCallCount: Int { listRequests.count }
        var listRequests = [PassthroughSubject<PokemonList, Error>]()
        
        var imageUrls = [URL]()
        var imageRequests = [PassthroughSubject<ListPokemonItemImage, Error>]()
        
        func load() -> AnyPublisher<PokemonList, Error> {
            let request = PassthroughSubject<PokemonList, Error>()
            listRequests.append(request)
            return request.eraseToAnyPublisher()
        }
        
        func loadImage(for url: URL) -> AnyPublisher<ListPokemonItemImage, Error> {
            let request = PassthroughSubject<ListPokemonItemImage, Error>()
            imageUrls.append(url)
            imageRequests.append(request)
            return request.eraseToAnyPublisher()
        }
        
        func completeImageLoading(with image: ListPokemonItemImage = .init(), at index: Int) {
            imageRequests[index].send(image)
            imageRequests[index].send(completion: .finished)
        }
        
        func completeImageLoadingWithError(at index: Int) {
            imageRequests[index].send(completion: .failure(anyNSError()))
        }
        
        func completeListLoading(with list: PokemonList = [], at index: Int) {
            listRequests[index].send(list)
            listRequests[index].send(completion: .finished)
        }
        
        func completeListLoadingWithError(at index: Int) {
            listRequests[index].send(completion: .failure(anyNSError()))
        }
    }
}

private struct DummyView: ResourceView {
    func display(viewModel: Any) {}
}
