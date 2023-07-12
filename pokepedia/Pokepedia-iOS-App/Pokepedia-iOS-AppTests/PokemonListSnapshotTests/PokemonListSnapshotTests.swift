//
//  PokemonListSnapshotTests.swift
//  Pokepedia-iOS-AppTests
//
//  Created by Василий Клецкин on 7/12/23.
//

import XCTest
import Combine
import Pokepedia
import Pokepedia_iOS
import Pokepedia_iOS_App

final class PokemonListSnapshotTests: XCTestCase {
    
    func test_listIsLoadingSnapshot() {
        let (sut, _) = makeSut()
        
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "POKEMON_LIST_LOADING_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "POKEMON_LIST_LOADING_dark")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light, contentSize: .extraExtraExtraLarge)), named: "POKEMON_LIST_LOADING_light_extraExtraExtraLarge")
    }
    
    func test_listLoadedWithErrorSnapshot() {
        let (sut, loader) = makeSut()
        
        loader.completeListLoadingWithError(at: 0)
        
        record(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "POKEMON_LIST_ERROR_light")
        record(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "POKEMON_LIST_ERROR_dark")
        record(snapshot: sut.snapshot(for: .iPhone13(style: .light, contentSize: .extraExtraExtraLarge)), named: "POKEMON_LIST_ERROR_light_extraExtraExtraLarge")
    }
    
    // MARK: - Helpers
    
    private func makeSut(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (PokemonListViewController, MockLoader) {
        let mock = MockLoader()
        let sut = PokemonListUIComposer.compose(
            loader: mock.load,
            imageLoader: mock.loadImage
        )
        sut.loadViewIfNeeded()
        sut.tableView.showsVerticalScrollIndicator = false
        sut.tableView.showsHorizontalScrollIndicator = false
        return (sut, mock)
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
        
        func completeImageLoading(with image: ListPokemonItemImage? = nil, at index: Int) {
            let defaultImage = UIImage.make(withColor: .blue).pngData()!
            imageRequests[index].send(image ?? defaultImage)
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
