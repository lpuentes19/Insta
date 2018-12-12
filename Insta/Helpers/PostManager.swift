//
//  PostManager.swift
//  Insta
//
//  Created by Luis Puentes on 12/12/18.
//  Copyright © 2018 LuisPuentes. All rights reserved.
//

import Foundation

class PostManager {
    
    static func observePosts(completion: @escaping (Post) -> Void) {
        FirebaseReferences.postsDatabaseReference.observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let newPost = Post.decodePhotoPost(dict: dict, key: snapshot.key)
                completion(newPost)
            }
        }
    }
}
