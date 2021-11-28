//
//  StartViewController+Layout.swift
//  WiFiLanChat
//
//  Created by Bilol Mamadjanov on 26/11/21.
//

import UIKit

extension StartViewController {
    struct DrawingConstants {
        let hPadding: CGFloat = 12
        let wifiLogoTop: CGFloat = 100
        let wifiLogoSize = CGSize(width: 185, height: 167)
        let ipLabelTop: CGFloat = 24
        let buttonHeight: CGFloat = 44
        let buttonCornerRadius: CGFloat = 8
        let stackSpacing: CGFloat = 20
        let stackViewBottom: CGFloat = 40
    }
}

extension StartViewController {
    override func embedSubviews() {
        view.addSubview(wifiLogo)
        view.addSubview(ipLabel)
        view.addSubview(stackView)
        stackView.addArrangedSubview(createRoomButton)
        stackView.addArrangedSubview(searchRoomButton)
    }
    
    override func setSubviewsConstraints() {
        setLogoConstraints()
        setIPLabelConstraints()
        setStackViewConstraints()
        setSearchRoomButtonConstraints()
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
    
    fileprivate func setStackViewConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: dwgConst.hPadding
            ),
            stackView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -dwgConst.hPadding
            ),
            stackView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor,
                constant: -dwgConst.stackViewBottom
            ),
        ])
    }
    
    fileprivate func setSearchRoomButtonConstraints() {
        searchRoomButton.heightAnchor.constraint(equalToConstant: dwgConst.buttonHeight).isActive = true
    }
}
