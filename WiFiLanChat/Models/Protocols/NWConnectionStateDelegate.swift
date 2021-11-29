//
//  NWConnectionStateDelegate.swift
//  WiFiLanChat
//
//  Created by Bilol Mamadjanov on 29/11/21.
//

protocol NWConnectionStateDelegate: AnyObject {
    func connectionReady()
    func connectionFailed()
    func connectionPreparing()
    func connectionCanceled()
}
