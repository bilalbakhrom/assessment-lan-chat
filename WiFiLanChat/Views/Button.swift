//
//  Button.swift
//  WiFiLanChat
//
//  Created by Bilol Mamadjanov on 26/11/21.
//

import UIKit

class Button: UIButton {
    private var shadowLayer: CAShapeLayer!
    private var const: Constants
    
    override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1.0 : 0.5
        }
    }
    
    init() {
        const = Constants()
        super.init(frame: .zero)
        
        self.backgroundColor = .white
        layer.cornerRadius = const.cornerRadius
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard shadowLayer == nil else { return }
        shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
        shadowLayer.fillColor = (backgroundColor ?? .white).cgColor
        shadowLayer.shadowColor = (backgroundColor ?? .black).cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = const.shadowOffset
        shadowLayer.shadowOpacity = const.shadowOpacity
        shadowLayer.shadowRadius = const.blur
        
        layer.insertSublayer(shadowLayer, at: 0)
    }
}

extension Button {
    private struct Constants {
        let cornerRadius: CGFloat = 8
        let shadowOffset = CGSize(width: 0, height: 5)
        let shadowOpacity: Float = 0.33
        let blur: CGFloat = 19
        let fontSize: CGFloat = 16
    }
}
