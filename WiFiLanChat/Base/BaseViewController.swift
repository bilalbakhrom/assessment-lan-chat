//
//  BaseViewController.swift
//  WiFiLanChat
//
//  Created by Bilol Mamadjanov on 26/11/21.
//

import UIKit

class BaseViewController: UIViewController {
    private let uiConst = UIConstants()
    
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = uiConst.gradientColors
        layer.locations = uiConst.gradientLocations
        layer.startPoint = uiConst.gradientStartPoint
        layer.endPoint = uiConst.gradientEndPoint
        
        return layer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.addSublayer(gradientLayer)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
}

extension BaseViewController {
    private struct UIConstants {
        let gradientColors: [CGColor] = [
            UIColor(red: 0.882, green: 0.902, blue: 0.941, alpha: 1).cgColor,
            UIColor(red: 0.69, green: 0.729, blue: 0.82, alpha: 1).cgColor
        ]
        let gradientLocations: [NSNumber] = [0, 1]
        let gradientStartPoint = CGPoint(x: 0.25, y: 0.5)
        let gradientEndPoint = CGPoint(x: 0.75, y: 0.5)
    }
}
