//
//  FirebaseReferences.swift
//  Insta
//
//  Created by Luis Puentes on 11/13/18.
//  Copyright © 2018 LuisPuentes. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

struct FirebaseReferences {
    static var usersDatabaseReference = Database.database().reference().child("users")
    static var postsDatabaseReference = Database.database().reference().child("posts")
    static var commentsDatabaseReference = Database.database().reference().child("comments")
    static var postCommentsDatabaseReference = Database.database().reference().child("post-comments")
    static var rootStorageReference = Storage.storage().reference(forURL: "gs://insta-f769f.appspot.com")
}
