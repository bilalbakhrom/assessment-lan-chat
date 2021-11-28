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
    private var results: [NWBrowser.Result] = [NWBrowser.Result]()
    private var state: ConnectionEstablishmentState = .none {
        didSet {
            connectButton.isEnabled = state.canEstablishConnection
            updateConnectButtonTitle()
        }
    }
    
    // MARK: - UI Properties
    private(set) lazy var ipField: IPField = {
        let view = IPField()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private(set) lazy var connectButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .clear
        view.setTitleColor(UIColor.linkedTextColor.withAlphaComponent(0.5), for: .disabled)
        view.addTarget(self, action: #selector(connectButtonClicked), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    // MARK: - Actions
    @objc func connectButtonClicked() {
        guard receiverHost.filter({ $0 == "." }).count == 3 else {
            return
        }
                
        state = .creatingRequest
        createPeerConnection()
    }
    
    func updateConnectButtonTitle() {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .semibold),
            .foregroundColor: UIColor.linkedTextColor
        ]
        let title = NSAttributedString(
            string: state.title,
            attributes: attributes
        )
        
        connectButton.setAttributedTitle(title, for: .normal)
    }
    
    func createPeerConnection() {
        guard let browserResult = results.find(host: receiverHost) else {
            return
        }
        // Create a connection
        P2PManager.sharedConnection = PeerConnection(
            endpoint: browserResult.endpoint,
            interface: browserResult.interfaces.first,
            passcode: "0",
            delegate: self
        )
    }
    
    func prepareToOpenChatRoom() {
        guard let connection = P2PManager.sharedConnection else {
            return
        }
        
        state = .connected
        openChatRoomViewController(using: connection)
    }
    
    func openChatRoomViewController(using connection: PeerConnection) {
        let chatRoomVC = ChatRoomViewController()
        let navController: BaseNavigationController = Launcher.makeNavController(rootViewController: chatRoomVC)
        navController.modalPresentationStyle = .fullScreen
        navController.modalTransitionStyle = .flipHorizontal
        connection.delegate = chatRoomVC
        
        present(navController, animated: true, completion: nil)
    }
}

// MARK: - Lifecycle
extension SearchViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = uiConst.title
        state = .none
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

extension SearchViewController: PeerBrowserDelegate {
    // When the discovered peers change, update the list.
    func refreshResults(results: Set<NWBrowser.Result>) {
        guard let host = NetFlowInspector.shared.host else { return }
        self.results = [NWBrowser.Result]()
        for result in results {
            if case let NWEndpoint.service(name: name, type: _, domain: _, interface: _) = result.endpoint {
                if name != host {
                    self.results.append(result)
                }
            }
        }
    }
    
    // Show an error if peer discovery failed.
    func displayBrowseError(_ error: NWError) {
        var message = "Error \(error)"
        if error == NWError.dns(DNSServiceErrorType(kDNSServiceErr_NoAuth)) {
            message = "Not allowed to access the network"
        }
        showAlert(title: "Cannot discover other players", message: message)
        state = .none
    }
}

extension SearchViewController: PeerConnectionDelegate {
    func connectionReady() {
        // Create request
        let request = JoinRequest(host: receiverHost, username: "Some")
        // Send request
        P2PManager.sharedConnection?.sendRequest(request)
        // Update state
        state = .waiting
    }
    
    func connectionFailed() {
        showAlert(
            title: "Request Error",
            message: "Could not connect to host:\n\(receiverHost)\nPlease, try again"
        )
        // Update state
        state = .none
        P2PManager.sharedConnection = nil
    }
    
    func displayAdvertiseError(_ error: NWError) {}
    
    func receivedMessage(content: Data?, message: NWProtocolFramer.Message) {
        switch message.type {
        case .acceptRequest:
            prepareToOpenChatRoom()
            
        case .declineRequest:
            showAlert(
                title: "Request Declined",
                message: "The host owner at \(receiverHost) declined your request"
            )
            
        default:
            break
        }
    }
}

extension SearchViewController {
    private struct UIConstants {
        let title = "Search"
        let connectButtonTitle = "Connect"
    }
}
