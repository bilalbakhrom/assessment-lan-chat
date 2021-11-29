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
    
    private(set) lazy var createRoomButton: Button = {
        let view = Button()
        view.set(title: uiConst.createText.uppercased(),
                 color: .white)
        view.addTarget(self, action: #selector(createRoomButtonClicked), for: .touchUpInside)
        view.backgroundColor = .systemGreen
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private(set) lazy var searchRoomButton: Button = {
        let view = Button()
        view.set(title: uiConst.searchText.uppercased(),
                 color: .black)
        view.addTarget(self, action: #selector(searchRoom), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private(set) lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillEqually
        view.alignment = .fill
        view.spacing = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private(set) lazy var ipLabel: UILabel = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(copyInClipboard))
        let view = UILabel()
        view.text = uiConst.ipLabelPlaceholder
        view.textColor = .linkedTextColor
        view.font = .systemFont(ofSize: 17, weight: .medium)
        view.textAlignment = .center
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private(set) lazy var boxView: BoxView = {
        let boxView = BoxView(frame: .init(origin: .zero, size: .init(width: 200, height: 40)))
        boxView.setTitle(uiConst.copiedToClipboardText)
        boxView.sizeToFit()
        boxView.alpha = 0
        boxView.translatesAutoresizingMaskIntoConstraints = false
        
        return boxView
    }()
    
    private(set) lazy var fadeInOutAnimator: FadeInOutAnimator = {
        FadeInOutAnimator(view: boxView)
    }()

    // MARK: - Actions
    @objc func createRoomButtonClicked() {
        guard let host = NetFlowInspector.shared.host else {
            return
        }
        
        createChatRoom(using: host)
    }
    
    @objc func searchRoom() {
        openSearchViewController()
    }
    
    @objc func copyInClipboard() {
        guard NetFlowInspector.shared.isReachable else { return }
        UIPasteboard.general.string = NetFlowInspector.shared.host
        fadeInOutAnimator.animateView()
    }
    
    func inspectWifiConnection() {
        NetFlowInspector.shared.addObserver(forKeyPath: String(describing: self)) { [weak self] status in
            status == .connected ? self?.didEstablishWifiConnection() : self?.didLostWifiConnection()
        }
    }
    
    func didLostWifiConnection() {
        wifiLogo.image = UIImage(named: "wifi-slash-logo")
        ipLabel.textColor = .warningColor
        ipLabel.text = uiConst.ipLabelWarningText
        searchRoomButton.isEnabled = false
        createRoomButton.isEnabled = false
    }
    
    func didEstablishWifiConnection() {
        wifiLogo.image = UIImage(named: "wifi-logo")
        ipLabel.textColor = .linkedTextColor
        ipLabel.text = "IP: \(NetFlowInspector.shared.host ?? "0.0.0.0")"
        searchRoomButton.isEnabled = true
        createRoomButton.isEnabled = true
    }
    
    // MARK: - Navigation
    
    func createChatRoom(using host: String) {
        let chatRoomVC = ChatRoomViewController(host: host)
        let navController: BaseNavigationController = Launcher.makeNavController(rootViewController: chatRoomVC)
        navController.modalPresentationStyle = .fullScreen
        navController.modalTransitionStyle = .flipHorizontal
        
        present(navController, animated: true, completion: nil)
    }
    
    func openSearchViewController() {
        let searchVC = SearchViewController()        
        navigationController?.pushViewController(searchVC, animated: true)
    }
}

// MARK: - Lifecycle
extension StartViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = uiConst.title
        setup()
        inspectWifiConnection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        P2PManager.cancel()
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
        let searchText = "Search Room"
        let createText = "Create Room"
        let ipLabelPlaceholder = "Initialize..."
        let ipLabelWarningText = "No connection is available"
        let copiedToClipboardText = "Host copied to clipboard"
    }
}
