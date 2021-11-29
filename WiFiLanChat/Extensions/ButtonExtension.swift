//
//  ButtonExtension.swift
//  WiFiLanChat
//
//  Created by Bilol Mamadjanov on 29/11/21.
//

import UIKit

extension UIButton {
    func set(title: String, color: UIColor) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .semibold),
            .foregroundColor: color
        ]
        let title = NSAttributedString(
            string: title,
            attributes: attributes
        )
        
        setAttributedTitle(title, for: .normal)
    }
}
