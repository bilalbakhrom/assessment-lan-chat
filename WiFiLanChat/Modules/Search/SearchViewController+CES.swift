//
//  SearchViewController+ConnectionEstablishmentState.swift
//  WiFiLanChat
//
//  Created by Bilol Mamadjanov on 28/11/21.
//

extension SearchViewController {
    enum ConnectionEstablishmentState {
        case searching
        case waiting
        case connecting
        case failed
        case connected
        case none
        
        var title: String {
            switch self {
            case .searching:
                return "Searching host"
            case .waiting:
                return "Waiting to connect"
            case .connecting:
                return "Connecting"
            case .failed:
                return "Failed"
            case .connected:
                return "Connected"
            case .none:
                return "Connect"
            }
        }
        
        var canEstablishConnection: Bool {
            switch self {
            case .connected, .none:
                return true
            default:
                return false
            }
        }
    }
}
