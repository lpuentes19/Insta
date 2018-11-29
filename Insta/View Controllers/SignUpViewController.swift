//
//  CreateAcctViewController.swift
//  Insta
//
//  Created by Luis Puentes on 10/19/18.
//  Copyright © 2018 LuisPuentes. All rights reserved.
//

import UIKit
import JGProgressHUD

class SignUpViewController: UIViewController {

    @IBOutlet weak var placeholderImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    var selectedImage: UIImage?
    
    let progressHUD = JGProgressHUD(style: .dark)
    let errorHUD = JGProgressHUD(style: .dark)
    let successHUD = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        handleTextField()
        
//        Timer.scheduledTimer(timeInterval: 0.30, target: self, selector: #selector(animateTextFieldLayer), userInfo: nil, repeats: false)
//        Timer.scheduledTimer(timeInterval: 0.30, target: self, selector: #selector(animateButtonBorder), userInfo: nil, repeats: false)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Calling this on the main thread so that when
        // You switch back from the imagePickerController
        // It does not animate two separate lines
        DispatchQueue.main.async {
            self.animateTextFieldLayer()
            self.animateButtonBorder()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // Configuring the UI elements
    func setupUI() {
        placeholderImageView.layer.cornerRadius = 60
        placeholderImageView.layer.borderWidth = 1
        placeholderImageView.layer.borderColor = UIColor.black.cgColor
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleProfileImage))
        placeholderImageView.addGestureRecognizer(tapGesture)
        
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
        
        usernameLayer.position = CGPoint(x: 0, y: usernameTextField.bounds.maxY + 12)
        usernameLayer.anchorPoint = CGPoint(x: 0, y: 0)
        
        usernameLayer.backgroundColor = UIColor.white.cgColor
        usernameTextField.layer.addSublayer(usernameLayer)
        
        let emailLayer = CALayer()
        
        emailLayer.frame = CGRect(x: 0, y: emailTextField.frame.maxY, width: emailTextField.frame.size.width, height: 0.8)
        
        emailLayer.position = CGPoint(x: 0, y: emailTextField.bounds.maxY + 12)
        emailLayer.anchorPoint = CGPoint(x: 0, y: 0)
        
        emailLayer.backgroundColor = UIColor.white.cgColor
        emailTextField.layer.addSublayer(emailLayer)
        
        let passwordLayer = CALayer()
        
        passwordLayer.frame = CGRect(x: 0, y: passwordTextField.frame.maxY, width: passwordTextField.frame.size.width, height: 0.8)
        
        passwordLayer.position = CGPoint(x: 0, y: passwordTextField.bounds.maxY + 12)
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
    
    func handleTextField() {
        signUpButton.setTitleColor(UIColor.lightText, for: .normal)
        signUpButton.isEnabled = false
        
        usernameTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: .editingChanged)
    }
    
    @objc func textFieldDidChange() {
        guard let username = usernameTextField.text, !username.isEmpty,
            let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty else {
                
                signUpButton.setTitleColor(UIColor.lightText, for: .normal)
                signUpButton.isEnabled = false
                return
        }
        signUpButton.setTitleColor(UIColor.white, for: .normal)
        signUpButton.isEnabled = true
    }
    
    @objc func handleProfileImage() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    @objc func signInComplete() {
        performSegue(withIdentifier: "SignUpComplete", sender: self)
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        view.endEditing(true)
        
        guard let username = usernameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text else { return }
        
        progressHUD.textLabel.text = "Loading..."
        progressHUD.show(in: self.view)
        
        if let profileImage = self.selectedImage, let imageData = profileImage.jpegData(compressionQuality: 0.1) {
            AuthManager.createAccountWith(username: username, email: email, password: password, imageData: imageData, onError: { (error) in
                self.progressHUD.dismiss()
                
                self.errorHUD.textLabel.text = "\(error)"
                self.errorHUD.tintColor = .red
                self.errorHUD.indicatorView = JGProgressHUDErrorIndicatorView()
                self.errorHUD.show(in: self.view)
                self.errorHUD.dismiss(afterDelay: 3.0)
            }, onSuccess: {
                self.progressHUD.dismiss()
                
                self.successHUD.textLabel.text = "Sign Up Complete"
                self.successHUD.tintColor = .green
                self.successHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.successHUD.show(in: self.view)
                self.successHUD.dismiss(afterDelay: 2.0)
                
                // Put the segue in a Timer to give the successHUD view time to show
                Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(SignUpViewController.signInComplete), userInfo: nil, repeats: false)
            })
        } else {
            self.progressHUD.dismiss()
            
            self.errorHUD.textLabel.text = "Must add a profile image"
            self.errorHUD.tintColor = .red
            self.errorHUD.indicatorView = JGProgressHUDErrorIndicatorView()
            self.errorHUD.show(in: self.view)
            self.errorHUD.dismiss(afterDelay: 3.0)
        }
    }
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            selectedImage = image
            placeholderImageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}
