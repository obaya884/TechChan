//
//  KeyboardSlidingViewController.swift
//  TechChan
//
//  Created by 大林拓実 on 2019/09/30.
//  Copyright © 2019 大林拓実. All rights reserved.
//

import Foundation
import UIKit

class KeyboardSlidingViewController: UIViewController, UITextFieldDelegate {
    // 編集中のTextFieldを保持する変数
    private var activeTextField: UITextField? = nil

    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // 編集対象のTextFieldを保存する
        activeTextField = textField
        return true;
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
