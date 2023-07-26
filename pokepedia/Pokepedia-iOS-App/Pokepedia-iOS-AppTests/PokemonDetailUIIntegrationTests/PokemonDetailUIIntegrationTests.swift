
import XCTest
import UIKit
import Pokepedia_iOS_App
import Pokepedia_iOS
import Pokepedia

final class PokemonDetailUIIntegrationTests: XCTestCase {
    // MARK: - Pokemon List
    
    func test_pokemonDetail_hasTitle() throws {
        let (sut, _) = makeSut()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.title, pokemonDetailTitle)
    }
    
    func test_loadDetailActions_requestDetailFromLoader() {
        let (sut, loader) = makeSut()
        XCTAssertEqual(loader.loadDetailCallCount, 0, "Expected no loading requests before view is loaded")

        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadDetailCallCount, 1, "Expected a loading request once view is loaded")

        sut.simulateUserInitiatedReload()
        XCTAssertEqual(loader.loadDetailCallCount, 1, "Expected no request until previous completes")

        loader.completeDetailLoadingWithError(at: 0)
        sut.simulateUserInitiatedReload()
        XCTAssertEqual(loader.loadDetailCallCount, 2, "Expected another loading request once user initiates a reload")

        loader.completeDetailLoadingWithError(at: 1)
        sut.simulateUserInitiatedReload()
        XCTAssertEqual(loader.loadDetailCallCount, 3, "Expected yet another loading request once user initiates another reload")
    }

    func test_loadingDetailIndicator_isVisibleWhileLoadingDetail() {
        let (sut, loader) = makeSut()

        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once view is loaded")

        loader.completeDetailLoading(with: makeDetailPokemon(), at: 0)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once loading completes successfully")

        sut.simulateUserInitiatedReload()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once user initiates a reload")

        loader.completeDetailLoadingWithError(at: 1)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once user initiated loading completes with error")
    }

    func test_loadDetailCompletion_rendersErrorMessageOnErrorUntilNextReload() {
        let (sut, loader) = makeSut()

        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.errorMessage, nil, "Expected no error message once view is loaded")

        loader.completeDetailLoadingWithError(at: 0)
        XCTAssertEqual(sut.errorMessage, loadError, "Expected error message once loading completes with error first time")

        sut.simulateUserInitiatedReload()
        XCTAssertEqual(sut.errorMessage, nil, "Expected no error message after user initiated reloading")

        loader.completeDetailLoadingWithError(at: 1)
        XCTAssertEqual(sut.errorMessage, loadError, "Expected error message once loading completes with error second time")
    }
