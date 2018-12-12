//
//  UserManager.swift
//  Insta
//
//  Created by Luis Puentes on 12/12/18.
//  Copyright © 2018 LuisPuentes. All rights reserved.
//

import Foundation

class UserManager {
    
    static func observerUser(withID uid: String, completion: @escaping (User) -> Void) {
        FirebaseReferences.usersDatabaseReference.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let user = User.decodeUser(dict: dict)
                completion(user)
            }
        }
    }
}
