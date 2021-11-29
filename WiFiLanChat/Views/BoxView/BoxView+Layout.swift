//
//  BoxView+Layout.swift
//  WiFiLanChat
//
//  Created by Bilol Mamadjanov on 29/11/21.
//

import UIKit

extension BoxView {
    struct DrawingConstants {
        let vPadding: CGFloat = 8
        let hPadding: CGFloat = 12
        let cornerRadius: CGFloat = 8
    }
}

extension BoxView {
    func setup() {
        embedSuviews()
        setSubviewsConstraints()
    }
    
    func embedSuviews() {
        addSubview(textLabel)
    }
    
    func setSubviewsConstraints() {
        setTextLabelConstraints()
    }
}

extension BoxView {
    private func setTextLabelConstraints() {
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: topAnchor, constant: dwgConst.vPadding),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: dwgConst.hPadding),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -dwgConst.hPadding),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -dwgConst.vPadding)
        ])
    }
}
