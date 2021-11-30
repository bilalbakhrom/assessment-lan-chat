//
//  DataExtension.swift
//  WiFiLanChat
//
//  Created by Bilol Mamadjanov on 30/11/21.
//

import Foundation

extension Data {
    var toString: String? {
        String(data: self, encoding: .utf8)
    }
}
