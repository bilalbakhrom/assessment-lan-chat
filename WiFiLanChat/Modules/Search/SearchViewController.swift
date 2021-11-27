//
//  SearchViewController.swift
//  WiFiLanChat
//
//  Created by Bilol Mamadjanov on 26/11/21.
//

import UIKit

class SearchViewController: BaseViewController {
    private(set) var dwgConst = DrawingConstants()
    private let uiConst = UIConstants()
    private var receiverHost: String = ""
    
    // MARK: - UI Properties
    private(set) lazy var ipField: IPField = {
        let view = IPField()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private(set) lazy var connectButton: UIButton = {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .semibold),
            .foregroundColor: UIColor.linkedTextColor
        ]
        let title = NSAttributedString(
            string: uiConst.connectButtonTitle,
            attributes: attributes
        )
        let view = UIButton()
        view.backgroundColor = .clear
        view.setAttributedTitle(title, for: .normal)
        view.setTitleColor(UIColor.linkedTextColor.withAlphaComponent(0.5), for: .disabled)
        view.addTarget(self, action: #selector(connectButtonClicked), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    // MARK: - Actions
    @objc func connectButtonClicked() {
        guard receiverHost.filter({ $0 == "." }).count == 3 else { return }
    }
}

// MARK: - Lifecycle
extension SearchViewController {
    override func viewDidLoad() {
        super.viewDidLoad()                
        
        title = uiConst.title
        setup()
        hideKeyboardWhenTappedOnView()
    }
}

extension SearchViewController: IPFieldDelegate {
    func didChangeHost(_ host: String) {
        receiverHost = host
    }
    
    func didPasteHost(_ host: String) {
        receiverHost = host
    }
}

extension SearchViewController {
    private struct UIConstants {
        let title = "Search"
        let connectButtonTitle = "Connect"
    }
}
