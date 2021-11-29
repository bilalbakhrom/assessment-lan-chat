//
//  NWMessageReceiverDelegate.swift
//  WiFiLanChat
//
//  Created by Bilol Mamadjanov on 29/11/21.
//

import Foundation
import Network

protocol NWMessageReceiverDelegate: AnyObject {
    func receivedMessage(content: Data?, message: NWProtocolFramer.Message)
}
