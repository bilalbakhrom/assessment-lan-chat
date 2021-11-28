//
//  Message.swift
//  WiFiLanChat
//
//  Created by Bilol Mamadjanov on 27/11/21.
//

import Foundation

struct Message {
    let message: String
    let senderUsername: String
    let messageSender: MessageSender
    
    init(message: String, messageSender: MessageSender, username: String) {
        self.message = message.withoutWhitespace()
        self.messageSender = messageSender
        self.senderUsername = username
    }
}
