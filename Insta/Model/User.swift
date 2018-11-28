//
//  User.swift
//  Insta
//
//  Created by Luis Puentes on 11/27/18.
//  Copyright © 2018 LuisPuentes. All rights reserved.
//

import Foundation

class User {
    
    var email: String?
    var profileImage: String?
    var username: String?
    
    static func decodeUser(dict: [String: Any]) -> User {
        let user = User()
        
        user.email = dict["email"] as? String
        user.profileImage = dict["profileImage"] as? String
        user.username = dict["username"] as? String
        
        return user
    }
}
