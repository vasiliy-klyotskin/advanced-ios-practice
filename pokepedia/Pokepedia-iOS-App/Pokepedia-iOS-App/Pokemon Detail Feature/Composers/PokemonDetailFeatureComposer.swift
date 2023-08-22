//
//  PokemonDetailFeatureComposer.swift
//  Pokepedia-iOS-App
//
//  Created by Василий Клецкин on 8/22/23.
//

import Combine
import Foundation
import Pokepedia
import Pokepedia_iOS

final class PokemonDetailFeatureComposer {
    func compose(for listItem: PokemonListItem) -> ListViewController {
        PokemonDetailUIComposer.compose(
            title: listItem.name,
            loader: detailLoader(for: listItem),
            imageLoader: detailImageLoader(for: listItem)
        )
    }
    
    private func detailLoader(for listItem: PokemonListItem) -> () -> AnyPublisher<DetailPokemon, Error> {
        {
            Deferred {
                Future { completion in
                    completion(.failure(NSError()))
                }
            }.eraseToAnyPublisher()
        }
    }
    
    private func detailImageLoader(for listItem: PokemonListItem) -> (URL) -> AnyPublisher<Data, Error> {
        { url in
            Deferred {
                Future { completion in
                    completion(.failure(NSError()))
                }
            }.eraseToAnyPublisher()
        }
    }
}
