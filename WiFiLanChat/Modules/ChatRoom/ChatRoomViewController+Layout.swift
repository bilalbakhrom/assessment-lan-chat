//
//  ChatRoomViewController+Layout.swift
//  WiFiLanChat
//
//  Created by Bilol Mamadjanov on 27/11/21.
//

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
        
    }
}

extension ChatRoomViewController {
    
}
