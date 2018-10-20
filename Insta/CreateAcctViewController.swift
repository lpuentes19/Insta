//
//  CreateAcctViewController.swift
//  Insta
//
//  Created by Luis Puentes on 10/19/18.
//  Copyright © 2018 LuisPuentes. All rights reserved.
//

import UIKit

class CreateAcctViewController: UIViewController {

    @IBOutlet weak var placeholderImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI() {
        placeholderImageView.layer.cornerRadius = 60
        placeholderImageView.layer.borderWidth = 1
        placeholderImageView.layer.borderColor = UIColor.black.cgColor
        
        usernameTextField.backgroundColor = .clear
        usernameTextField.textColor = .white
        usernameTextField.tintColor = .white
        usernameTextField.borderStyle = .none
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        emailTextField.backgroundColor = .clear
        emailTextField.textColor = .white
        emailTextField.tintColor = .white
        emailTextField.borderStyle = .none
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        passwordTextField.backgroundColor = .clear
        passwordTextField.textColor = .white
        passwordTextField.tintColor = .white
        passwordTextField.borderStyle = .none
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
    }
    
}
