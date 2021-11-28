//
//  PeerConnection.swift
//  WiFiLanChat
//
//  Created by Bilol Mamadjanov on 27/11/21.
//

import Foundation
import Network

protocol PeerConnectionDelegate: AnyObject {
    func connectionReady()
    func connectionFailed()
    func receivedMessage(content: Data?, message: NWProtocolFramer.Message)
    func displayAdvertiseError(_ error: NWError)
}

class PeerConnection {
    private var connection: NWConnection?
    weak var delegate: PeerConnectionDelegate?
    let initiatedConnection: Bool
    
    // Create an outbound connection when the user initiates a game.
    init(endpoint: NWEndpoint, interface: NWInterface?, passcode: String, delegate: PeerConnectionDelegate) {
        self.delegate = delegate
        self.initiatedConnection = true

        let connection = NWConnection(to: endpoint, using: NWParameters(passcode: passcode))
        self.connection = connection

        startConnection()
    }
    
    // Handle an inbound connection when the user receives a game request.
    init(connection: NWConnection, delegate: PeerConnectionDelegate) {
        self.delegate = delegate
        self.connection = connection
        self.initiatedConnection = false

        startConnection()
    }
    
    /// Handle the user exiting the chat room.
    func cancel() {
        if let connection = self.connection {
            connection.cancel()
            self.connection = nil
        }
    }
    
    /// Starts the peer-to-peer connection for both inbound and outbound connections.
    func startConnection() {
        guard let connection = connection else { return }
        
        connection.stateUpdateHandler = { newState in
            switch newState {
            case .ready:
                self.connectionReady(connection)
                
            case .failed(let error):
                self.connectionFailed(connection, error: error)
                
            default:
                break
            }
        }

        // Start the connection establishment.
        connection.start(queue: .main)
    }
    
    
    /// Sends message via created connection
    /// - Parameter message: The message to send
    func send(_ message: String) {
        guard let connection = connection else {
            return
        }
        
        let content = message.data(using: .utf8)
        let message = NWProtocolFramer.Message(messageType: .message)
        let context = NWConnection.ContentContext(identifier: "Message", metadata: [message])

        // Send the application content along with the message.
        connection.send(content: content, contentContext: context, isComplete: true, completion: .idempotent)
    }
    
    /// Sends join request via created connection
    /// - Parameter request: The request to send
    func sendRequest(_ request: JoinRequest) {
        guard let connection = connection else {
            return
        }
        
        let content = request.json?.data(using: .utf8)
        let message = NWProtocolFramer.Message(messageType: .joinRequest)
        let context = NWConnection.ContentContext(identifier: "Request", metadata: [message])
        
        // Send the application content along with the message.
        connection.send(content: content, contentContext: context, isComplete: true, completion: .idempotent)
    }
    
    /// Accepts request
    func acceptRequest() {
        guard let connection = connection else {
            return
        }
        
        let content = "Accept".data(using: .utf8)
        let message = NWProtocolFramer.Message(messageType: .acceptRequest)
        let context = NWConnection.ContentContext(identifier: "Accept", metadata: [message])
        
        // Send the application content along with the message.
        connection.send(content: content, contentContext: context, isComplete: true, completion: .idempotent)
    }
    
    /// Declines request
    func declineRequest() {
        guard let connection = connection else {
            return
        }
        
        let content = "Decline".data(using: .utf8)
        let message = NWProtocolFramer.Message(messageType: .declineRequest)
        let context = NWConnection.ContentContext(identifier: "Decline", metadata: [message])
        
        // Send the application content along with the message.
        connection.send(content: content, contentContext: context, isComplete: true, completion: .idempotent)
    }
    
    /// Receives a message.
    ///
    /// It will continue to receive more messages untill receive an error.
    private func receiveNextMessage() {
        guard let connection = connection else { return }

        connection.receiveMessage { (content, context, isComplete, error) in
            // Extract message type from the received context.
            if let message = context?.protocolMetadata(definition: ChatNWProtocol.definition) as? NWProtocolFramer.Message {
                self.delegate?.receivedMessage(content: content, message: message)
            }
            
            if error == nil {
                self.receiveNextMessage()
            }
        }
    }
    
    /// The connection is established, and ready to send and receive data.
    /// - Parameter connection: A bidirectional data connection between a local endpoint and a remote endpoint.
    private func connectionReady(_ connection: NWConnection) {
        print("\(connection) established")
        // When the connection is ready, start receiving messages.
        receiveNextMessage()
        // Notify delegate that the connection is ready.
        delegate?.connectionReady()
    }
    
    /// The connection has disconnected or encountered an error.
    /// - Parameters:
    ///   - connection: A bidirectional data connection between a local endpoint and a remote endpoint.
    ///   - error: An error when connection is failed
    private func connectionFailed(_ connection: NWConnection, error: NWError) {
        print("\(connection) failed with \(error)")
        // Cancel the connection upon a failure.
        connection.cancel()
        // Notify delegate that the connection failed.
        delegate?.connectionFailed()
    }
}
