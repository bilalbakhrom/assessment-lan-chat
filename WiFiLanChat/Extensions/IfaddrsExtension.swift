//
//  Ifaddrs+Ext.swift
//  WiFiLanChat
//
//  Created by Bilol Mamadjanov on 27/11/21.
//

import Foundation

extension ifaddrs {
    var isWifi: Bool {
        let name = String(cString: ifa_name)
        return validateInterface(ifa_addr.pointee.sa_family) && name == "en0"
    }
    
    /// Checks for IPv4 or IPv6 interfaces
    private func validateInterface(_ addr: sa_family_t) -> Bool {
        addr == UInt8(AF_INET) || addr == UInt8(AF_INET6)
    }
}
