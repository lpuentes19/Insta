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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        
        let emailTextLayer = CALayer()
        emailTextLayer.frame = CGRect(x: 0, y: emailTextField.frame.maxY, width: emailTextField.frame.size.width, height: 0.8)
        emailTextLayer.backgroundColor = UIColor.white.cgColor
        
        let passwordTextLayer = CALayer()
        passwordTextLayer.frame = CGRect(x: 0, y: emailTextField.frame.maxY, width: passwordTextField.frame.size.width, height: 0.8)
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
        
        loginButton.layer.cornerRadius = 20
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.white.cgColor
        
        createAcctButton.layer.cornerRadius = 25
        createAcctButton.layer.borderWidth = 1
        createAcctButton.layer.borderColor = UIColor.white.cgColor
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
    }
    
}
