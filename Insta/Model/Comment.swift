//
//  Comment.swift
//  Insta
//
//  Created by Luis Puentes on 11/29/18.
//  Copyright © 2018 LuisPuentes. All rights reserved.
//

import Foundation

class Comment {
    var commentText: String?
    var uid: String?
    
    static func decodeComment(dict: [String: Any]) -> Comment {
        let comment = Comment()
        
        comment.commentText = dict["comment"] as? String
        comment.uid = dict["uid"] as? String
        
        return comment
    }
}
