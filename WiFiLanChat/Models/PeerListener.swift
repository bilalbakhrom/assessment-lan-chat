//
//  PeerListener.swift
//  WiFiLanChat
//
//  Created by Bilol Mamadjanov on 28/11/21.
//

import Network

protocol PeerListenerDelegate: AnyObject {
    func displayAdvertiseError(_ error: NWError)
}

class PeerListener {
    private var name: String
    private let passcode: String
    private var listener: NWListener?
    weak var delegate: PeerConnectionDelegate?
    
    static let serviceType: String = "_wifilanchat._tcp"
    
    // Create a listener with a name to advertise, a passcode for authentication,
    // and a delegate to handle inbound connections.
    init?(name: String, passcode: String, delegate: PeerConnectionDelegate) {
        self.delegate = delegate
        self.name = name
        self.passcode = passcode
        
        if willCreateListenerObject() {
            startListening()
        } else {
            return nil
        }
    }
    
    /// Creates the listener object.
    /// - Returns: Returns a boolean value indicating the listener object is created or not
    func willCreateListenerObject() -> Bool {
        do {
            listener = try NWListener(using: NWParameters(passcode: passcode))
            return true
        } catch {
            print("Failed to create listener")
            abort()
        }
    }
    
    /// Starts listening.
    func startListening() {
        guard let listener = listener else {
            return
        }
        
        // Set the service to advertise.
        listener.service = NWListener.Service(name: self.name, type: PeerListener.serviceType)
        // Handle state.
        listener.stateUpdateHandler = stateUpdateHandler(_:)
        // Handle a new connection.
        listener.newConnectionHandler = newConnectionHandler(_:)
        // Start listening, and request updates on the main queue.
        listener.start(queue: .main)
    }
    
    /// A handler that receives listener state updates.
    private func stateUpdateHandler(_ newState: NWListener.State) {
        guard let listener = listener else {
            return
        }

        switch newState {
        case .ready:
            print("Listener ready on \(String(describing: listener.port))")
            
        case .failed(let error):
            // If the listener fails, re-start.
            if error == NWError.dns(DNSServiceErrorType(kDNSServiceErr_DefunctConnection)) {
                print("Listener failed with \(error), restarting")
                listener.cancel()
                self.startListening()
                
            } else {
                print("Listener failed with \(error), stopping")
                self.delegate?.displayAdvertiseError(error)
                listener.cancel()
            }
            
        case .cancelled:
            P2PManager.sharedListener = nil
            
        default:
            break
        }
    }
    
    /// A handler that receives inbound connections.
    private func newConnectionHandler(_ newConnection: NWConnection) {
        guard let delegate = self.delegate else {
            return
        }
        
        if P2PManager.sharedConnection == nil {
            // Accept a new connection.
            P2PManager.sharedConnection = PeerConnection(connection: newConnection, delegate: delegate)
        } else {
            // If a chat is already in progress, reject it.
            newConnection.cancel()
        }
    }
    
    /// Stops listening for inbound connections.
    func cancel() {
        listener?.cancel()
        listener = nil
    }
    
    /// Updates the advertised name.
    func resetName(_ name: String) {
        self.name = name
        if let listener = listener {
            // Reset the service to advertise.
            listener.service = NWListener.Service(name: self.name, type: "_wifilanchat._tcp")
        }
    }
}
