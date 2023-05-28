//
//  PokemonListUIComposer.swift
//  Pokepedia-iOS-App
//
//  Created by Василий Клецкин on 5/28/23.
//

import Pokepedia
import UIKit

public enum PokemonListUIComposer {
    public static func compose() -> UIViewController {
        let controller = UIViewController()
        controller.title = PokemonListPresenter.title
        return controller
    }
}