//
//    func test_loadListCompletion_rendersSuccessfullyLoadedList() {
//        let pokemon0 = makeListPokemon(specialType: nil)
//        let pokemon1 = makeListPokemon(specialType: itemType())
//        let (sut, loader) = makeSut()
//
//        sut.loadViewIfNeeded()
//        assertThat(sut, isRendering: [])
//
//        loader.completeListLoading(with: [pokemon0, pokemon1], at: 0)
//        assertThat(sut, isRendering: [pokemon0, pokemon1])
//
//        sut.simulateUserInitiatedReload()
//        loader.completeListLoadingWithError(at: 1)
//        assertThat(sut, isRendering: [pokemon0, pokemon1])
//
//        sut.simulateUserInitiatedReload()
//        loader.completeListLoading(with: [pokemon0], at: 2)
//        assertThat(sut, isRendering: [pokemon0])
//    }
//
//    func test_loadListCompletion_dispatchesFromBackgroundToMainThread() {
//        let (sut, loader) = makeSut()
//        sut.loadViewIfNeeded()
//
//        let exp = expectation(description: "Wait for background queue")
//        DispatchQueue.global().async {
//            loader.completeListLoading(at: 0)
//            exp.fulfill()
//        }
//        wait(for: [exp], timeout: 1.0)
//    }
//
//    // MARK: - Pokemon Item
//
//    func test_pokemonItemView_loadsImageURLWhenVisible() {
//        let pokemon0 = makeListPokemon()
//        let pokemon1 = makeListPokemon()
//        let (sut, loader) = makeSut()
//        sut.loadViewIfNeeded()
//        loader.completeListLoading(with: [pokemon0, pokemon1], at: 0)
//
//        XCTAssertEqual(loader.imageUrls, [], "Expected no image URL requests until views become visible")
//
//        let view0 = sut.simulateFeedImageViewVisible(at: 0)
//        XCTAssertEqual(loader.imageUrls, [pokemon0.imageUrl], "Expected first image URL request once first view becomes visible")
//
//        let view1 = sut.simulateFeedImageViewVisible(at: 1)
//        XCTAssertEqual(loader.imageUrls, [pokemon0.imageUrl, pokemon1.imageUrl], "Expected second image URL request once second view also becomes visible")
//
//        loader.completeImageLoadingWithError(at: 0)
//        view0?.simulateReload()
//        XCTAssertEqual(loader.imageUrls, [pokemon0.imageUrl, pokemon1.imageUrl, pokemon0.imageUrl], "Expected first image URL request once first image is reloaded")
//
//        loader.completeImageLoadingWithError(at: 1)
//        view1?.simulateReload()
//        XCTAssertEqual(loader.imageUrls, [pokemon0.imageUrl, pokemon1.imageUrl, pokemon0.imageUrl, pokemon1.imageUrl], "Expected second image URL request once second image is reloaded")
//    }
//
//    func test_pokemonItemViewLoadingIndicator_isVisibleWhileLoadingImage() {
//        let pokemon0 = makeListPokemon()
//        let pokemon1 = makeListPokemon()
//        let (sut, loader) = makeSut()
//        sut.loadViewIfNeeded()
//        loader.completeListLoading(with: [pokemon0, pokemon1], at: 0)
//
//        let view0 = sut.simulateFeedImageViewVisible(at: 0)
//        let view1 = sut.simulateFeedImageViewVisible(at: 1)
//        XCTAssertEqual(view0?.isLoading, true, "Expected loading indicator for first view while loading first image")
//        XCTAssertEqual(view1?.isLoading, true, "Expected loading indicator for second view while loading second image")
//
//        loader.completeImageLoading(at: 0)
//        XCTAssertEqual(view0?.isLoading, false, "Expected no loading indicator for first view once first image loading completes successfully")
//        XCTAssertEqual(view1?.isLoading, true, "Expected no loading indicator for second view once first image loading completes successfully")
//
//        loader.completeImageLoadingWithError(at: 1)
//        XCTAssertEqual(view0?.isLoading, false, "Expected no loading indicator state change for first view once second image loading completes with error")
//        XCTAssertEqual(view1?.isLoading, false, "Expected loading indicator state change for second view on retry action")
//
//        view0?.simulateReload()
//        XCTAssertEqual(view0?.isLoading, true, "Expected loading indicator state change for first view once first image reloaded")
//        XCTAssertEqual(view1?.isLoading, false, "Expected loading indicator state change for second view once first image reloaded")
//    }
//
//    func test_pokemonImageReloadControl_isVisibleWhenImageLoadingFailed() {
//        let (loader, view0, view1) = setupForShownItems()
//
//        XCTAssertEqual(view0?.isReloadControlShown, false, "Expected no reload control for first view while loading first image")
//        XCTAssertEqual(view1?.isReloadControlShown, false, "Expected no reload control for second view while loading second image")
//
//        loader.completeImageLoadingWithError(at: 0)
//        XCTAssertEqual(view0?.isReloadControlShown, true, "Expected reload control for first view once first image loading completes with error")
//        XCTAssertEqual(view1?.isReloadControlShown, false, "Expected no reload control indicator for second view once first image loading completes with error")
//
//        loader.completeImageLoading(at: 1)
//        XCTAssertEqual(view0?.isReloadControlShown, true, "Expected reload control for first view once second image loading completes with success")
//        XCTAssertEqual(view1?.isReloadControlShown, false, "Expected no reload control indicator for second view once second image loading completes with success")
//
//        view0?.simulateReload()
//        XCTAssertEqual(view0?.isReloadControlShown, false, "Expected no reload control for first view once first view reloaded")
//        XCTAssertEqual(view1?.isReloadControlShown, false, "Expected no reload control for second view once first view reloaded")
//    }
//
//    func test_pokemonImageView_imageVisibility() {
//        let (loader, view0, view1) = setupForShownItems()
//        XCTAssertEqual(view0?.renderedImage, nil, "Expected no rendered image for first view initially")
//        XCTAssertEqual(view1?.renderedImage, nil, "Expected no rendered image for second view initially")
//
//        loader.completeImageLoadingWithError(at: 0)
//        XCTAssertEqual(view0?.renderedImage, nil, "Expected no rendered image for first view when first image loading failed")
//        XCTAssertEqual(view1?.renderedImage, nil, "Expected no rendered image for second view when first image loading failed")
//
//        let invalidImage = Data("ivalid data".utf8)
//        loader.completeImageLoading(with: invalidImage, at: 1)
//        XCTAssertEqual(view0?.renderedImage, nil, "Expected no rendered image for first view when second invalid image loaded")
//        XCTAssertEqual(view1?.renderedImage, nil, "Expected no rendered image for second view when second invalid image loaded")
//
//        view0?.simulateReload()
//        let image0 = makeImage().pngData()
//        loader.completeImageLoading(with: image0, at: 2)
//        XCTAssertEqual(view0?.renderedImage, image0, "Expected rendered image for first view when first image reloaded")
//        XCTAssertEqual(view1?.renderedImage, nil, "Expected no rendered image for second view when first image reloaded")
//
//        view1?.simulateReload()
//        let image1 = makeImage().pngData()
//        loader.completeImageLoading(with: image1, at: 3)
//        XCTAssertEqual(view0?.renderedImage, image0, "Expected rendered image for first view when second valid image loaded")
//        XCTAssertEqual(view1?.renderedImage, image1, "Expected rendered image for second view when second valid image loaded")
//    }
//
//    func test_loadImageCompletion_dispatchesFromBackgroundToMainThread() {
//        let (loader, _, _) = setupForShownItems()
//        let image = makeImage().pngData()
//
//        let exp = expectation(description: "Wait for background queue")
//        DispatchQueue.global().async {
//            loader.completeImageLoading(with: image, at: 0)
//            exp.fulfill()
//        }
//        wait(for: [exp], timeout: 1.0)
//    }
    
    // MARK: - Helpers
    
