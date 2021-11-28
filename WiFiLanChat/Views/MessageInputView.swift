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
    private let uiConst = UIConstants()
    
    // MARK: - UI Properties
    private(set) lazy var textView: UITextView = {
        let view = UITextView()
        view.layer.cornerRadius = 4
        view.layer.borderColor = UIColor(red: 200 / 255, green: 200 / 255, blue: 200 / 255, alpha: 0.6).cgColor
        view.layer.borderWidth = 1
        view.font = .systemFont(ofSize: 16)
        
        return view
    }()
    
    private(set) lazy var sendButton: Button = {
        let view = Button()
        view.backgroundColor = .systemGreen
        view.layer.cornerRadius = 8
        view.set(title: "Send", color: .white)
        view.isEnabled = true
        view.addTarget(self, action: #selector(send), for: .touchUpInside)
        
        return view
    }()
    
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = uiConst.gradientColors
        layer.locations = uiConst.gradientLocations
        layer.startPoint = uiConst.gradientStartPoint
        layer.endPoint = uiConst.gradientEndPoint
        
        return layer
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
                
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
        gradientLayer.frame = bounds
        
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
        backgroundColor = UIColor(red: 247 / 255, green: 247 / 255, blue: 247 / 255, alpha: 1.0)
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.systemGray4.cgColor
        embedSubviews()
    }
    
    private func embedSubviews() {
        addSubview(textView)
        addSubview(sendButton)
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension MessageInputView {
    private struct UIConstants {
        let gradientColors: [CGColor] = [
            UIColor(red: 0.882, green: 0.902, blue: 0.941, alpha: 1).cgColor,
            UIColor(red: 0.69, green: 0.729, blue: 0.82, alpha: 1).cgColor
        ]
        let gradientLocations: [NSNumber] = [0, 1]
        let gradientStartPoint = CGPoint(x: 0.25, y: 0.5)
        let gradientEndPoint = CGPoint(x: 0.75, y: 0.5)
    }
}
