//
//  MessageTableViewCell+Layout.swift
//  WiFiLanChat
//
//  Created by Bilol Mamadjanov on 02/12/21.
//

import UIKit

extension MessageTableViewCell {
    func setupSubviews() {
        embedSubviews()
        setSubviewsConstraints()
    }
    
    private func embedSubviews() {
        addSubview(messageLabel)
        addSubview(nameLabel)
    }
    
    private func setSubviewsConstraints() {}
    
    // MARK: - Methods to calculate cell height
    class func height(for message: Message) -> CGFloat {
        let maxSize = CGSize(width: 2*(UIScreen.main.bounds.size.width/3), height: CGFloat.greatestFiniteMagnitude)
        let nameHeight = message.owner == .sender ? 0 : (height(forText: message.username, fontSize: 10, maxSize: maxSize) + 4 )
        let messageHeight = height(forText: message.text, fontSize: 17, maxSize: maxSize)
        
        return nameHeight + messageHeight + 24
    }
    
    private class func height(forText text: String, fontSize: CGFloat, maxSize: CGSize) -> CGFloat {
        let font = UIFont(name: "Helvetica", size: fontSize)!
        let attrString = NSAttributedString(string: text, attributes:[NSAttributedString.Key.font: font,
                                                                      NSAttributedString.Key.foregroundColor: UIColor.white])
        let textHeight = attrString.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil).size.height
        
        return textHeight
    }
}
