//
//  CameraViewController.swift
//  Insta
//
//  Created by Luis Puentes on 10/25/18.
//  Copyright © 2018 LuisPuentes. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import JGProgressHUD

class CameraViewController: UIViewController {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var clearButton: UIBarButtonItem!
    
    let progressHUD = JGProgressHUD(style: .dark)
    let errorHUD = JGProgressHUD(style: .dark)
    let successHUD = JGProgressHUD(style: .dark)
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handlePostImage))
        postImageView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        handlePost()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func handlePostImage() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    func handlePost() {
        if selectedImage != nil {
            clearButton.isEnabled = true
            postButton.isEnabled = true
            postButton.backgroundColor = UIColor(red: 86/255, green: 86/255, blue: 88/255, alpha: 1)
        } else {
            clearButton.isEnabled = false
            postButton.isEnabled = false
            postButton.backgroundColor = .lightGray
        }
    }
    
    @objc func switchBackToHomeView() {
        tabBarController?.selectedIndex = 0
    }
    
    func clear() {
        postImageView.image = #imageLiteral(resourceName: "Placeholder-image")
        selectedImage = nil
        captionTextView.text = ""
    }
    
    func sendImageDataToDatabase(postImageURL: String) {
        let ref = Database.database().reference()
        let postReference = ref.child("posts")
        if let postID = postReference.childByAutoId().key {
            let newPostReference = postReference.child(postID)
            newPostReference.setValue(["caption": captionTextView.text!,"postImageURL": postImageURL]) { (error, ref) in
                if error != nil {
                    self.progressHUD.dismiss()
                    
                    self.errorHUD.textLabel.text = "\(error)"
                    self.errorHUD.tintColor = .red
                    self.errorHUD.indicatorView = JGProgressHUDErrorIndicatorView()
                    self.errorHUD.show(in: self.view)
                    self.errorHUD.dismiss(afterDelay: 3.0)
                    return
                }
                self.progressHUD.dismiss()
                
                self.successHUD.textLabel.text = "Success"
                self.successHUD.tintColor = .green
                self.successHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.successHUD.show(in: self.view)
                self.successHUD.dismiss(afterDelay: 3.0)
                self.clear()
            }
        }
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        clear()
        handlePost()
    }
    
    @IBAction func postButtonTapped(_ sender: Any) {
        view.endEditing(true)
        progressHUD.textLabel.text = "Loading..."
        progressHUD.show(in: self.view)
        if let profileImage = self.selectedImage, let imageData = profileImage.jpegData(compressionQuality: 0.1) {
            let imageID = UUID().uuidString
            let storageRef = Storage.storage().reference(forURL: FirebaseReferences.rootStorageReference).child("posts").child(imageID)
            storageRef.putData(imageData, metadata: nil, completion: { (metaData, error) in
                if error != nil {
                    self.errorHUD.textLabel.text = "\(error)"
                    self.errorHUD.tintColor = .red
                    self.errorHUD.indicatorView = JGProgressHUDErrorIndicatorView()
                    self.errorHUD.show(in: self.view)
                    self.errorHUD.dismiss(afterDelay: 3.0)
                    return
                }
                storageRef.downloadURL(completion: { (url, error) in
                    if let postImageImageURL = url?.absoluteString {
                        self.sendImageDataToDatabase(postImageURL: postImageImageURL)
                        Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(self.switchBackToHomeView), userInfo: nil, repeats: false)
                    }
                })
            })
        } else {
            errorHUD.textLabel.text = "Must add an image to post"
            errorHUD.tintColor = .red
            errorHUD.indicatorView = JGProgressHUDErrorIndicatorView()
            errorHUD.show(in: self.view)
            errorHUD.dismiss(afterDelay: 3.0)
        }
    }
}

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            selectedImage = image
            postImageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}
