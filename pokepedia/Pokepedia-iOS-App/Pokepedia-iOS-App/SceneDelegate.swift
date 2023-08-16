//
//  SceneDelegate.swift
//  Pokepedia-iOS-App
//
//  Created by Василий Клецкин on 5/26/23.
//

import UIKit
import Pokepedia_iOS

public class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    public var window: UIWindow?

    public func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        configureWindow()
    }
    
    public func configureWindow() {
        let pokemonListVc = ListViewController()
        let navigationController = UINavigationController(rootViewController: pokemonListVc)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
