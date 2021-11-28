//
//  SearchViewController+ConnectionEstablishmentState.swift
//  WiFiLanChat
//
//  Created by Bilol Mamadjanov on 28/11/21.
//

extension SearchViewController {
    enum ConnectionEstablishmentState {
        case creatingRequest
        case waiting
        case connected
        case none
        
        var title: String {
            switch self {
            case .creatingRequest:
                return "Creating request"
            case .waiting:
                return "Pending"
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
