
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

    func test_loadDetailCompletion_rendersSuccessfullyLoadedDetail() {
        let pokemon0 = makeDetailPokemon()
        let pokemon1 = makeDetailPokemon()
        let (sut, loader) = makeSut()

        sut.loadViewIfNeeded()
        assertThat(sut, isRendering: nil)

        loader.completeDetailLoading(with: pokemon0, at: 0)
        assertThat(sut, isRendering: pokemon0)

        sut.simulateUserInitiatedReload()
        loader.completeDetailLoadingWithError(at: 1)
        assertThat(sut, isRendering: pokemon0)

        sut.simulateUserInitiatedReload()
        loader.completeDetailLoading(with: pokemon1, at: 2)
        assertThat(sut, isRendering: pokemon1)
    }

    func test_loadListCompletion_dispatchesFromBackgroundToMainThread() {
        let (sut, loader) = makeSut()
        sut.loadViewIfNeeded()

        let exp = expectation(description: "Wait for background queue")
        DispatchQueue.global().async {
            loader.completeDetailLoading(with: self.makeDetailPokemon(), at: 0)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }

    // MARK: - Pokemon Info

    func test_pokemonInfoView_loadsImageURLWhenVisible() {
        let pokemon = makeDetailPokemon()
        let (sut, loader) = makeSut()
        sut.loadViewIfNeeded()
        loader.completeDetailLoading(with: pokemon, at: 0)

        XCTAssertEqual(loader.imageUrls, [], "Expected no image URL requests until views become visible")

        let view = sut.simulatePokemonDetailInfoViewVisible()
        XCTAssertEqual(loader.imageUrls, [pokemon.info.imageUrl], "Expected an image URL request once info view becomes visible")

        loader.completeImageLoadingWithError(at: 0)
        view?.simulateReload()
        XCTAssertEqual(loader.imageUrls, [pokemon.info.imageUrl, pokemon.info.imageUrl], "Expected an image URL request once image is reloaded")
    }

    func test_pokemonInfoViewImageLoadingIndicator_isVisibleWhileLoadingImage() {
        let pokemon = makeDetailPokemon()
        let (sut, loader) = makeSut()
        sut.loadViewIfNeeded()
        loader.completeDetailLoading(with: pokemon, at: 0)

        let view = sut.simulatePokemonDetailInfoViewVisible()
        XCTAssertEqual(view?.isLoading, true, "Expected loading indicator for the view while loading an image")

        loader.completeImageLoadingWithError(at: 0)
        XCTAssertEqual(view?.isLoading, false, "Expected no loading indicator for the view once image loading is completed with error")

        view?.simulateReload()
        XCTAssertEqual(view?.isLoading, true, "Expected loading indicator for the view once image is reloaded")
        
        loader.completeImageLoading(at: 1)
        XCTAssertEqual(view?.isLoading, false, "Expected no loading indicator for the view once image loading is completed successfully")
    }

    func test_pokemonDetailInfoImageReloadControl_isVisibleWhenImageLoadingIsFailed() {
        let pokemon = makeDetailPokemon()
        let (sut, loader) = makeSut()
        sut.loadViewIfNeeded()
        loader.completeDetailLoading(with: pokemon, at: 0)

        let view = sut.simulatePokemonDetailInfoViewVisible()
        XCTAssertEqual(view?.isReloadControlShown, false, "Expected no reload control for the view while loading an image")

        loader.completeImageLoadingWithError(at: 0)
        XCTAssertEqual(view?.isReloadControlShown, true, "Expected reload control for the view once an image loading completes with error")

        view?.simulateReload()
        XCTAssertEqual(view?.isReloadControlShown, false, "Expected no reload control for the view while the view is being reloaded")
        
        loader.completeImageLoading(at: 1)
        XCTAssertEqual(view?.isReloadControlShown, false, "Expected no reload control for the view once first image loading completes with success")
    }

    func test_pokemonDetailImageView_imageVisibility() {
        let pokemon = makeDetailPokemon()
        let (sut, loader) = makeSut()
        sut.loadViewIfNeeded()
        loader.completeDetailLoading(with: pokemon, at: 0)
        
        let view = sut.simulatePokemonDetailInfoViewVisible()
        XCTAssertEqual(view?.renderedImage, nil, "Expected no rendered image for the view initially")

        loader.completeImageLoadingWithError(at: 0)
        XCTAssertEqual(view?.renderedImage, nil, "Expected no rendered image for the view when an image loading is failed")

        view?.simulateReload()
        XCTAssertEqual(view?.renderedImage, nil, "Expected no rendered image for the view when an image loading is reloaded")
        
        let invalidImage = Data("ivalid data".utf8)
        loader.completeImageLoading(with: invalidImage, at: 1)
        XCTAssertEqual(view?.renderedImage, nil, "Expected no rendered image for the view when an invalid image is loaded")

        view?.simulateReload()
        XCTAssertEqual(view?.renderedImage, nil, "Expected no rendered image for the view when an image loading is reloaded")
        
        let image = makeImage().pngData()
        loader.completeImageLoading(with: image, at: 2)
        XCTAssertEqual(view?.renderedImage, image, "Expected a rendered image for the view when the image is loaded successfuly")
    }

    func test_loadDetailImageCompletion_dispatchesFromBackgroundToMainThread() {
        let pokemon = makeDetailPokemon()
        let (sut, loader) = makeSut()
        let image = makeImage().pngData()
        sut.loadViewIfNeeded()
        loader.completeDetailLoading(with: pokemon, at: 0)
        
        _ = sut.simulatePokemonDetailInfoViewVisible()

        let exp = expectation(description: "Wait for background queue")
        DispatchQueue.global().async {
            loader.completeImageLoading(with: image, at: 0)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Helpers
    
    private func makeDetailPokemon() -> DetailPokemon {
        .init(
            info: .init(
                imageUrl: anyURL(),
                id: "any id",
                name: "any name",
                genus: "any genus",
                flavorText: "any flavor text"
            ),
            abilities: [
                .init(
                    title: "any title",
                    subtitle: "any subtitle",
                    damageClass: "any class",
                    damageClassColor: "any damage class color",
                    type: "any type",
                    typeColor: "any type color"
                ),
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
            loader: loader.load,
            imageLoader: loader.loadImage
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

    private func makeImage() -> UIImage {
        UIImage.make(withColor: .blue)
    }
    
    private struct DummyView: ResourceView {
        func display(viewModel: Any) {}
    }
}
