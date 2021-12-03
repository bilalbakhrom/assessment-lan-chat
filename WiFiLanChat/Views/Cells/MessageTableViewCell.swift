//
//  MessageTableViewCell.swift
//  WiFiLanChat
//
//  Created by Bilol Mamadjanov on 27/11/21.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    private var messageOwner: MessageOwner = .sender
    
    // MARK: - UI Properties
    private(set) lazy var messageLabel: Label = {
        let view = Label()
        view.clipsToBounds = true
        view.textColor = .white
        view.numberOfLines = 0
        view.layer.cornerRadius = 8
        
        return view
    }()
    private(set) lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.textColor = .lightGray
        view.font = .systemFont(ofSize: 10)
        
        return view
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        backgroundColor = .clear
        selectionStyle = .none
        clipsToBounds = true
    }
    
    func apply(message: Message) {
        nameLabel.text = message.username
        messageLabel.text = message.text
        messageOwner = message.owner
        setNeedsLayout()
    }
}

extension MessageTableViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        switch messageOwner {
        case .sender:
            updateMessageLabelForSenderReceiver()
            nameLabel.isHidden = true
            messageLabel.center = CGPoint(x: bounds.size.width - messageLabel.bounds.size.width/2.0 - 16,
                                          y: bounds.size.height/2.0)
            messageLabel.backgroundColor = UIColor(red: 24 / 255, green: 180 / 255, blue: 128 / 255, alpha: 1.0)
            
        case .receiver:
            updateMessageLabelForSenderReceiver()
            nameLabel.isHidden = false
            nameLabel.sizeToFit()
            nameLabel.center = CGPoint(x: nameLabel.bounds.size.width / 2.0 + 16 + 4,
                                       y: nameLabel.bounds.size.height/2.0 + 4)
            
            messageLabel.center = CGPoint(x: messageLabel.bounds.size.width / 2.0 + 16,
                                          y: messageLabel.bounds.size.height/2.0 + nameLabel.bounds.size.height + 8)
            messageLabel.backgroundColor = .lightGray
            
        case .server:
            layoutServerMessage()
        }
    }
    
    private func updateMessageLabelForSenderReceiver() {
        messageLabel.font = UIFont(name: "Helvetica", size: 17)
        messageLabel.textColor = .white
        
        let size = messageLabel.sizeThatFits(CGSize(width: 2 * (bounds.size.width / 3),
                                                    height: .greatestFiniteMagnitude))
        messageLabel.frame = CGRect(x: 0, y: 0, width: size.width + 32, height: size.height + 16)
    }
    
    func layoutServerMessage() {
        messageLabel.font = UIFont.systemFont(ofSize: 10)
        messageLabel.textColor = .systemTeal
        
        let size = messageLabel.sizeThatFits(CGSize(width: 2 * (bounds.size.width / 3), height: .greatestFiniteMagnitude))
        messageLabel.frame = CGRect(x: 0, y: 0, width: size.width + 32, height: size.height + 16)
        messageLabel.center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2.0)
    }
}

