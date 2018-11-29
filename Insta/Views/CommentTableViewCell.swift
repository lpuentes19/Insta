//
//  CommentTableViewCell.swift
//  Insta
//
//  Created by Luis Puentes on 11/28/18.
//  Copyright © 2018 LuisPuentes. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var comment: Comment? {
        didSet {
            updateView()
        }
    }
    
    var user: User? {
        didSet {
            setupUserInfo()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.layer.cornerRadius = 16
        profileImageView.layer.masksToBounds = true
        
        commentLabel.text = ""
        usernameLabel.text = ""
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        profileImageView.image = #imageLiteral(resourceName: "placeholderImg")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func updateView() {
        guard let comment = comment else { return }
        
        commentLabel.text = comment.commentText
    }
    
    func setupUserInfo() {
        guard let user = user else { return }
        
        usernameLabel.text = user.username
        if let profileImageURLString = user.profileImage {
            let profileImageURL = URL(string: profileImageURLString)
            profileImageView.sd_setImage(with: profileImageURL, completed: nil)
        }
    }
}
