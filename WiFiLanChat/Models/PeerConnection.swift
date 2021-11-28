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
}

class PeerConnection {
    private var connection: NWConnection?
    weak var delegate: PeerConnectionDelegate?
    
    init(host: String, port: UInt16) {
        connection = makeNWConnection(host: host, port: port)
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

        // Create a message object to hold the command type.
        let content = message.data(using: .utf8)
        let message = NWProtocolFramer.Message(messageType: .message)
        let context = NWConnection.ContentContext(identifier: "Move", metadata: [message])

        // Send the application content along with the message.
        connection.send(content: content, contentContext: context, isComplete: true, completion: .idempotent)
    }

    /// Creates a new bidirectional data connection
    /// - Parameters:
    ///   - hostString: A name or address that identifies a network endpoint
    ///   - portInteger: A port number you use along with a host to identify a network endpoint.
    /// - Returns: Returns a connection instance
    private func makeNWConnection(host hostString: String, port portInteger: UInt16) -> NWConnection {
        NWConnection(
            host: NWEndpoint.Host(hostString),
            port: NWEndpoint.Port(integerLiteral: portInteger),
            using: .udp
        )
    }
    
    /// Receives a message.
    ///
    /// It will continue to receive more messages untill receive an error.
    private func receiveNextMessage() {
        guard let connection = connection else { return }

        connection.receiveMessage { (content, context, isComplete, error) in
            // Extract message type from the received context.
            if let message = context?.protocolMetadata(definition: ChatProtocol.definition) as? NWProtocolFramer.Message {
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
