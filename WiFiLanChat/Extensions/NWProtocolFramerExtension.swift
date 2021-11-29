//
//  NWProtocolFramerExtension.swift
//  WiFiLanChat
//
//  Created by Bilol Mamadjanov on 29/11/21.
//

import Network

// Extend framer messages to handle storing your command types in the message metadata.
extension NWProtocolFramer.Message {
    convenience init(messageType: MessageType) {
        self.init(definition: ChatFramer.definition)
        self["MessageType"] = messageType
    }

    /// A value that indicates to`ChatNWMessageType`
    var type: MessageType {
        if let type = self["MessageType"] as? MessageType {
            return type
        } else {
            return .invalid
        }
    }
}
