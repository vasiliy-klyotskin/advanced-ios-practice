//
//  ListPokemonItemUIComposer.swift
//  Pokepedia-iOS-App
//
//  Created by Василий Клецкин on 6/2/23.
//

import Pokepedia
import UIKit
import Combine
import Pokepedia_iOS

enum ListPokemonItemUIComposer {
    typealias Presetner = LoadingResourcePresenter<Data, WeakProxy<ListPokemonItemViewController>>
    typealias PresentationAdapter = ResourceLoadingPresentationAdapter<ListPokemonItemImage, WeakProxy<ListPokemonItemViewController>>
    
    static func compose(
        item: PokemonListItem,
        loader: @escaping () -> AnyPublisher<ListPokemonItemImage, Error>
    ) -> ListPokemonItemViewController {
        let loadingAdapter = PresentationAdapter(loader: loader)
        let controller = ListPokemonItemViewController(
            viewModel: PokemonListPresenter.map(item: item),
            onImageRequest: loadingAdapter.load
        )
        let presenter = Presetner(
            view: WeakProxy(controller),
            errorView: WeakProxy(controller),
            loadingView: WeakProxy(controller),
            mapping: UIImage.tryFrom
        )
        loadingAdapter.presenter = presenter
        return controller
    }
}

private struct InvalidDataError: Error {}

extension UIImage {
    static func tryFrom(data: Data) throws -> UIImage {
        if let image = UIImage(data: data) {
            return image
        } else {
            throw InvalidDataError()
        }
    }
}
