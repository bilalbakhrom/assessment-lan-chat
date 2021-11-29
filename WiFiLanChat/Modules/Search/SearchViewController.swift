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
    private var browserResults: [NWBrowser.Result] = [NWBrowser.Result]()
    private var receiverHost: String = ""  {
        didSet {
            connectButton.isEnabled = (state.canEstablishConnection && receiverHost.isIPAddr)
        }
    }
    private var state: ConnectionEstablishmentState = .none {
        didSet {
            connectButton.isEnabled = (state.canEstablishConnection && receiverHost.isIPAddr)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [self] in
                connectButton.set(title: state.title, color: .linkedTextColor)
            }
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
        view.setTitleColor(.linkedTextColor, for: .normal)
        view.setTitleColor(.systemGray3, for: .disabled)
        view.addTarget(self, action: #selector(connectButtonClicked), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    // MARK: - Actions
    @objc func connectButtonClicked() {
        state = .searching
        if receiverHost.isIPAddr {
            startConnection()
        } else {
            state = .none
        }
    }
    
    func fetchServices() {
        if let browser = P2PManager.sharedBrowser {
            browser.startBrowsing()
        } else {
            P2PManager.sharedBrowser = PeerBrowser(delegate: self)
        }
    }
    
    func startConnection() {
        guard let browserResult = browserResults.find(host: receiverHost) else {
            showAlert_noHostFound()
            state = .none
            return
        }
        
        state = .connecting
        P2PManager.sharedConnection = PeerConnection(endpoint: browserResult.endpoint,
                                                     interface: browserResult.interfaces.first,
                                                     passcode: "0",
                                                     delegate: self)
    }
    
    func openChatRoomViewController() {
        let chatRoomVC = ChatRoomViewController()
        let navController: BaseNavigationController = Launcher.makeNavController(rootViewController: chatRoomVC)
        navController.modalPresentationStyle = .fullScreen
        navController.modalTransitionStyle = .flipHorizontal
        P2PManager.sharedConnection?.delegate = chatRoomVC

        present(navController, animated: true, completion: nil)
    }
}

// MARK: - UI Constants
extension SearchViewController {
    private struct UIConstants {
        let title = "Search"
        let connectButtonTitle = "Connect"
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
        fetchServices()
    }
}

// MARK: - IPFieldDelegate
extension SearchViewController: IPFieldDelegate {
    func didChangeHost(_ host: String) {
        receiverHost = host
    }
    
    func didPasteHost(_ host: String) {
        receiverHost = host
    }
}

// MARK: - PeerBrowserDelegate
extension SearchViewController: PeerBrowserDelegate {
    func refreshResults(results: Set<NWBrowser.Result>) {
        guard let host = NetFlowInspector.shared.host else { return }
        browserResults = [NWBrowser.Result]()
        for result in results {
            if case let NWEndpoint.service(name: name, type: _, domain: _, interface: _) = result.endpoint {
                if name != host {
                    browserResults.append(result)
                }
            }
        }
    }
    
    // Show an error if peer discovery failed.
    func displayBrowseError(_ error: NWError) {
        showAlert_browseError(error)
        state = .none
    }
}

// MARK: - PeerConnectionDelegate
extension SearchViewController: PeerConnectionDelegate {
    func receivedMessage(content: Data?, message: NWProtocolFramer.Message) {
        
    }
    
    func displayAdvertiseError(_ error: NWError) {
        
    }
    
    func connectionReady() {
        state = .connected
        openChatRoomViewController()
    }
    
    func connectionFailed() {
        state = .failed
        showAlert_couldNotConnect()
        // Abort connection
        state = .none
        P2PManager.sharedConnection?.cancel()
        P2PManager.sharedConnection = nil
    }
    
    func connectionPreparing() {
        
    }
    
    func connectionCanceled() {
        
    }
}

// MARK: - Error Messages
extension SearchViewController {
    private func showAlert_noHostFound() {
        showAlert(
            title: "No host found",
            message: "We could not find any host with specified IP address: \(receiverHost)"
        )
    }
    
    private func showAlert_couldNotConnect() {
        showAlert(
            title: "Request Error",
            message: "Could not connect to host:\n\(receiverHost)\nPlease, try again"
        )
    }
    
    private func showAlert_browseError(_ error: NWError) {
        var message = "Error \(error)"
        if error == NWError.dns(DNSServiceErrorType(kDNSServiceErr_NoAuth)) {
            message = "Not allowed to access the network"
        }
        showAlert(title: "Cannot discover other players", message: message)
    }
}
