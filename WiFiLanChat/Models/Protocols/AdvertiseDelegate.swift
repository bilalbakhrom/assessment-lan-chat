//
//  AdvertiseDelegate.swift
//  WiFiLanChat
//
//  Created by Bilol Mamadjanov on 29/11/21.
//

import Network

protocol AdvertiseDelegate: AnyObject {
    func displayAdvertiseError(_ error: NWError)
}
