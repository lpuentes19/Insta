//
//  CameraViewController.swift
//  Insta
//
//  Created by Luis Puentes on 10/25/18.
//  Copyright © 2018 LuisPuentes. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var postButton: UIButton!
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handlePostImage))
        postImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handlePostImage() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func postButtonTapped(_ sender: Any) {
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
