//
//  ChatRoomViewController.swift
//  WiFiLanChat
//
//  Created by Bilol Mamadjanov on 26/11/21.
//

import UIKit
import Network

class ChatRoomViewController: BaseViewController {
    private(set) var messages: [Message] = []
    private(set) var dwgConst = DrawingConstants()
    private let uiConst = UIConstants()
    private var username: String = ""
    private var listener: PeerListener?
    private var connection: PeerConnection?
    
    private(set) lazy var tableView: UITableView = {
        let view = UITableView()
        view.dataSource = self
        view.delegate = self
        view.separatorStyle = .none
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private(set) lazy var messageInputBar: MessageInputView = {
        let view = MessageInputView()
        view.delegate = self
        
        return view
    }()
    
    private(set) lazy var closeButton: UIBarButtonItem = {
        let image = UIImage(systemName: "xmark")
        return UIBarButtonItem(image: image,
                               style: .done,
                               target: self,
                               action: #selector(closeButtonClicked))
    }()
    
    private(set) lazy var shareButton: UIBarButtonItem = {
        let image = UIImage(systemName: "square.and.arrow.up")
        return UIBarButtonItem(image: image,
                               style: .done,
                               target: self,
                               action: #selector(shareButtonClicked))
    }()
    
    private(set) lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 15, weight: .medium)
        view.textColor = .primaryTextColor
        view.text = uiConst.navTitle
        view.textAlignment = .center
        
        return view
    }()
    
    private(set) lazy var subtitleLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 12, weight: .medium)
        view.textColor = .gray
        view.text = NetFlowInspector.shared.host
        view.textAlignment = .center
        
        return view
    }()
    
    private(set) lazy var navigationItemStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        view.axis = .vertical
        view.spacing = 2.0
        
        return view
    }()
    
    // MARK: - Initializers
    init(connection: PeerConnection) {
        super.init(nibName: nil, bundle: nil)
        self.connection = connection
        self.connection?.delegate = self
    }
    
    init(host: String) {
        super.init(nibName: nil, bundle: nil)
        self.listener = PeerListener(name: host, passcode: "0", delegate: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }
    
    func insertReceiverCell(_ content: Data) {
        guard let text = String(data: content, encoding: .utf8) else {
            return
        }
        
        let message = Message(
            message: text,
            messageSender: .someoneElse,
            username: username
        )
        insertNewMessageCell(message)
    }
    
    func closeSessions() {
        connection?.cancel()
        connection = nil
        
        listener?.cancel()
        listener = nil
    }
    
    // MARK: - Actions
    @objc func keyboardWillChange(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)!.cgRectValue
        let messageBarHeight = messageInputBar.bounds.size.height
        let point = CGPoint(x: messageInputBar.center.x, y: endFrame.origin.y - messageBarHeight/2.0)
        let inset = UIEdgeInsets(top: 0, left: 0, bottom: endFrame.size.height, right: 0)
        UIView.animate(withDuration: 0.15) {
            self.messageInputBar.center = point
            self.tableView.contentInset = inset
        }
    }
    
    @objc func closeButtonClicked() {
        closeSessions()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func shareButtonClicked() {
        guard NetFlowInspector.shared.isReachable else { return }
        guard let host = NetFlowInspector.shared.host else { return }
        let text = "Hey, I created a room to chat. Come join here:\n\(host)"
        let shareVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        shareVC.popoverPresentationController?.sourceView = view
        present(shareVC, animated: true, completion: nil)
    }
}

// MARK: - Lifecycle
extension ChatRoomViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillChange(notification:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
        
        navigationItem.titleView = navigationItemStackView
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItem = shareButton
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let messageBarHeight: CGFloat = 60.0
        let size = view.bounds.size
        messageInputBar.frame = CGRect(x: 0,
                                       y: size.height - messageBarHeight - view.safeAreaInsets.bottom,
                                       width: size.width,
                                       height: messageBarHeight)
    }
}

extension ChatRoomViewController: PeerConnectionDelegate {
    func connectionReady() {
        
    }
    
    func connectionFailed() {
        
    }
    
    func connectionPreparing() {
        
    }
    
    func connectionCanceled() {
        
    }
    
    func receivedMessage(content: Data?, message: NWProtocolFramer.Message) {
        guard let content = content else { return }
        
        switch message.type {
        case .message:
            insertReceiverCell(content)
            
        default:
            break
        }
    }
}

extension ChatRoomViewController: PeerListenerDelegate {
    func displayAdvertiseError(_ error: NWError) {
        print(error)
    }
    
    func receivedConnection(_ newConnection: NWConnection) {
        if connection == nil {
            // Accept a new connection.
            connection = PeerConnection(connection: newConnection, delegate: self)
        } else {
            // If a chat is already in progress, reject it.
            newConnection.cancel()
        }
    }
}

// MARK: - Message Input Bar
extension ChatRoomViewController: MessageInputDelegate {
    func sendWasTapped(message: String) {
        connection?.send(message)
        let message = Message(message: message, messageSender: .ourself, username: username)
        insertNewMessageCell(message)
    }
}

// MARK: - Table DataSource and Delegate
extension ChatRoomViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MessageTableViewCell(style: .default, reuseIdentifier: "MessageCell")
        cell.selectionStyle = .none
        
        let message = messages[indexPath.row]
        cell.apply(message: message)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        MessageTableViewCell.height(for: messages[indexPath.row])
    }
    
    func insertNewMessageCell(_ message: Message) {
        messages.append(message)
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .bottom)
        tableView.endUpdates()
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}

extension ChatRoomViewController {
    private struct UIConstants {
        let navTitle = "Chat"
    }
}
