//
//  NWBrowser.ResultExtension.swift
//  WiFiLanChat
//
//  Created by Bilol Mamadjanov on 28/11/21.
//

import Network

extension Array where Element == NWBrowser.Result {
    func find(host: String) -> NWBrowser.Result? {
        for result in self {
            if case let NWEndpoint.service(name: name, type: _, domain: _, interface: _) = result.endpoint {
                if name == host {
                    return result
                }
            }
        }
        
        return nil
    }
}
