//
//  SearchViewController+Layout.swift
//  WiFiLanChat
//
//  Created by Bilol Mamadjanov on 27/11/21.
//

import UIKit

extension SearchViewController {
    struct DrawingConstants {
        let ipFieldTop: CGFloat = 160
    }
}

extension SearchViewController {
    override func embedSubviews() {
        view.addSubview(ipField)
    }
    
    override func setSubviewsConstraints() {
        setIPFieldConstraints()
    }
}

extension SearchViewController {
    fileprivate func setIPFieldConstraints() {
        NSLayoutConstraint.activate([
            ipField.topAnchor.constraint(
                equalTo: view.topAnchor,
                constant: dwgConst.ipFieldTop
            ),
            ipField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
