//
//  Launcher.swift
//  WiFiLanChat
//
//  Created by Bilol Mamadjanov on 26/11/21.
//

import UIKit

class Launcher {
    let window: UIWindow
    
    init(windowScene: UIWindowScene) {
        window = UIWindow(windowScene: windowScene)
    }
    
    func launch() {
        navigateToStartPage()
    }
    
    private func navigateToStartPage() {
        let startVC = StartViewController()
        let navController: BaseNavigationController = makeNavController(rootViewController: startVC)
        window.rootViewController = navController
        window.makeKeyAndVisible()
    }
    
    func makeNavController<T: UINavigationController>(rootViewController: UIViewController) -> T {
        let navController = T(rootViewController: rootViewController)
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        navBarAppearance.backgroundColor = .clear
        navBarAppearance.shadowColor = nil
        navController.navigationBar.tintColor = .black
        navController.navigationBar.isTranslucent = true
        navController.navigationBar.standardAppearance = navBarAppearance
        
        return navController
    }
}
