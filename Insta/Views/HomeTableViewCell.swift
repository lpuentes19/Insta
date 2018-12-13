//
//  HomeTableViewCell.swift
//  Insta
//
//  Created by Luis Puentes on 11/17/18.
//  Copyright © 2018 LuisPuentes. All rights reserved.
//

import UIKit
import FirebaseDatabase

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    
    var homeViewVC: HomeViewController?
    
    var post: Post? {
        didSet {
            updateViews()
        }
    }
    
    var user: User? {
        didSet {
            setupUserInfo()
        }
    }
    
    var postRef: DatabaseReference?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImageView.layer.cornerRadius = 16
        profileImageView.layer.masksToBounds = true
        
        profileNameLabel.text = ""
        captionLabel.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        profileImageView.image = #imageLiteral(resourceName: "placeholderImg")
    }
    
    func updateViews() {
        guard let post = post else { return }
        
        captionLabel.text = post.caption
        if let imageURLString = post.imageURLString {
            let imageURL = URL(string: imageURLString)
            postImageView.sd_setImage(with: imageURL, completed: nil)
        }
        guard let postID = post.postID else { return }
        updateLike(post: post)
        FirebaseReferences.postsDatabaseReference.child(postID).observe(.childChanged) { (snapshot) in
            if let value = snapshot.value as? Int {
                
                if value == 1 {
                    self.likeCountLabel.text = "\(value) like"
                } else if value > 1 {
                    self.likeCountLabel.text = "\(value) likes"
                } else {
                    self.likeCountLabel.text = "Be the first to like this."
                }
            }
        }
    }
    
    func updateLike(post: Post) {
        let imageName = post.isLiked == nil || !post.isLiked! ? "like": "likeSelected"
        likeButton.setImage(UIImage(named: imageName), for: .normal)
        guard let likeCount = post.likeCount else { return }
        if likeCount == 1 {
            likeCountLabel.text = "\(likeCount) like"
        } else if likeCount > 1 {
            likeCountLabel.text = "\(likeCount) likes"
        } else {
            likeCountLabel.text = "Be the first to like this."
        }
    }
    
    func setupUserInfo() {
        guard let user = user else { return }
        
        self.profileNameLabel.text = user.username
        if let profileImage = user.profileImage {
            let profileImageURL = URL(string: profileImage)
            self.profileImageView.sd_setImage(with: profileImageURL, placeholderImage: #imageLiteral(resourceName: "placeholderImg"))
        }
    }
    
    func incrementLikes(forRef ref: DatabaseReference) {
        ref.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            if var post = currentData.value as? [String : AnyObject], let uid = AuthManager.currentUser?.uid {
                var likes: Dictionary<String, Bool>
                likes = post["likes"] as? [String : Bool] ?? [:]
                var likeCounter = post["likeCounter"] as? Int ?? 0
                // If the current user currently likes the post, unlike
                // Else like the post
                if let _ = likes[uid] {
                    // Unlike the post and remove self from likes
                    likeCounter -= 1
                    likes.removeValue(forKey: uid)
                } else {
                    // Like the post and add self to likes
                    likeCounter += 1
                    likes[uid] = true
                }
                post["likeCounter"] = likeCounter as AnyObject?
                post["likes"] = likes as AnyObject?
                
                // Set value and report transaction success
                currentData.value = post
                
                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let dict = snapshot?.value as? [String: Any] {
                let post = Post.decodePhotoPost(dict: dict, key: snapshot!.key)
                self.updateLike(post: post)
            }
        }
    }
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        guard let postID = post?.postID else { return }
        postRef = FirebaseReferences.postsDatabaseReference.child(postID)
        if let postRef = postRef {
            incrementLikes(forRef: postRef)
        }
    }
    
    @IBAction func commentButtonTapped(_ sender: Any) {
        if let postID = post?.postID, let homeVC = homeViewVC {
            homeVC.performSegue(withIdentifier: "toCommentVC", sender: postID)
        }
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
    }
}
