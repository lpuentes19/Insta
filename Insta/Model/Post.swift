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
    
    static func decodePhotoPost(dict: [String: Any], key: String) -> Post {
        let post = Post()
        
        post.caption = dict["caption"] as? String
        post.imageURLString = dict["postImageURL"] as? String
        post.uid = dict["uid"] as? String
        post.postID = key
        
        return post
    }
}
