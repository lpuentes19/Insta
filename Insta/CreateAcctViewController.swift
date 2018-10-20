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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            animateTextFieldLayer()
    }
    
    // Configuring the UI elements
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
    
    // Animating the email and passwrd line
    // By having a sublayer line draw itself
    @objc func animateTextFieldLayer() {
        let usernameLayer = CALayer()
        
        usernameLayer.frame = CGRect(x: 0, y: self.usernameTextField.frame.maxY, width: self.usernameTextField.frame.size.width, height: 0.8)
        
        usernameLayer.position = CGPoint(x: 0, y: self.usernameTextField.frame.maxY)
        usernameLayer.anchorPoint = CGPoint(x: 0, y: 0)
        
        usernameLayer.backgroundColor = UIColor.white.cgColor
        self.usernameTextField.layer.addSublayer(usernameLayer)
        
        let lineAnimation = CABasicAnimation(keyPath: "bounds.size.width")
        lineAnimation.fromValue = 0
        lineAnimation.toValue = self.usernameTextField.bounds.size.width
        lineAnimation.duration = 2.5
        usernameLayer.add(lineAnimation, forKey: "Username Line Animation")
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
    }
    
}
