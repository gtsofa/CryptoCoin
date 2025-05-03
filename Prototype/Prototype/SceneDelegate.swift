//
//  SceneDelegate.swift
//  Prototype
//
//  Created by Julius on 02/05/2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let coinVC = CoinViewController()
        coinVC.tabBarItem = UITabBarItem(title: "Coins", image: UIImage(systemName: "bitcoinsign.circle"), tag: 0)
        let coinNav = UINavigationController(rootViewController: coinVC)
        
        let favoritesVC = FavoritesViewController()
        favoritesVC.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star.fill"), tag: 1)
        let favoritesNav = UINavigationController(rootViewController: favoritesVC)
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [coinNav, favoritesNav]
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
}

