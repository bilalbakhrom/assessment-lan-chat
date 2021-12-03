//
//  ChatRoomViewController.swift
//  WiFiLanChat
//
//  Created by Bilol Mamadjanov on 26/11/21.
//

import UIKit
import Network
import Combine

class ChatRoomViewController: BaseViewController {
    private(set) var dwgConst = DrawingConstants()
    private(set) var uiConst = UIConstants()
    private(set) var senderName: String = "Sender"
    private(set) var receiverName: String = "Receiver"
    private var listener: PeerListener?
    private var connection: PeerConnection?
    /// All chat messages will be saved in this variable
    private(set) var messages: [Message] = [] {
        didSet {
            insertNewMessageCell()
        }
    }
    private(set) var subscriptions: Set<AnyCancellable> = []
    
    // MARK: - UI Properties
    private(set) lazy var tableView: UITableView = {
        let view = UITableView()
        view.dataSource = self
        view.delegate = self
        view.separatorStyle = .none
        view.backgroundColor = .clear
        view.register(MessageTableViewCell.self, forCellReuseIdentifier: uiConst.cellIdentifier)
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
        view.text = (listener?.name ?? connection?.name)
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
        
        abort()
    }
    
    /// Handles when user closes chat room.
    func peerCanceledConnection() {
        // Room is closed by host owner.
        if listener == nil {
            showAlert(title: "Host closed",
                      message: "This host is closed by host owner",
                      handler: { _ in self.closeChatRoom() })
        }
        // When room is closed by member.
        else {
            connection?.cancel()
            connection = nil
        }
    }
    
    /// Cancels connection and listener
    func abort() {
        /// Abort connection
        connection?.cancel()
        connection = nil
        /// Abort listener
        listener?.cancel()
        listener = nil
    }
    
    func closeChatRoom(afterDeadline time: DispatchTime = .now() + 0.5) {
        DispatchQueue.main.asyncAfter(deadline: time) { [self] in
            dismiss(animated: true, completion: nil)
        }
    }
    
    func received(textMessage: String) {
        let message = Message(text: textMessage,
                              username: receiverName,
                              owner: .receiver)
        messages.append(message)
    }
    
    func sent(textMessage: String) {
        let message = Message(text: textMessage,
                              username: senderName,
                              owner: .sender)
        messages.append(message)
    }
    
    func ownerClosedChatRoom() {
        let title = "Do you want to close chat?"
        let message = "This will close chat in two sides"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Close", style: .destructive) { _ in
            self.connection?.sendFrame(.cancel)
            self.closeChatRoom()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(closeAction)
        alert.addAction(cancelAction)
                                        
        present(alert, animated: true, completion: nil)
    }
    
    func memberClosedChatRoom() {
        let title = "Do you want to exit from chat?"
        let message = "You cannot join again unless it is free"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Exit", style: .destructive) { _ in
            self.connection?.sendFrame(.cancel)
            self.closeChatRoom()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(closeAction)
        alert.addAction(cancelAction)
                                        
        present(alert, animated: true, completion: nil)
    }        
    
    func setup() {
        setupSubviews()
        setObserverForKeyboardChange()
        setNavigationItem()
    }
    
    private func addServerMessage(_ text: String) {
        let message = Message(text: text)
        messages.append(message)
    }
    
    private func setNavigationItem() {
        navigationItem.titleView = navigationItemStackView
        navigationItem.leftBarButtonItem = closeButton
        // Only listener can share host
        if listener != nil {
            navigationItem.rightBarButtonItem = shareButton
        }
    }
    
    private func setObserverForKeyboardChange() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillChange(notification:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
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
        if listener == nil {
            memberClosedChatRoom()
        } else {
            // If no connection here, it's safe to close chat.
            connection == nil ? closeChatRoom() : ownerClosedChatRoom()
        }
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard listener != nil else {
            return
        }
        
        addServerMessage("The host \"\((listener?.name)!)\" is created")
    }
}

// MARK: - Message Input Bar
extension ChatRoomViewController: MessageInputDelegate {
    func sendButtonClicked(message: String) {
        guard !message.isEmpty else {
            return
        }
        
        connection?.send(message)
        sent(textMessage: message)
    }
}

// MARK: - PeerConnectionDelegate
extension ChatRoomViewController: PeerConnectionDelegate {
    func connectionReady() {
        print("Ready")
    }
    
    func connectionFailed() {
        print("Failed")
    }
    
    func connectionPreparing() {
        print("Preparing")
    }
    
    func connectionCanceled() {
        print("Canceled")
    }
    
    func received(content: Data?, message: NWProtocolFramer.Message) {
        switch message.type {
        case .message:
            guard let text = content?.toString, !text.isEmpty else {
                return
            }
            received(textMessage: text)
            
        case .cancel:
            peerCanceledConnection()
            addServerMessage("\(receiverName) left the host")
            
        case .join:
            addServerMessage("\(receiverName) joined the host")
            
        default:
            break
        }
    }
}

// MARK: - PeerListenerDelegate
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

extension ChatRoomViewController {
    struct UIConstants {
        let navTitle = "Chat"
        let cellIdentifier = "MessageCell"
    }
}
