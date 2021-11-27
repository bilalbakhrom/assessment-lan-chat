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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnIPLabel))
        view.addGestureRecognizer(tapGesture)
        
        return view
    }()

    // MARK: - Actions
    @objc private func searchButtonClicked() {
        let searchVC = SearchViewController()
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    @objc private func didTapOnIPLabel() {
        // TODO: - Copy IP address
    }
    
    private func listentWifiConnectionStatus() {
        NetFlowInspector.shared.addObserver(forKeyPath: String(describing: self)) { [weak self] status in
            status == .connected ? self?.didEstablishWifiConnection() : self?.didLostWifiConnection()
        }
    }
    
    private func didLostWifiConnection() {
        wifiLogo.image = UIImage(named: "wifi-slash-logo")
        ipLabel.textColor = .warningColor
        ipLabel.text = uiConst.ipLabelWarningText
        searchButton.isEnabled = false
    }
    
    private func didEstablishWifiConnection() {
        wifiLogo.image = UIImage(named: "wifi-logo")
        ipLabel.textColor = .linkedTextColor
        ipLabel.text = "IP: \(NetFlowInspector.shared.host ?? "0.0.0.0")"
        searchButton.isEnabled = true
    }
}

// MARK: - Lifecycle
extension StartViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = uiConst.title
        setup()
        listentWifiConnectionStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

extension StartViewController {
    private struct UIConstants {
        let title = "Start"
        let searchText = "Search"
        let ipLabelPlaceholder = "Initialize..."
        let ipLabelWarningText = "No connection is available"
    }
}
