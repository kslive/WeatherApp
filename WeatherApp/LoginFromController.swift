//
//  LoginFromController.swift
//  WeatherApp
//
//  Created by Eugene Kiselev on 29.07.2020.
//  Copyright © 2020 Eugene Kiselev. All rights reserved.
//

import UIKit

class LoginFromController: UIViewController {

    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
// Изначально кнопка не активна.
        signInButton.isEnabled = false
        
// Наблюдатель за изменением text field.
        loginTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView.addGestureRecognizer(hideKeyboardGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden​(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }

    @IBAction func pressedSingInButton(_ sender: UIButton) {
    }
}

extension LoginFromController {
    
// Если поля Text Field пустые, то кнопка будет не активна.
    @objc func textFieldDidChange(textField: UITextField) {
        if loginTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            signInButton.isEnabled = false
        } else {
            signInButton.isEnabled = true
        }
    }
    
    @objc func keyboardWasShown(notification: Notification) {
        
            let info = notification.userInfo! as NSDictionary
            let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height, right: 0)
            
            self.scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillBeHidden​(notification: Notification) {
        let ​contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = ​contentInsets
    }
    
    @objc func hideKeyboard() {
        self.scrollView.endEditing(true)
    }
}
