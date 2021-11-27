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
        let connectButtonTop: CGFloat = 28
    }
}

extension SearchViewController {
    override func embedSubviews() {
        view.addSubview(ipField)
        view.addSubview(connectButton)
    }
    
    override func setSubviewsConstraints() {
        setIPFieldConstraints()
        setConnectButtonConstraints()
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
    
    fileprivate func setConnectButtonConstraints() {
        NSLayoutConstraint.activate([
            connectButton.topAnchor.constraint(
                equalTo: ipField.bottomAnchor,
                constant: dwgConst.connectButtonTop
            ),
            connectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
