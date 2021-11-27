//
//  MockedStartViewController.swift
//  WiFiLanChatTests
//
//  Created by Bilol Mamadjanov on 27/11/21.
//

import UIKit
@testable import WiFiLanChat

internal class MockedStartViewController: StartViewController {
    override func listentWifiConnectionStatus() {}
    
    func connectToWifi() {
        didEstablishWifiConnection()
    }
    
    func disconnectFromWifi() {
        didLostWifiConnection()
    }
}
