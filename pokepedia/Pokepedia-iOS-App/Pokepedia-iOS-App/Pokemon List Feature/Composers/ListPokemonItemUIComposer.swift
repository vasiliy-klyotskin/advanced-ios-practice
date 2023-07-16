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
        let viewModel = PokemonListPresenter.map(
            item: item,
            colorMapping: UIColor.fromHex
        )
        let controller = ListPokemonItemViewController(
            viewModel: viewModel,
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

public extension UIColor {
    static func fromHex(_ hexString: String) -> UIColor {
        let hexint = Int(self.intFromHexString(hexStr: hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1)
        return color
    }
    
    static func intFromHexString(hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        let scanner: Scanner = Scanner(string: hexStr)
        hexInt = UInt32(bitPattern: scanner.scanInt32(representation: .hexadecimal) ?? 0)
        return hexInt
    }
}
