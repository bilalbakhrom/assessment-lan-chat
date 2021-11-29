//
//  PeerListener.swift
//  WiFiLanChat
//
//  Created by Bilol Mamadjanov on 28/11/21.
//

import Network

protocol PeerListenerDelegate: AnyObject {
    func displayAdvertiseError(_ error: NWError)
    func receivedConnection(_ newConnection: NWConnection)
}

class PeerListener {
    /// Bonjour service type use to browse and create listener service
    static let serviceType: String = "_wifilanchat._tcp"
    /// Bonjour service name
    private var name: String
    /// Bonjour service parameter
    private let passcode: String
    /// An object to handle incoming connection
    private var listener: NWListener?
    /// The object that acts as the delegate of the listener.
    weak var delegate: PeerListenerDelegate?
    
    // Create a listener with a name to advertise, a passcode for authentication,
    // and a delegate to handle inbound connections.
    init?(name: String, passcode: String, delegate: PeerListenerDelegate) {
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
            
        default:
            break
        }
    }
    
    /// A handler that receives inbound connections.
    private func newConnectionHandler(_ newConnection: NWConnection) {
        delegate?.receivedConnection(newConnection)
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
