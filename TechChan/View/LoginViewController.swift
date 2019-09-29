//
//  LoginViewController.swift
//  TechChan
//
//  Created by 大林拓実 on 2019/09/23.
//  Copyright © 2019 大林拓実. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {
    
    private let techChanManager = TechChanModel.shared

    @IBOutlet private weak var userNameTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    
    // 編集中のTextFieldを保持する変数
    private var activeTextField: UITextField? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // TextFieldまわり
        userNameTextField.delegate = self
        userNameTextField.returnKeyType = .done
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Notificationを設定する
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // ログインボタン押下
    @IBAction func loginButtonTapped() {
        if userNameTextField.text != "" {
            techChanManager.setUserName(userName: userNameTextField.text!)
            userNameTextField.text = ""
            performSegue(withIdentifier: "toChatViewControllerSegue", sender: nil)
        } else {
            techChanManager.setUserName(userName: "匿メンター")
            let alert = UIAlertController(title: "確認", message: "「匿メンター」としてログインします", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: {
                [weak self] _ in
                self?.userNameTextField.text = ""
                self?.performSegue(withIdentifier: "toChatViewControllerSegue", sender: nil)
            })
            let canselAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
            alert.addAction(okAction)
            alert.addAction(canselAction)
            
            present(alert, animated:true, completion:nil)
        }
    }
    
    // 画面外をタッチした時にキーボードをしまう
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            // どのtextfield編集に対しても閉じれるようにviewに対してendEditngする
            self.view.endEditing(true)
    }


}

extension LoginViewController: UITextFieldDelegate {
    
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
        guard let textField = activeTextField else {
            return
        }
        let rect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        guard let keyboardHeight = rect?.height else {
            return
        }
        let mainBoundsSize = UIScreen.main.bounds.size
        let textFieldLimit = textField.frame.origin.y + textField.frame.height + 8.0
        let keyboardLimit = mainBoundsSize.height - keyboardHeight
        if keyboardLimit <= textFieldLimit {
            let duration: TimeInterval? = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
            UIView.animate(withDuration: duration!, animations: { () in
                self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
            })
        }
    }
    // NotificationCenterからのキーボード非表示通知に伴う処理
    @objc func keyboardWillHide(_ notification: Notification) {
        let duration: TimeInterval? = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Double
        UIView.animate(withDuration: duration!, animations: { () in
            self.view.transform = CGAffineTransform.identity
        })
    }

}

