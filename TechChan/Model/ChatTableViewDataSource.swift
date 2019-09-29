//
//  ChatTableViewDataSource.swift
//  TechChan
//
//  Created by 大林拓実 on 2019/09/25.
//  Copyright © 2019 大林拓実. All rights reserved.
//

import Foundation
import UIKit

final class ChatTableViewDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private let techChanManager = TechChanModel.shared
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return techChanManager.chatLogArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatTableViewCell") as! ChatTableViewCell
        cell.selectionStyle = .none
        
        cell.userNameLabel.text = techChanManager.chatLogArray[indexPath.row]["username"]
        cell.messageLabel.text = techChanManager.chatLogArray[indexPath.row]["message"]
        cell.postTimeLabel.text = techChanManager.chatLogArray[indexPath.row]["posttime"]
        
        cell.postNumber = techChanManager.chatLogArray.count - indexPath.row
        cell.postNumberLabel.text = "\(String(cell.postNumber!))："
        return cell
    }
}
