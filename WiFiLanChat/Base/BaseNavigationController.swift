//
//  BaseNavigationController.swift
//  WiFiLanChat
//
//  Created by Bilol Mamadjanov on 27/11/21.
//

import UIKit

final class BaseNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNeedsStatusBarAppearanceUpdate()
    }
}
