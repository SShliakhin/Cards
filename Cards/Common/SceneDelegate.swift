//
//  SceneDelegate.swift
//  Cards
//
//  Created by SERGEY SHLYAKHIN on 07.08.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        guard let window = window else { return }
        window.backgroundColor = .lightGray
        window.windowScene = windowScene
        let mainController = StartController()
        let navigationController = UINavigationController(rootViewController: mainController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}

