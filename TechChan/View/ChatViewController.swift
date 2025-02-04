//
//  ChatViewController.swift
//  TechChan
//
//  Created by 大林拓実 on 2019/09/23.
//  Copyright © 2019 大林拓実. All rights reserved.
//

import UIKit

final class ChatViewController: KeyboardSlidingViewController {

    private var datasource: ChatTableViewDataSource?
    private let techChanManager = TechChanModel.shared
    
    private let userName: String = ""
    
    @IBOutlet private var userNameLabel: UILabel!
    @IBOutlet private var postMessageTextField: UITextField!
    @IBOutlet private var chatTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        userNameLabel.text = techChanManager.getUserName()
        setupTableView()
        techChanManager.observeChatData(tableView: chatTableView)
        
        // TableViewまわり
        self.chatTableView.delegate = self
        self.chatTableView.estimatedRowHeight = 70
        self.chatTableView.rowHeight = UITableView.automaticDimension
        
        // TextFieldまわり
        postMessageTextField.delegate = self
        postMessageTextField.returnKeyType = .done
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Notificationを設定する
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        techChanManager.resetChatData()
    }
        
    func setupTableView() {
        datasource = ChatTableViewDataSource()
        chatTableView.register(UINib(nibName: "ChatTableViewCell", bundle: nil), forCellReuseIdentifier: "chatTableViewCell")
        chatTableView.delegate = datasource
        chatTableView.dataSource = datasource
    }
    
    // 投稿ボタン押下
    @IBAction func postButtonTapped() {
        if postMessageTextField.text != "" {
            techChanManager.messagePost(postMessage: self.postMessageTextField.text!)
            postMessageTextField.text = ""
        } else {
            postMessageTextField.backgroundColor = .red
        }
    }
    
    // 戻るボタン押下
    @IBAction func backButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // 画面外をタッチした時にキーボードをしまう
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            // どのtextfield編集に対しても閉じれるようにviewに対してendEditngする
            self.view.endEditing(true)
    }

}

// セルタップ時にリプライ表記を追加して入力状態にする処理
extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell: ChatTableViewCell = tableView.cellForRow(at: indexPath) as! ChatTableViewCell
        postMessageTextField.text = ">\(String(cell.postNumber!)) "
        postMessageTextField.becomeFirstResponder()
    }
}
