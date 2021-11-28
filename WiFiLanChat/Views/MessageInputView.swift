//
//  MessageInputView.swift
//  WiFiLanChat
//
//  Created by Bilol Mamadjanov on 27/11/21.
//

import UIKit

protocol MessageInputDelegate: AnyObject {
    func sendWasTapped(message: String)
}

class MessageInputView: UIView {
    weak var delegate: MessageInputDelegate?
    
    // MARK: - UI Properties
    private(set) lazy var textView: UITextView = {
        let view = UITextView()
        view.layer.cornerRadius = 4
        view.layer.borderColor = UIColor(red: 200 / 255, green: 200 / 255, blue: 200 / 255, alpha: 0.6).cgColor
        view.layer.borderWidth = 1
        
        return view
    }()
    
    private(set) lazy var sendButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = UIColor(red: 8 / 255, green: 183 / 255, blue: 231 / 255, alpha: 1.0)
        view.layer.cornerRadius = 4
        view.setTitle("Send", for: .normal)
        view.isEnabled = true
        view.addTarget(self, action: #selector(send), for: .touchUpInside)
        
        return view
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(red: 247 / 255, green: 247 / 255, blue: 247 / 255, alpha: 1.0)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc func send() {
        guard let message = textView.text else { return }
        delegate?.sendWasTapped(message:  message)
        textView.text = ""
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = bounds.size
        textView.bounds = CGRect(x: 0, y: 0, width: size.width - 32 - 8 - 60, height: 40)
        sendButton.bounds = CGRect(x: 0, y: 0, width: 60, height: 44)
        
        textView.center = CGPoint(x: textView.bounds.size.width/2.0 + 16, y: bounds.size.height / 2.0)
        sendButton.center = CGPoint(x: bounds.size.width - 30 - 16, y: bounds.size.height / 2.0)
    }
}

extension MessageInputView: UITextViewDelegate {
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return true
    }
}

extension MessageInputView {
    func setup() {
        embedSubviews()
    }
    
    private func embedSubviews() {
        addSubview(textView)
        addSubview(sendButton)
    }
}
