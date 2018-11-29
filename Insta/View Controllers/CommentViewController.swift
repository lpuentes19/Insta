//
//  CommentViewController.swift
//  Insta
//
//  Created by Luis Puentes on 11/28/18.
//  Copyright © 2018 LuisPuentes. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import JGProgressHUD

class CommentViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    let errorHUD = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        handleTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    func handleTextField() {
        sendButton.isEnabled = false
        sendButton.setTitleColor(UIColor.lightText, for: .normal)
        
        commentTextField.addTarget(self, action: #selector(CommentViewController.textFieldDidChange), for: .editingChanged)
    }
    
    @objc func textFieldDidChange() {
        guard let comment = commentTextField.text, !comment.isEmpty else {
            sendButton.setTitleColor(UIColor.lightText, for: .normal)
            sendButton.isEnabled = false
            
            return
        }
        sendButton.setTitleColor(UIColor.white, for: .normal)
        sendButton.isEnabled = true
    }
    
    func clear() {
        commentTextField.text = ""
        sendButton.isEnabled = false
        sendButton.setTitleColor(UIColor.lightText, for: .normal)
    }
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        let ref = Database.database().reference()
        let commentReference = ref.child("comments")
        if let commentID = commentReference.childByAutoId().key {
            let newCommentReference = commentReference.child(commentID)
            guard let currentUser = Auth.auth().currentUser else { return }
            let currentUserID = currentUser.uid
            newCommentReference.setValue(["uid": currentUserID, "comment": commentTextField.text!]) { (error, ref) in
                if error != nil {
                    self.errorHUD.textLabel.text = "\(error!.localizedDescription)"
                    self.errorHUD.tintColor = .red
                    self.errorHUD.indicatorView = JGProgressHUDErrorIndicatorView()
                    self.errorHUD.show(in: self.view)
                    self.errorHUD.dismiss(afterDelay: 3.0)
                    return
                }
                self.clear()
            }
        }
    }
}
