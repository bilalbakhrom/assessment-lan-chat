//
//  Message.swift
//  WiFiLanChat
//
//  Created by Bilol Mamadjanov on 27/11/21.
//

import Foundation

struct Message {
    let text: String
    let username: String
    let owner: MessageOwner
    let messageType: MessageType
    
    init(text: String, owner: MessageOwner, username: String, messageType: MessageType) {
        self.text = text.withoutWhitespace()
        self.owner = owner
        self.username = username
        self.messageType = messageType
    }
}
