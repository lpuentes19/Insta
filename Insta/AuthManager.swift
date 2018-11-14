//
//  AuthManager.swift
//  Insta
//
//  Created by Luis Puentes on 11/13/18.
//  Copyright © 2018 LuisPuentes. All rights reserved.
//

import Foundation
import FirebaseAuth

class AuthManager {
    
    static func signInWith(email: String, password: String, onError: @escaping (String) -> Void, onSuccess: @escaping () -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            onSuccess()
        })
    }
}
