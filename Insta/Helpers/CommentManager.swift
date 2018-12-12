//
//  CommentManager.swift
//  Insta
//
//  Created by Luis Puentes on 12/12/18.
//  Copyright © 2018 LuisPuentes. All rights reserved.
//

import Foundation

class CommentManager {
    
    static func observeComments(withPostID id: String, completion: @escaping (Comment) -> Void) {
        FirebaseReferences.commentsDatabaseReference.child(id).observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let newComment = Comment.decodeComment(dict: dict)
                completion(newComment)
            }
        }
    }
}
