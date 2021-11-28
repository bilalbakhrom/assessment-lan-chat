//
//  SearchViewController.swift
//  WiFiLanChat
//
//  Created by Bilol Mamadjanov on 26/11/21.
//

import UIKit
import Network

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
    
    func prepareChatRoom() {
        let connection = PeerConnection(host: receiverHost, port: 1020)
        openChatRoomViewController(using: connection)
    }
    
    func openChatRoomViewController(using connection: PeerConnection) {
        let chatRoomVC = ChatRoomViewController(connection: connection)
        let navController: BaseNavigationController = Launcher.makeNavController(rootViewController: chatRoomVC)
        navController.modalPresentationStyle = .fullScreen
        navController.modalTransitionStyle = .flipHorizontal
        
        present(navController, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    @objc func connectButtonClicked() {
        guard receiverHost.filter({ $0 == "." }).count == 3 else { return }
        prepareChatRoom()
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
