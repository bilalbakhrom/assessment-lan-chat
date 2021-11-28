//
//  DataExtension.swift
//  WiFiLanChat
//
//  Created by Bilol Mamadjanov on 28/11/21.
//

import Foundation

extension Data {
    var convertToJoinRequest: JoinRequest? {
        try? JSONDecoder().decode(JoinRequest.self, from: self)
    }
}
