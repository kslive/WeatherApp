//
//  LoginFromController.swift
//  WeatherApp
//
//  Created by Eugene Kiselev on 29.07.2020.
//  Copyright © 2020 Eugene Kiselev. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginFromController: UIViewController {
    
    private var handle: AuthStateDidChangeListenerHandle!
    var interactiveAnimator: UIViewPropertyAnimator!

    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var loginTitleView: UILabel!
    @IBOutlet weak var passwordTitleView: UILabel!
    @IBOutlet weak var titleView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView.addGestureRecognizer(hideKeyboardGesture)
        
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        self.view.addGestureRecognizer(recognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden​(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        handle = Auth.auth().addStateDidChangeListener({ [weak self] auth, user in
            
            if user != nil {
                
                self?.performSegue(withIdentifier: "Log In", sender: nil)
                self?.loginTextField.text = nil
                self?.passwordTextField.text = nil
            }
        })
        
        animateTitlesAppearing()
        animateTitleAppearing()
        animateFieldsAppearing()
        animateAuthButton()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        Auth.auth().removeStateDidChangeListener(handle)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        return true
    }
    
    
    @IBAction func pressedLogInButton(_ sender: UIButton) {
        
        guard let email = loginTextField.text,
              let password = passwordTextField.text,
              email.count > 0,
              password.count > 0 else {
            self.showAlert(title: "Error", message: "Login/password is not entered")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
            
            if let error = error, user == nil {
                self?.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    @IBAction func pressedSignInButton(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Register", message: "Register", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
        
            guard let emailTextField = alert.textFields?[0],
                  let passwordTextField = alert.textFields?[1],
                  let password = passwordTextField.text,
                  let email = emailTextField.text else { return }
            
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] user, error in
                
                if let error = error {
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                } else {
                    Auth.auth().signIn(withEmail: email, password: password)
                }
            }
        }
        
        alert.addTextField { textEmail in
            
            textEmail.placeholder = "Enter your email"
        }
        
        alert.addTextField { textPassword in
            
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Enter Password"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
// MARK: - Help Function
        
    func showAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel)
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func animateTitlesAppearing() {
        
        let offset = abs(loginTitleView.frame.midY - passwordTitleView.frame.midY)
        loginTitleView.transform = CGAffineTransform(translationX: 0, y: offset)
        passwordTitleView.transform = CGAffineTransform(translationX: 0, y: -offset)
        
        UIView.animateKeyframes(withDuration: 1,
                                delay: 1,
                                options: .calculationModePaced,
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0,
                                                       relativeDuration: 0.5) {
                                                        self.loginTitleView.transform = CGAffineTransform(translationX: 150, y: 50)
                                                        self.passwordTitleView.transform = CGAffineTransform(translationX: -150, y: -50)
                                    }
                                    UIView.addKeyframe(withRelativeStartTime: 0.5,
                                                       relativeDuration: 0.5) {
                                                        self.loginTitleView.transform = .identity
                                                        self.passwordTitleView.transform = .identity
                                    }
        },
                                completion: nil)
    }
    
    func animateTitleAppearing() {
        
        self.titleView.transform = CGAffineTransform(translationX: 0, y: -self.view.bounds.height / 2)
        
        let animator = UIViewPropertyAnimator(duration: 1, dampingRatio: 0.5) {
            self.titleView.transform = .identity
        }
        
        animator.startAnimation(afterDelay: 1)
    }
    
    func animateFieldsAppearing() {
        
        let fadeInAnimation = CABasicAnimation(keyPath: "opacity")
        fadeInAnimation.fromValue = 0
        fadeInAnimation.toValue = 1
        
        let scaleAnimation = CASpringAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 0
        scaleAnimation.toValue = 1
        scaleAnimation.stiffness = 150
        scaleAnimation.mass = 2
        
        let animationsGroup = CAAnimationGroup()
        animationsGroup.duration = 1
        animationsGroup.beginTime = CACurrentMediaTime() + 1
        animationsGroup.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animationsGroup.animations = [fadeInAnimation, scaleAnimation]
        
        self.loginTextField.layer.add(animationsGroup, forKey: nil)
        self.passwordTextField.layer.add(animationsGroup, forKey: nil)
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
        
        self.logInButton.layer.add(animation, forKey: nil)
    }
}

extension LoginFromController {
    
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
    
    @objc func onPan(_ recognizer: UIPanGestureRecognizer) {
        
        switch recognizer.state {
        case .began:
            interactiveAnimator.startAnimation()
            
            interactiveAnimator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.5, animations: {
                self.logInButton.transform = CGAffineTransform(translationX: 0, y: 150)
            })
        case .changed:
            let translation = recognizer.translation(in: self.view)
            interactiveAnimator.fractionComplete = translation.y / 100
        case .ended:
            interactiveAnimator.stopAnimation(true)
            
            interactiveAnimator.addAnimations {
                self.logInButton.transform = .identity
            }
            
            interactiveAnimator.startAnimation()
        default:
            return
        }
    }
}
