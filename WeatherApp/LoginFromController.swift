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
    @IBOutlet weak var loginTitleView: UILabel!
    @IBOutlet weak var passwordTitleView: UILabel!
    @IBOutlet weak var titleView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signInButton.isEnabled = false
        
        loginTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView.addGestureRecognizer(hideKeyboardGesture)
        
        animateTitlesAppearing()
        animateTitleAppearing()
        animateFieldsAppearing()
        animateAuthButton()
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
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        let checkResult = checkUserData()
        
        if !checkResult {
            showLoginError()
        }
        
        return checkResult
    }
    
    func checkUserData() -> Bool {
        let login = loginTextField.text
        let password = passwordTextField.text
        
        if login == "Eugene" && password == "000" {
            return true
        } else {
            return false
        }
    }
    
    @IBAction func pressedSingInButton(_ sender: UIButton) {
    }
    
// MARK: - Help Function
    
    func showLoginError() {
        
        let alert = UIAlertController(title: "Error!",
                                      message: """
                                                           Your Login: Eugene
                                                           Your Password: 000
                                                           """,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func animateTitlesAppearing() {
        
        let offset = view.bounds.width
        loginTitleView.transform = CGAffineTransform(translationX: -offset, y: 0)
        passwordTitleView.transform = CGAffineTransform(translationX: offset, y: 0)
        
        UIView.animate(withDuration: 1,
                       delay: 1,
                       options: .curveEaseOut,
                       animations: { [weak self] in
                        self?.loginTitleView.transform = .identity
                        self?.passwordTitleView.transform = .identity
            },
                       completion: nil)
    }
    
    func animateTitleAppearing() {
        
        self.titleView.transform = CGAffineTransform(translationX: 0, y: -self.view.bounds.height / 2)
        
        UIView.animate(withDuration: 1,
                       delay: 1,
                       options: .curveEaseOut,
                       animations: { [weak self] in
                        self?.titleView.transform = .identity
        },
                       completion: nil)
    }
    
    func animateFieldsAppearing() {
        
        let fadeInAnimation = CABasicAnimation(keyPath: "opacity")
        
        fadeInAnimation.fromValue = 0
        fadeInAnimation.toValue = 1
        fadeInAnimation.duration = 1
        fadeInAnimation.beginTime = CACurrentMediaTime() + 1
        fadeInAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        fadeInAnimation.fillMode = CAMediaTimingFillMode.backwards
        
        self.loginTextField.layer.add(fadeInAnimation, forKey: nil)
        self.passwordTextField.layer.add(fadeInAnimation, forKey: nil)
    }
    
    func animateAuthButton() {
        
        let animation = CASpringAnimation(keyPath: "transform.scale")
        
        animation.fromValue = 0
        animation.toValue = 1
        animation.stiffness = 200
        animation.mass = 2
        animation.duration = 2
        animation.beginTime = CACurrentMediaTime() + 1
        animation.fillMode = CAMediaTimingFillMode.backwards
        
        self.signInButton.layer.add(animation, forKey: nil)
    }
}

extension LoginFromController {
    
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
