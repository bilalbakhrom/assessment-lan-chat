//
//  Button.swift
//  WiFiLanChat
//
//  Created by Bilol Mamadjanov on 26/11/21.
//

import UIKit

class Button: UIButton {
    private var shadowLayer: CAShapeLayer!
    private let const: Constants
    
    override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1.0 : 0.5
        }
    }
    
    override init(frame: CGRect) {
        const = Constants()
        super.init(frame: frame)
                
        backgroundColor = .backgroundColor
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
        shadowLayer.fillColor = UIColor.white.cgColor
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = const.shadowOffset
        shadowLayer.shadowOpacity = const.shadowOpacity
        shadowLayer.shadowRadius = const.blur
        
        layer.insertSublayer(shadowLayer, at: 0)
    }
    
    func set(title: String, color: UIColor = UIColor.white) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: const.fontSize, weight: .semibold),
            .foregroundColor: color
        ]
        let attributedTitle = NSAttributedString(string: title, attributes: attributes)
        setAttributedTitle(attributedTitle, for: .normal)
    }
}

extension Button {
    private struct Constants {
        let cornerRadius: CGFloat = 8
        let shadowOffset = CGSize(width: 0, height: 5)
        let shadowOpacity: Float = 0.4
        let blur: CGFloat = 19
        let fontSize: CGFloat = 17
    }
}
