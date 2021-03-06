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
    
    static var currentUser = Auth.auth().currentUser
    
    static func signOut() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
    }
    
    static func signInWith(email: String, password: String, onError: @escaping (String) -> Void, onSuccess: @escaping () -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            onSuccess()
        })
    }
    
    static func createAccountWith(username: String, email: String, password: String, imageData: Data, onError: @escaping (String) -> Void, onSuccess: @escaping () -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user: AuthDataResult?, error: Error?) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            guard let uid = user?.user.uid else { return }
            let storageRef = FirebaseReferences.rootStorageReference.child("profile_image").child(uid)
            storageRef.putData(imageData, metadata: nil, completion: { (metaData, error) in
                if error != nil {
                    onError(error!.localizedDescription)
                    return
                }
                storageRef.downloadURL(completion: { (url, error) in
                    let profileImageURL = url?.absoluteString
                    self.setupUserInformation(profileImageURL: profileImageURL!, username: username, email: email, password: password, uid: uid, onSuccess: onSuccess)
                })
            })
        })
    }
    
    static func setupUserInformation(profileImageURL: String, username: String, email: String, password: String, uid: String, onSuccess: @escaping () -> Void) {
        let userReference = FirebaseReferences.usersDatabaseReference
        let newUserReference = userReference.child(uid)
        newUserReference.setValue(["username": username, "email": email, "profileImage": profileImageURL])
        
        onSuccess()
    }
}
