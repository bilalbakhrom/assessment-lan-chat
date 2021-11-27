//
//  NetFlowInspector.swift
//  WiFiLanChat
//
//  Created by Bilol Mamadjanov on 27/11/21.
//

import Network
import Combine

/// We use this class to control wi-fi connection. We can know whether user connects to wi-fi or not
public final class NetFlowInspector {
    /// The only instance of `NetFlowInspector`
    public static let shared: NetFlowInspectable = NetFlowInspector()
    /// Monitors network changes
    private let monitor: NWPathMonitor
    /// A value indicating whether a path can be used by connections.
    private var status: NWPath.Status { didSet { didUpdateStatus() } }
    /// The publishers that send status changes
    private var publishers: [String: PassthroughSubject<InterfaceStatus, Never>] = [:]
    /// The subcriptions of publishers
    private var subscriptions: Set<AnyCancellable> = []
    /// A variable to store network addresses
    private var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
    
    /// Block class initialization
    private init() {
        // We are going to monitor wifi only
        monitor = NWPathMonitor(requiredInterfaceType: .wifi)
        status = .requiresConnection
        bind()
    }
    
    /// This method will be called whenever network status is changed
    private func didUpdateStatus() {
        #if DEBUG
        debugPrint()
        #endif
        let currentInterfaceStatus = interfaceStatus
        publishers.forEach { $0.value.send(currentInterfaceStatus) }
    }
    
    /// Binds network path and current class
    private func bind() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
        }
    }
    
    /// Will be used on debug
    private func debugPrint() {
        print("Network status: \(isReachable ? "Connected" : "Not Connected")")
    }
}

// MARK: - NetFlowInspectable
extension NetFlowInspector: NetFlowInspectable {
    public var isReachable: Bool {
        status == .satisfied
    }
    
    public var interfaceStatus: InterfaceStatus {
        isReachable ? .connected : .disconnected
    }
    
    public var host: String? {
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
        var ptr = ifaddr
        
        while ptr != nil {
            defer { ptr = ptr?.pointee.ifa_next }
            guard let interface = ptr?.pointee, interface.isWifiDevice else { continue }
            getnameinfo(interface.ifa_addr,
                        socklen_t(interface.ifa_addr.pointee.sa_len),
                        &hostname,
                        socklen_t(hostname.count),
                        nil,
                        socklen_t(0),
                        NI_NUMERICHOST
            )
        }
        freeifaddrs(ifaddr)
        
        return String(cString: hostname)
    }
    
    public func start() {
        monitor.start(queue: .main)
    }
    
    public func stop() {
        monitor.cancel()
    }
    
    public func addObserver(forKeyPath key: String, using block: @escaping (_ status: InterfaceStatus) -> Void) {
        // Create a subject that broadcasts elements to downstream subscribers.
        let publisher = PassthroughSubject<InterfaceStatus, Never>()
        // Attach subscriber.
        publisher
            .sink(receiveValue: block)
            .store(in: &subscriptions)
        // Add subject in array
        publishers[key] = publisher
    }
    
    public func removeObserver(forKeyPath key: String) {
        publishers[key] = nil
    }
}


extension NetFlowInspector {
    public enum InterfaceStatus {
        case connected
        case disconnected
    }
}
