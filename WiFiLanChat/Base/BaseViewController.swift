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
        
        overrideUserInterfaceStyle = .light
        view.layer.addSublayer(gradientLayer)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        gradientLayer.frame = view.bounds
    }
    
    func hideKeyboardWhenTappedOnView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    func showAlert(title: String, message: String?, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
        present(alert, animated: true)
    }
    
    // MARK: - Actions
    @objc private func hideKeyboard() {
        view.endEditing(true)
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

@objc extension BaseViewController {
    func setupSubviews() {
        embedSubviews()
        setSubviewsConstraints()
    }
    
    func embedSubviews() {}
    
    func setSubviewsConstraints() {}
}
