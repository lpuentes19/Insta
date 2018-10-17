//
//  LoginViewController.swift
//  Insta
//
//  Created by Luis Puentes on 10/12/18.
//  Copyright © 2018 LuisPuentes. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
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
        animateTitleLabel()
        animateEmailPasswordLines()
        animateButtonBorder()
    }
    
    // Setting up the UI Elements
    func setupUI() {
        
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
        
        loginButton.layer.cornerRadius = 20
        //loginButton.layer.borderWidth = 1.5
        loginButton.layer.borderColor = UIColor.white.cgColor
        
        createAcctButton.layer.cornerRadius = 25
        //createAcctButton.layer.borderWidth = 1.5
        createAcctButton.layer.borderColor = UIColor.white.cgColor
    }
    
    // Animating the title label by shrinking it
    // Then animating it back to it's original size
    func animateTitleLabel() {
        
        titleLabel.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        UIView.animate(withDuration: 4.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 4.0, options: .curveEaseOut, animations: { [weak self] in
            self?.titleLabel.transform = .identity
            }, completion: nil)
    }
    
    // Animating the email and passwrd line
    // By having a sublayer line draw itself
    func animateEmailPasswordLines() {
        
        let emailTextLayer = CALayer()
        emailTextLayer.frame = CGRect(x: 0, y: emailTextField.frame.maxY, width: emailTextField.frame.size.width, height: 0.8)
        // Need to specify in order for animation
        // to move from left to right
        emailTextLayer.position = CGPoint(x: 0, y: emailTextField.frame.maxY)
        emailTextLayer.anchorPoint = CGPoint(x: 0, y: 0)
        
        emailTextLayer.backgroundColor = UIColor.white.cgColor
        emailTextField.layer.addSublayer(emailTextLayer)
        
        let passwordTextLayer = CALayer()
        passwordTextLayer.frame = CGRect(x: 0, y: emailTextField.frame.maxY, width: passwordTextField.frame.size.width, height: 0.8)
        // Need to specify in order for animation
        // to move from left to right
        passwordTextLayer.position = CGPoint(x: 0, y: emailTextField.frame.maxY)
        passwordTextLayer.anchorPoint = CGPoint(x: 0, y: 0)
        
        passwordTextLayer.backgroundColor = UIColor.white.cgColor
        passwordTextField.layer.addSublayer(passwordTextLayer)
        
        let lineAnimation = CABasicAnimation(keyPath: "bounds.size.width")
        lineAnimation.fromValue = 0
        lineAnimation.toValue = emailTextField.bounds.size.width
        lineAnimation.duration = 2.5
        emailTextLayer.add(lineAnimation, forKey: "Email Line Animation")
        passwordTextLayer.add(lineAnimation, forKey: "Password Line Animation")
    }
    
    // Animate the borders for each button
    // To fully circulate around the button
    func animateButtonBorder() {
        let loginBorder = CAShapeLayer()
        let createAcctBorder = CAShapeLayer()
        
        // Creating paths around the buttons bounds.origin
        let loginPath = UIBezierPath(roundedRect: CGRect(origin: loginButton.bounds.origin, size: loginButton.bounds.size), cornerRadius: 20)
        let createAcctPath = UIBezierPath(roundedRect: CGRect(origin: createAcctButton.bounds.origin, size: createAcctButton.bounds.size), cornerRadius: 25)
        
        // Setting the CAShapeLayer's path to the buttons bounds.origin
        loginBorder.path = loginPath.cgPath
        loginBorder.strokeColor = UIColor.white.cgColor
        loginBorder.fillColor = UIColor.clear.cgColor
        loginBorder.lineWidth = 1.5
        loginBorder.lineCap = CAShapeLayerLineCap.round
        loginButton.layer.addSublayer(loginBorder)
        
        createAcctBorder.path = createAcctPath.cgPath
        createAcctBorder.strokeColor = UIColor.white.cgColor
        createAcctBorder.fillColor = UIColor.clear.cgColor
        createAcctBorder.lineWidth = 1.5
        createAcctBorder.lineCap = CAShapeLayerLineCap.round
        createAcctButton.layer.addSublayer(createAcctBorder)
        
        let lineAnimation = CABasicAnimation(keyPath: "strokeEnd")
        lineAnimation.fromValue = 0
        lineAnimation.toValue = 1
        lineAnimation.duration = 2.5
        loginBorder.add(lineAnimation, forKey: "Login Button Animation")
        createAcctBorder.add(lineAnimation, forKey: "Password Button Animation")
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
    }
    
}
