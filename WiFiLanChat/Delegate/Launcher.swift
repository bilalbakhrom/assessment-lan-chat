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
        let navController = makeNavigationController(rootViewController: startVC)
        window.rootViewController = navController
        window.makeKeyAndVisible()
    }
    
    private func makeNavigationController(rootViewController: UIViewController) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)
        
        return navController
    }
}
