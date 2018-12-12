//
//  CommentViewController.swift
//  Insta
//
//  Created by Luis Puentes on 11/28/18.
//  Copyright © 2018 LuisPuentes. All rights reserved.
//

import UIKit
import JGProgressHUD

class CommentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var bottomCommentViewConstraint: NSLayoutConstraint!
    
    var comments = [Comment]()
    var users = [User]()
    var postID: String?
    
    let errorHUD = JGProgressHUD(style: .dark)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        
        handleTextField()
        loadComments()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    func loadComments() {
        guard let key = postID else { return }
        let postCommentRef = FirebaseReferences.postCommentsDatabaseReference.child(key)
        postCommentRef.observe(.childAdded, with: { (snapshot) in
            
            CommentManager.observeComments(withPostID: snapshot.key, completion: { (comment) in
                self.fetchUser(uid: comment.uid!, completion: {
                    self.comments.append(comment)
                    self.tableView.reloadData()
                })
            })
        })
    }
    
    func fetchUser(uid: String, completion: @escaping () -> Void) {
        UserManager.observerUser(withID: uid) { (user) in
            self.users.append(user)
            completion()
        }
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
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue {
            UIView.animate(withDuration: 0.3) {
                self.bottomCommentViewConstraint.constant = -(keyboardFrame.height)
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.bottomCommentViewConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func clear() {
        commentTextField.text = ""
        sendButton.isEnabled = false
        sendButton.setTitleColor(UIColor.lightText, for: .normal)
    }
    
    // MARK: - TableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentTableViewCell
        let comment = comments[indexPath.row]
        let user = users[indexPath.row]
    
        cell.comment = comment
        cell.user = user
        
        return cell
    }
    
    // MARK: - TableViewDelegateMethods
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
    }
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        let commentReference = FirebaseReferences.commentsDatabaseReference
        if let commentID = commentReference.childByAutoId().key {
            let newCommentReference = commentReference.child(commentID)
            guard let currentUser = AuthManager.currentUser else { return }
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
                guard let key = self.postID else { return }
                let postCommentRef = FirebaseReferences.postCommentsDatabaseReference.child(key).child(commentID)
                postCommentRef.setValue(true, withCompletionBlock: { (error, ref) in
                    if error != nil {
                        self.errorHUD.textLabel.text = "\(error!.localizedDescription)"
                        self.errorHUD.tintColor = .red
                        self.errorHUD.indicatorView = JGProgressHUDErrorIndicatorView()
                        self.errorHUD.show(in: self.view)
                        self.errorHUD.dismiss(afterDelay: 3.0)
                        return
                    }
                    self.clear()
                    self.view.endEditing(true)
                })
            }
        }
    }
}
