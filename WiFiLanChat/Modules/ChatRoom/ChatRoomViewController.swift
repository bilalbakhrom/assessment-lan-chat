//
//  ChatRoomViewController.swift
//  WiFiLanChat
//
//  Created by Bilol Mamadjanov on 26/11/21.
//

import UIKit
import Network

class ChatRoomViewController: BaseViewController {
    private let connection: PeerConnection
    private let username = ""
    private(set) var messages: [Message] = []
    private(set) var dwgConst = DrawingConstants()
    private let uiConst = UIConstants()
    
    private(set) lazy var tableView: UITableView = {
        let view = UITableView()
        view.dataSource = self
        view.delegate = self
        view.separatorStyle = .none
        view.backgroundColor = .clear
        
        return view
    }()
    
    private(set) lazy var messageInputBar: MessageInputView = {
        let view = MessageInputView()
        view.delegate = self
        
        return view
    }()
    
    private(set) lazy var closeButton: UIBarButtonItem = {
        UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(closeButtonClicked))
    }()
    
    // MARK: - Initializers
    init(connection: PeerConnection) {
        self.connection = connection
        super.init(nibName: nil, bundle: nil)
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
    
    // MARK: - Actions
    @objc func keyboardWillChange(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)!.cgRectValue
            let messageBarHeight = messageInputBar.bounds.size.height
            let point = CGPoint(x: messageInputBar.center.x, y: endFrame.origin.y - messageBarHeight/2.0)
            let inset = UIEdgeInsets(top: 0, left: 0, bottom: endFrame.size.height, right: 0)
            UIView.animate(withDuration: 0.25) {
                self.messageInputBar.center = point
                self.tableView.contentInset = inset
            }
        }
    }
    
    @objc func closeButtonClicked() {
        connection.cancel()
        dismiss(animated: true, completion: nil)
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
        
        title = uiConst.title
        navigationItem.leftBarButtonItem = closeButton
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        connection.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let messageBarHeight:CGFloat = 60.0
        let size = view.bounds.size
        tableView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height - messageBarHeight - view.safeAreaInsets.bottom)
        messageInputBar.frame = CGRect(x: 0, y: size.height - messageBarHeight - view.safeAreaInsets.bottom, width: size.width, height: messageBarHeight)
    }
}

extension ChatRoomViewController: PeerConnectionDelegate {
    func connectionReady() {
        
    }
    
    func connectionFailed() {
        
    }
    
    func receivedMessage(content: Data?, message: NWProtocolFramer.Message) {
        guard let content = content else { return }
        guard let text = String(data: content, encoding: .utf8) else { return }
        let message = Message(message: text, messageSender: .someoneElse, username: username)
        insertNewMessageCell(message)
    }
}

// MARK: - Message Input Bar
extension ChatRoomViewController: MessageInputDelegate {
    func sendWasTapped(message: String) {
        connection.send(message)
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
        let title = "Chat"
    }
}
