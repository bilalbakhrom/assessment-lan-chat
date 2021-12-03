//
//  MessageType.swift
//  WiFiLanChat
//
//  Created by Bilol Mamadjanov on 29/11/21.
//

enum MessageType: UInt32 {
    case invalid = 0
    case message = 1
    case createChatRoom = 2
    case join = 3
    case cancel = 4
}
