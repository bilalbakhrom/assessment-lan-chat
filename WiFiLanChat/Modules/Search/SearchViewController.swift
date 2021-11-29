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
    private var connection: PeerConnection?
    private var browser: PeerBrowser?
    private var results: [NWBrowser.Result] = [NWBrowser.Result]()
    /// User typed host
    private var receiverHost: String = ""  {
        didSet {
            updateUserInteractionToConnectButton()
        }
    }
    /// Connection state
    private var state: ConnectionEstablishmentState = .none {
        didSet {
            updateUserInteractionToConnectButton()
            updateConnectButtonTitle(state.title)
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
    
    deinit {
        connection?.cancel()
        browser?.cancel()
    }
    
    // MARK: - Actions
    @objc func connectButtonClicked() {
        state = .searching
        if receiverHost.isIPAddr {
            startConnection(toHost: receiverHost)
        } else {
            showAlert_invalidIPAddress()
        }
    }
    
    func fetchServices() {
        if let browser = self.browser {
            browser.startBrowsing()
        } else {
            browser = PeerBrowser(delegate: self)
        }
    }
    
    func startConnection(toHost host: String) {
        guard let browserResult = results.find(host: receiverHost) else {
            showAlert_noHostFound()
            return
        }
        
        connect(to: browserResult)
    }
    
    func connect(to browserResult: NWBrowser.Result) {
        // Update state.
        state = .connecting
        // Create a new connection.
        connection = PeerConnection(endpoint: browserResult.endpoint,
                                    interface: browserResult.interfaces.first,
                                    passcode: "0",
                                    delegate: self)
    }
    
    func joinChatRoom() {
        guard let connection = connection else {
            return
        }
        
        let chatRoomVC = ChatRoomViewController(connection: connection)
        let navController: BaseNavigationController = Launcher.makeNavController(rootViewController: chatRoomVC)
        navController.modalPresentationStyle = .fullScreen
        navController.modalTransitionStyle = .flipHorizontal
        self.connection = nil
        
        present(navController, animated: true, completion: nil)
    }
    
    private func updateUserInteractionToConnectButton() {
        connectButton.isEnabled = (state.canEstablishConnection && receiverHost.isIPAddr)
    }
    
    private func updateConnectButtonTitle(_ title: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.connectButton.set(title: title, color: .linkedTextColor)
        }
    }
}

// MARK: - UI Constants
extension SearchViewController {
    private struct UIConstants {
        let title = "Search"
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
        self.results = [NWBrowser.Result]()
        for result in results {
            if case let NWEndpoint.service(name,_,_,_) = result.endpoint {
                if name != host {
                    self.results.append(result)
                }
            }
        }
    }
    
    // Show an error if peer discovery failed.
    func displayBrowseError(_ error: NWError) {
        showAlert_browseError(error)
    }
}

// MARK: - PeerConnectionDelegate
extension SearchViewController: PeerConnectionDelegate {
    func receivedMessage(content: Data?, message: NWProtocolFramer.Message) { }
    
    func connectionReady() {
        state = .connected
        joinChatRoom()
    }
    
    func connectionFailed() {
        state = .failed
        connection?.cancel()
        connection = nil
        showAlert_couldNotConnect()
    }
    
    func connectionPreparing() {}
    func connectionCanceled() {}
}

// MARK: - Error Messages
extension SearchViewController {
    private func showAlert_invalidIPAddress() {
        showAlert(title: "Invalid IP address",
                  message: "Please enter a valid IP address",
                  handler: { _ in self.state = .none })
    }
    
    private func showAlert_noHostFound() {
        showAlert(title: "No host found",
                  message: "We could not find any host with specified IP address: \(receiverHost)",
                  handler: { _ in self.state = .none })
    }
    
    private func showAlert_couldNotConnect() {
        showAlert(title: "Host is busy",
                  message: "Could not connect to host:\n\(receiverHost)\nPlease, try again",
                  handler: { _ in self.state = .none })
    }
    
    private func showAlert_browseError(_ error: NWError) {
        var message = "Error \(error)"
        if error == NWError.dns(DNSServiceErrorType(kDNSServiceErr_NoAuth)) {
            message = "Not allowed to access the network"
        }
        showAlert(title: "Cannot discover other players",
                  message: message,
                  handler: { _ in self.state = .none })
    }
}
