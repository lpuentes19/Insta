//
//  LoginViewController.swift
//  Insta
//
//  Created by Luis Puentes on 10/12/18.
//  Copyright © 2018 LuisPuentes. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createAcctButton: UIButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        
        let emailTextLayer = CALayer()
        emailTextLayer.frame = CGRect(x: 0, y: emailTextField.frame.maxY, width: emailTextField.frame.size.width, height: 0.8)
        // Need to specify in order for animation
        // to move from left to right
        emailTextLayer.position = CGPoint(x: 0, y: emailTextField.frame.maxY)
        emailTextLayer.anchorPoint = CGPoint(x: 0, y: 0)
        emailTextLayer.backgroundColor = UIColor.white.cgColor
        
        let passwordTextLayer = CALayer()
        passwordTextLayer.frame = CGRect(x: 0, y: emailTextField.frame.maxY, width: passwordTextField.frame.size.width, height: 0.8)
        // Need to specify in order for animation
        // to move from left to right
        passwordTextLayer.position = CGPoint(x: 0, y: emailTextField.frame.maxY)
        passwordTextLayer.anchorPoint = CGPoint(x: 0, y: 0)
        
        passwordTextLayer.backgroundColor = UIColor.white.cgColor
        
        emailTextField.backgroundColor = .clear
        emailTextField.textColor = .white
        emailTextField.tintColor = .white
        emailTextField.borderStyle = .none
        emailTextField.layer.addSublayer(emailTextLayer)
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        passwordTextField.backgroundColor = .clear
        passwordTextField.textColor = .white
        passwordTextField.tintColor = .white
        passwordTextField.borderStyle = .none
        passwordTextField.layer.addSublayer(passwordTextLayer)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        let lineAnimation = CABasicAnimation(keyPath: "bounds.size.width")
        lineAnimation.fromValue = 0
        lineAnimation.toValue = emailTextField.bounds.size.width
        lineAnimation.duration = 1.5
        emailTextLayer.add(lineAnimation, forKey: "Email Line Animation")
        passwordTextLayer.add(lineAnimation, forKey: "Password Line Animation")
        
        loginButton.layer.cornerRadius = 20
        loginButton.layer.borderWidth = 2
        loginButton.layer.borderColor = UIColor.white.cgColor
        
        createAcctButton.layer.cornerRadius = 25
        createAcctButton.layer.borderWidth = 1.5
        createAcctButton.layer.borderColor = UIColor.white.cgColor
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
    }
    
}
