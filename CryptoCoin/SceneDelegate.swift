//
//  SceneDelegate.swift
//  CryptoCoin
//
//  Created by Julius on 29/04/2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        //guard let window = (scene as? UIWindowScene) else { return }
        //let window = UIWindow(windowScene: windowScene)
        //let controller =   CoinViewController()//HomeController() //ViewController() //HomeController() //LoginController()
        //window.rootViewController = UINavigationController(rootViewController: controller)
        //window.makeKeyAndVisible()
        //self.window = window
        
        let loader = CoinLoader.self
        
        window = UIWindow()
        window?.rootViewController = CoinViewController(loader: loader as! CoinLoader )//makeRootViewController()
        window?.makeKeyAndVisible()
    }
    
//    private func makeRootViewController() -> UIViewController {
//        let tabBar = UITabBarController()
//        tabBar.viewControllers = [mvc()] //[mvc(), mvvm(), mvp()]
//        return tabBar
//    }
//    
//    private func mvc() -> UIViewController {
//        let view = UINavigationController(
//            rootViewController: MVC.FeedUIComposer.feedComposedWith(
//                feedLoader: AlwaysFailingLoader(delay: 1.5),
//                //imageLoader: AlwaysFailingLoader(delay: 1.5)))
//        view.tabBarItem.title = "Coins"
//        return view
//    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }


}

