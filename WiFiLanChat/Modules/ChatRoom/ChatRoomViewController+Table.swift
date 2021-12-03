//
//  ChatRoomViewController+Table.swift
//  WiFiLanChat
//
//  Created by Bilol Mamadjanov on 30/11/21.
//

import UIKit

extension ChatRoomViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: uiConst.cellIdentifier, for: indexPath) as! MessageTableViewCell
        cell.apply(message: message)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        MessageTableViewCell.height(for: messages[indexPath.row])
    }
    
    func insertNewMessageCell() {
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .none)
        tableView.endUpdates()
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}
