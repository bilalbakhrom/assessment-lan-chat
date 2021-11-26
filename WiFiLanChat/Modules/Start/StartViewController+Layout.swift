//
//  StartViewController+Layout.swift
//  WiFiLanChat
//
//  Created by Bilol Mamadjanov on 26/11/21.
//

import UIKit

extension StartViewController {
    struct DrawingConstants {
        let hPadding: CGFloat = 20
        let wifiLogoTop: CGFloat = 100
        let wifiLogoSize = CGSize(width: 185, height: 167)
        let ipLabelTop: CGFloat = 24
        let searchButtonHeight: CGFloat = 48
        let searchButtonBottom: CGFloat = 40
        let searchButtonCornerRadius: CGFloat = 8
    }
}

extension StartViewController {
    override func embedSubviews() {
        view.addSubview(wifiLogo)
        view.addSubview(ipLabel)
        view.addSubview(searchButton)
    }
    
    override func setSubviewsConstraints() {
        setLogoConstraints()
        setIPLabelConstraints()
        setSearchButtonConstraints()
    }
}

extension StartViewController {
    fileprivate func setLogoConstraints() {
        NSLayoutConstraint.activate([
            wifiLogo.topAnchor.constraint(
                equalTo: view.topAnchor,
                constant: dwgConst.wifiLogoTop
            ),
            wifiLogo.widthAnchor.constraint(equalToConstant: dwgConst.wifiLogoSize.width),
            wifiLogo.heightAnchor.constraint(equalToConstant: dwgConst.wifiLogoSize.height),
            wifiLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    fileprivate func setIPLabelConstraints() {
        NSLayoutConstraint.activate([
            ipLabel.topAnchor.constraint(
                equalTo: wifiLogo.bottomAnchor,
                constant: dwgConst.ipLabelTop
            ),
            ipLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    fileprivate func setSearchButtonConstraints() {
        NSLayoutConstraint.activate([
            searchButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: dwgConst.hPadding
            ),
            searchButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -dwgConst.hPadding
            ),
            searchButton.bottomAnchor.constraint(
                equalTo: view.bottomAnchor,
                constant: -dwgConst.searchButtonBottom
            ),
            searchButton.heightAnchor.constraint(equalToConstant: dwgConst.searchButtonHeight),
        ])
    }
}
