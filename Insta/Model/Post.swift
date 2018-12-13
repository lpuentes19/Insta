//
//  Post.swift
//  Insta
//
//  Created by Luis Puentes on 11/17/18.
//  Copyright © 2018 LuisPuentes. All rights reserved.
//

import Foundation

class Post {
    var caption: String?
    var imageURLString: String?
    var uid: String?
    var postID: String?
    var isLiked: Bool?
    var likeCount: Int?
    var likes: Dictionary<String, Any>?
    
    static func decodePhotoPost(dict: [String: Any], key: String) -> Post {
        let post = Post()
        
        post.caption = dict["caption"] as? String
        post.imageURLString = dict["postImageURL"] as? String
        post.uid = dict["uid"] as? String
        post.postID = key
        post.likeCount = dict["likeCount"] as? Int
        post.likes = dict["likes"] as? Dictionary<String, Any>
        
        if let currentUserID = AuthManager.currentUser?.uid, let postLikes = post.likes {
            if postLikes[currentUserID] != nil {
                post.isLiked = true
            } else {
                post.isLiked = false
            }
            return post
        }
        return post
    }
}
