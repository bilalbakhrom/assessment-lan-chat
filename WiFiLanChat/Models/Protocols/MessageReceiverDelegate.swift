//
//  MessageReceiverDelegate.swift
//  WiFiLanChat
//
//  Created by Bilol Mamadjanov on 29/11/21.
//

import Foundation
import Network

protocol MessageReceiverDelegate: AnyObject {
    func receivedMessage(content: Data?, message: NWProtocolFramer.Message)
}
