//
//  PokemonDetailMockLoader.swift
//  Pokepedia-iOS-AppTests
//
//  Created by Vasiliy Klyotskin on 7/26/23.
//

import Combine
import Pokepedia
import Foundation
import UIKit

final class PokemonDetailMockLoader {
    var loadDetailCallCount: Int { detailRequests.count }
    var detailRequests = [PassthroughSubject<DetailPokemon, Error>]()
    
    var imageUrls = [URL]()
    var imageRequests = [PassthroughSubject<DetailPokemonImage, Error>]()
    
    func load() -> AnyPublisher<DetailPokemon, Error> {
        let request = PassthroughSubject<DetailPokemon, Error>()
        detailRequests.append(request)
        return request.eraseToAnyPublisher()
    }
    
    func completeDetailLoading(with list: DetailPokemon, at index: Int) {
        detailRequests[index].send(list)
        detailRequests[index].send(completion: .finished)
    }
    
    func completeDetailLoadingWithError(at index: Int) {
        detailRequests[index].send(completion: .failure(anyNSError()))
    }
    
    func loadImage(for url: URL) -> AnyPublisher<DetailPokemonImage, Error> {
        let request = PassthroughSubject<DetailPokemonImage, Error>()
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
}
