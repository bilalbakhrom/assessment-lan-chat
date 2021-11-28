//
//  JoinRequest.swift
//  WiFiLanChat
//
//  Created by Bilol Mamadjanov on 28/11/21.
//

import Foundation

struct JoinRequest: Codable {
    let host: String
    let username: String
}

extension JoinRequest: JSONProtocol {    
    var json: String? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
}
