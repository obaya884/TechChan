//
//  TechChanModel.swift
//  TechChan
//
//  Created by 大林拓実 on 2019/09/23.
//  Copyright © 2019 大林拓実. All rights reserved.
//

import Foundation
import UIKit
import Firebase

final class TechChanModel: NSObject {
    
    var ref: DatabaseReference = Database.database().reference()
    var handle: UInt?
    
    static let shared = TechChanModel()
    
    private var userName: String = "匿メンター"
    
    public var chatLogArray: [Dictionary<String, String>] = []
        
    // userNameセッター
    func setUserName(userName: String) {
        self.userName = userName
    }
    
    // userNameゲッター
    func getUserName() -> String {
        return self.userName
    }
    
    // 投稿処理
    func messagePost(postMessage: String) {
        let now = Date()
        let date = dateFormat(dateInfo: now)

        self.ref.childByAutoId().setValue(["username": self.getUserName(), "message":postMessage, "posttime": date])
    }
    
    // DB更新監視
    func observeChatData(tableView: UITableView) {
        handle = ref.observe(.childAdded, with: { (snapshot) -> Void in
                print(snapshot)
                let dic = snapshot.value as! Dictionary<String, String>
                self.chatLogArray.insert(["username": dic["username"]!, "message": dic["message"]!, "posttime": dic["posttime"]!], at: 0)
                print(self.chatLogArray)
                tableView.reloadData()
            }) {(error) in
                print(error.localizedDescription)
            }
    }
    
    // リセット
    func resetChatData() {
        chatLogArray.removeAll()
        ref.removeObserver(withHandle: handle!)
    }
    
    /// 日付フォーマッタ
    func dateFormat(dateInfo: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        return dateFormatter.string(from: dateInfo)
    }

}
