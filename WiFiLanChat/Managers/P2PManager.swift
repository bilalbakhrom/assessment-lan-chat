//
//  P2PManager.swift
//  WiFiLanChat
//
//  Created by Bilol Mamadjanov on 28/11/21.
//

import Network

class P2PManager {
    static var sharedBrowser: PeerBrowser?
    static var sharedConnection: PeerConnection?
    
    static func cancel() {
        sharedBrowser?.browser?.cancel()
        sharedConnection?.cancel()
        
        sharedBrowser = nil
        sharedConnection = nil
    }
}
