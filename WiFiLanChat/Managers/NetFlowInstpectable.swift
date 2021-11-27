//
//  NetFlowInstpectable.swift
//  WiFiLanChat
//
//  Created by Bilol Mamadjanov on 27/11/21.
//

public protocol NetFlowInspectable: AnyObject {
    typealias InterfaceStatus = NetFlowInspector.InterfaceStatus
    
    /// A boolean indicates whether network is reachable or not
    var isReachable: Bool { get }
    
    /// A boolean indcates network status
    var interfaceStatus: InterfaceStatus { get }
    
    /// A name or address that identifies a network endpoint
    var host: String? { get }
    
    /**
     Starts on background
     
     Creates a new objects in order to check network status. If network available,
     tells delegate method networkReachable that connection is satisfied.
     */
    func start()
    
    /// Stops background objects that checks network connection status
    func stop()
    
    /// Adds an entry to receive notifications that passed to the provided block.
    /// - Parameter key: The key name of the observer
    /// - Parameter block: The callback is called whenever status changes
    func addObserver(forKeyPath key: String, using block: @escaping (_ status: InterfaceStatus) -> Void)
    
    /// Removes observer with provided key name
    func removeObserver(forKeyPath key: String)
}
