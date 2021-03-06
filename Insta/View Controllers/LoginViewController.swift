//
//  LoginViewController.swift
//  Insta
//
//  Created by Luis Puentes on 10/12/18.
//  Copyright © 2018 LuisPuentes. All rights reserved.
//

import UIKit
import JGProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createAcctButton: UIButton!
    
    let progressHUD = JGProgressHUD(style: .dark)
    let errorHUD = JGProgressHUD(style: .dark)
    let successHUD = JGProgressHUD(style: .dark)
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        animateTitleLabel()
        loginButton.isEnabled = false
        handleTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        animateTextFieldLayer()
        animateButtonBorder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Checking to see if the user is still logged in
        if AuthManager.currentUser != nil {
            performSegue(withIdentifier: "SignInComplete", sender: self)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // Configuring up the UI Elements
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
        loginButton.layer.borderColor = UIColor.white.cgColor
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
    func animateTextFieldLayer() {
        
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
        passwordTextLayer.position = CGPoint(x: 0, y: passwordTextField.bounds.maxY)
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
        
        // Creating paths around the buttons bounds.origin
        let loginPath = UIBezierPath(roundedRect: CGRect(origin: loginButton.bounds.origin, size: loginButton.bounds.size), cornerRadius: 20)
        
        // Setting the CAShapeLayer's path to the buttons bounds.origin
        loginBorder.path = loginPath.cgPath
        loginBorder.strokeColor = UIColor.white.cgColor
        loginBorder.fillColor = UIColor.clear.cgColor
        loginBorder.lineWidth = 1.5
        loginBorder.lineCap = CAShapeLayerLineCap.round
        loginButton.layer.addSublayer(loginBorder)
        
        let lineAnimation = CABasicAnimation(keyPath: "opacity")
        lineAnimation.fromValue = 0
        lineAnimation.toValue = 1
        lineAnimation.duration = 2.5
        loginBorder.add(lineAnimation, forKey: "Login Button Animation")
    }
    
    func handleTextField() {
        emailTextField.addTarget(self, action: #selector(LoginViewController.textFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(LoginViewController.textFieldDidChange), for: .editingChanged)
    }
    
    @objc func textFieldDidChange() {
        guard let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty else {
                
                loginButton.setTitleColor(UIColor.lightText, for: .normal)
                loginButton.isEnabled = false
                return
        }
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.isEnabled = true
    }
    
    @objc func signInComplete() {
        performSegue(withIdentifier: "SignInComplete", sender: self)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        view.endEditing(true)
        
        guard let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty else { return }
        
        progressHUD.textLabel.text = "Loading..."
        progressHUD.show(in: self.view)
        
        AuthManager.signInWith(email: email, password: password, onError: { (error) in
            self.progressHUD.dismiss()
            
            self.errorHUD.textLabel.text = "\(error)"
            self.errorHUD.tintColor = .red
            self.errorHUD.indicatorView = JGProgressHUDErrorIndicatorView()
            self.errorHUD.show(in: self.view)
            self.errorHUD.dismiss(afterDelay: 3.0)
        }, onSuccess: {
            self.progressHUD.dismiss()
            
            self.successHUD.textLabel.text = "Success"
            self.successHUD.tintColor = .green
            self.successHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
            self.successHUD.show(in: self.view)
            self.successHUD.dismiss(afterDelay: 2.0)
            
            // Put the segue in a Timer to give the successHUD view time to show
            Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(LoginViewController.signInComplete), userInfo: nil, repeats: false)
        })
    }
}
