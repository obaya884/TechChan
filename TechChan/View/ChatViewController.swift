//
//  ChatViewController.swift
//  TechChan
//
//  Created by 大林拓実 on 2019/09/23.
//  Copyright © 2019 大林拓実. All rights reserved.
//

import UIKit

final class ChatViewController: UIViewController {

    private var datasource: ChatTableViewDataSource?
    private let techChanManager = TechChanModel.shared
    
    private let userName: String = ""
    
    @IBOutlet private var userNameLabel: UILabel!
    @IBOutlet private var postMessageTextField: UITextField!
    @IBOutlet private var chatTableView: TouchEventChainTableView!
    
    // 編集中のTextFieldを保持する変数
    private var activeTextField: UITextField? = nil

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

// TextField入力時にキーボード分だけ画面をずらす処理
extension ChatViewController: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // 編集対象のTextFieldを保存する
        activeTextField = textField
        return true;
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // NotificationCenterからのキーボード表示通知に伴う処理
    @objc func keyboardWillShow(_ notification: Notification) {
        let rect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        guard let keyboardHeight = rect?.size.height else {
            return
        }
            let duration: TimeInterval? = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
            UIView.animate(withDuration: duration!, animations: { () in
                self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
            })
    }

    // NotificationCenterからのキーボード非表示通知に伴う処理
    @objc func keyboardWillHide(_ notification: Notification) {
        let duration: TimeInterval? = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Double
        UIView.animate(withDuration: duration!, animations: { () in
            self.view.transform = CGAffineTransform.identity
        })
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
