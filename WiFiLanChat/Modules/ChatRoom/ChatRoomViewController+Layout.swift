//
//  ChatRoomViewController+Layout.swift
//  WiFiLanChat
//
//  Created by Bilol Mamadjanov on 27/11/21.
//

import UIKit

extension ChatRoomViewController {
    struct DrawingConstants {
        
    }
}

extension ChatRoomViewController {
    override func embedSubviews() {
        view.addSubview(tableView)
        view.addSubview(messageInputBar)
    }
    
    override func setSubviewsConstraints() {
        setTableViewConstraints()
    }
}

extension ChatRoomViewController {
    private func setTableViewConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
