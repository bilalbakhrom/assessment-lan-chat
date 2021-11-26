//
//  StartViewController.swift
//  WiFiLanChat
//
//  Created by Bilol Mamadjanov on 26/11/21.
//

import UIKit

class StartViewController: BaseViewController {
    
    private(set) lazy var searchButton: UIButton = {
        let view = UIButton()
        view.addTarget(self, action: #selector(searchButtonClicked), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    // MARK: - Actions
    @objc private func searchButtonClicked() {
        
    }
}

// MARK: - Lifecycle
extension StartViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

