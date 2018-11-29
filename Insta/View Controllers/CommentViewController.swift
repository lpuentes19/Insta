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

class CommentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    var comments = [Comment]()
    var users = [User]()
    
    let errorHUD = JGProgressHUD(style: .dark)
    let postID = "-LSMpmwvnmmMHPUClQJ0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        
        handleTextField()
        loadComments()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    func loadComments() {
        let postCommentRef = Database.database().reference().child("post-comments").child(self.postID)
        postCommentRef.observe(.childAdded, with: { (snapshot) in
            Database.database().reference().child("comments").child(snapshot.key).observeSingleEvent(of: .value, with: { (snapshotComment) in
                if let dict = snapshotComment.value as? [String: Any] {
                    let newComment = Comment.decodeComment(dict: dict)
                    self.fetchUser(uid: newComment.uid!, completion: {
                        self.comments.append(newComment)
                        self.tableView.reloadData()
                    })
                }
            })
        })
    }
    
    func fetchUser(uid: String, completion: @escaping () -> Void) {
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let user = User.decodeUser(dict: dict)
                self.users.append(user)
                
                completion()
            }
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
                let postCommentRef = Database.database().reference().child("post-comments").child(self.postID).child(commentID)
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
                })
            }
        }
    }
}
