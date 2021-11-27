//
//  ChatNetwork.swift
//  WiFiLanChat
//
//  Created by Bilol Mamadjanov on 27/11/21.
//

import Foundation
import Network

protocol ChatNetworkDelegate: AnyObject {
    func didChangeConnectionState(_ state: NWConnection.State)
    func didRecieve(_ message: String)
    func didRecieveError(_ error: NWError)
}

class ChatNetwork {
    private(set) var host: NWEndpoint.Host
    private(set) var port: NWEndpoint.Port
    private var connection: NWConnection?
    private var queue = DispatchQueue(label: "NetworkQueue", qos: .utility)
    weak var delegate: ChatNetworkDelegate?
    
    init?(host: String, port: String) {
        guard !host.isEmpty, let portUDP = NWEndpoint.Port(port) else {
            return nil
        }
        
        self.host = NWEndpoint.Host(host)
        self.port = portUDP
    }
    
    
    func connect() {
        connection = NWConnection(host: host, port: port, using: .udp)
        connection?.stateUpdateHandler = { [weak self] newState in
            self?.stateUpdateHandler(newState)
        }
        connection?.start(queue: queue)
    }
    
    func send(_ content: String) {
        let data = content.data(using: .utf8)
        connection?.send(content: data, completion: .contentProcessed(debugSentMessage))
    }
    
    func receive() {
        connection?.receiveMessage { [weak self] data, context, isComplete, error in
            guard let self = self else { return }
            if let error = error {
                self.delegate?.didRecieveError(error)
            }
            
            if let rcvData = data, let str = String(data:rcvData, encoding: .utf8) {
                self.delegate?.didRecieve(str)
            }
        }
    }
    
    private func stateUpdateHandler(_ newState: NWConnection.State) {
        delegate?.didChangeConnectionState(newState)
        debugConnectionState(newState)
    }
    
    // MARK: - Debug Methods
    private func debugSentMessage(_ error: NWError?) {
        if let err = error {
            print("Sending error \(err)")
        } else {
            print("Sent successfully")
        }
    }
    
    private func debugConnectionState(_ newState: NWConnection.State) {
        switch newState {
        case .ready:
            //The connection is established and ready to send and recieve data.
            print("ready")
            
        case .setup:
            //The connection has been initialized but not started
            print("setup")
            
        case .cancelled:
            //The connection has been cancelled
            print("cancelled")
            
        case .preparing:
            //The connection in the process of being established
            print("Preparing")
            
        default:
            //The connection has disconnected or encountered an error
            print("waiting or failed")
        }
    }
}
