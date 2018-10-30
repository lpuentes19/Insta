//
//  CreateAcctViewController.swift
//  Insta
//
//  Created by Luis Puentes on 10/19/18.
//  Copyright © 2018 LuisPuentes. All rights reserved.
//

import UIKit
import FirebaseAuth

class CreateAcctViewController: UIViewController {

    @IBOutlet weak var placeholderImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
//        Timer.scheduledTimer(timeInterval: 0.30, target: self, selector: #selector(animateTextFieldLayer), userInfo: nil, repeats: false)
//        Timer.scheduledTimer(timeInterval: 0.30, target: self, selector: #selector(animateButtonBorder), userInfo: nil, repeats: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        animateTextFieldLayer()
        animateButtonBorder()
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
        
        signUpButton.layer.cornerRadius = 20
        signUpButton.layer.borderColor = UIColor.white.cgColor
    }
    
    // Animating the email and passwrd line
    // By having a sublayer line draw itself
    func animateTextFieldLayer() {
        let usernameLayer = CALayer()
        
        usernameLayer.frame = CGRect(x: 0, y: usernameTextField.frame.maxY, width: usernameTextField.frame.size.width, height: 0.8)
        
        usernameLayer.position = CGPoint(x: 0, y: usernameTextField.bounds.maxY)
        usernameLayer.anchorPoint = CGPoint(x: 0, y: 0)
        
        usernameLayer.backgroundColor = UIColor.white.cgColor
        usernameTextField.layer.addSublayer(usernameLayer)
        
        let emailLayer = CALayer()
        
        emailLayer.frame = CGRect(x: 0, y: emailTextField.frame.maxY, width: emailTextField.frame.size.width, height: 0.8)
        
        emailLayer.position = CGPoint(x: 0, y: emailTextField.bounds.maxY)
        emailLayer.anchorPoint = CGPoint(x: 0, y: 0)
        
        emailLayer.backgroundColor = UIColor.white.cgColor
        emailTextField.layer.addSublayer(emailLayer)
        
        let passwordLayer = CALayer()
        
        passwordLayer.frame = CGRect(x: 0, y: passwordTextField.frame.maxY, width: passwordTextField.frame.size.width, height: 0.8)
        
        passwordLayer.position = CGPoint(x: 0, y: passwordTextField.bounds.maxY)
        passwordLayer.anchorPoint = CGPoint(x: 0, y: 0)
        
        passwordLayer.backgroundColor = UIColor.white.cgColor
        passwordTextField.layer.addSublayer(passwordLayer)
        
        let lineAnimation = CABasicAnimation(keyPath: "bounds.size.width")
        lineAnimation.fromValue = 0
        lineAnimation.toValue = self.usernameTextField.bounds.size.width
        lineAnimation.duration = 2.5
        
        usernameLayer.add(lineAnimation, forKey: "Username Line Animation")
        emailLayer.add(lineAnimation, forKey: "Email Line Animation")
        passwordLayer.add(lineAnimation, forKey: "Password Line Animation")
    }
    
    // Animate the borders for each button
    // To fully circulate around the button
    func animateButtonBorder() {
        let borderLayer = CAShapeLayer()
    
        // Creating paths around the buttons bounds.origin
        let path = UIBezierPath(roundedRect: CGRect(origin: signUpButton.frame.origin, size: signUpButton.frame.size), cornerRadius: 20)
    
        // Setting the CAShapeLayer's path to the buttons bounds.origin
        borderLayer.path = path.cgPath
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = UIColor.white.cgColor
        borderLayer.lineCap = CAShapeLayerLineCap.round
        borderLayer.lineWidth = 1.5
        signUpButton.layer.addSublayer(borderLayer)
        
        let borderAnimation = CABasicAnimation(keyPath: "opacity")
        borderAnimation.fromValue = 0
        borderAnimation.toValue = 1
        borderAnimation.duration = 2.5
        borderLayer.add(borderAnimation, forKey: "Sign Up Animation")
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        
        guard let email = emailTextField.text,
            let password = passwordTextField.text else { return }
        
        if email.isEmpty || password.isEmpty {
            print("Must enter an email.")
            return
        } else if password.count < 6 {
            print("Password must contain at least 6 characters or more.")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user: AuthDataResult?, error: Error?) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            print(user)
        })
    }
    
}
