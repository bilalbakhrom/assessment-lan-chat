//
//  StartViewController.swift
//  WiFiLanChat
//
//  Created by Bilol Mamadjanov on 26/11/21.
//

import UIKit

class StartViewController: BaseViewController {
    private(set) var dwgConst = DrawingConstants()
    private let uiConst = UIConstants()
    
    // MARK: - UI Properties
    private(set) lazy var wifiLogo: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "wifi-logo")
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private(set) lazy var searchButton: Button = {
        let view = Button()
        view.set(title: uiConst.searchText, color: .black)        
        view.addTarget(self, action: #selector(searchButtonClicked), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private(set) lazy var ipLabel: UILabel = {
        let view = UILabel()
        view.text = uiConst.ipLabelPlaceholder
        view.textColor = .linkedTextColor
        view.font = .systemFont(ofSize: 17, weight: .medium)
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didSelectIPLabel))
        view.addGestureRecognizer(tapGesture)
        
        return view
    }()

    // MARK: - Actions
    @objc private func searchButtonClicked() {
        
    }
    
    @objc private func didSelectIPLabel() {
        // TODO: - Copy IP address
    }
}

// MARK: - Lifecycle
extension StartViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

extension StartViewController {
    private struct UIConstants {
        let searchText = "Search"
        let ipLabelPlaceholder = "0.0.0.0"
    }
}