//    private func setupForShownItems(file: StaticString = #filePath, line: UInt = #line) -> (PokemonListMockLoader, ListPokemonItemCell?, ListPokemonItemCell?) {
//        let pokemon0 = makeListPokemon()
//        let pokemon1 = makeListPokemon()
//        let (sut, loader) = makeSut(file: file, line: line)
//
//        sut.loadViewIfNeeded()
//        loader.completeListLoading(with: [pokemon0, pokemon1], at: 0)
//        let view0 = sut.simulateFeedImageViewVisible(at: 0)
//        let view1 = sut.simulateFeedImageViewVisible(at: 1)
//        return (loader, view0, view1)
//    }
    
    private func makeDetailPokemon() -> DetailPokemon {
        .init(
            info: .init(
                imageUrl: anyURL(),
                id: anyId(),
                name: anyName(),
                genus: anyId(),
                flavorText: anyId()
            ),
            abilities: [
                .init(
                    title: anyId(),
                    subtitle: anyId(),
                    damageClass: anyId(),
                    damageClassColor: anyId(),
                    type: anyId(),
                    typeColor: anyId()
                )
            ]
        )
    }
    
    private func makeSut(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (ListViewController, PokemonDetailMockLoader) {
        let loader = PokemonDetailMockLoader()
        let sut = PokemonDetailUIComposer.compose(
            title: pokemonDetailTitle,
            loader: loader.load
        )
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        return (sut, loader)
    }
    
    private var pokemonDetailTitle: String {
        "Pickachu"
    }
    
    private var loadError: String {
        LoadingResourcePresenter<Any, DummyView>.loadError
    }
//
//    private func makeImage() -> UIImage {
//        UIImage.make(withColor: .blue)
//    }
}

private struct DummyView: ResourceView {
    func display(viewModel: Any) {}
}
