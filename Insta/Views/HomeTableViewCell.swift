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
    
    var post: Post? {
        didSet {
            updateViews()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImageView.layer.cornerRadius = 16
        profileImageView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateViews() {
        guard let post = post else { return }
        captionLabel.text = post.caption
        if let imageURLString = post.imageURLString {
            let imageURL = URL(string: imageURLString)
            postImageView.sd_setImage(with: imageURL, completed: nil)
        }
        setupUserInfo()
    }
    
    func setupUserInfo() {
        guard let uid = post?.uid else { return }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let user = User.decodeUser(dict: dict)
                self.profileNameLabel.text = user.username
                if let profileImage = user.profileImage {
                    let profileImageURL = URL(string: profileImage)
                    self.profileImageView.sd_setImage(with: profileImageURL, completed: nil)
                }
            }
        }
    }
    
    @IBAction func likeButtonTapped(_ sender: Any) {
    }
    @IBAction func commentButtonTapped(_ sender: Any) {
    }
    @IBAction func shareButtonTapped(_ sender: Any) {
    }
}
