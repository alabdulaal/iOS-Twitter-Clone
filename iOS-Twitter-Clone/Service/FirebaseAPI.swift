//
//  FirebaseAPI.swift
//  iOS-Twitter-Automation
//
//  Created by ahmed on 2/3/19.
//  Copyright © 2019 com.ahmed. All rights reserved.
//

import UIKit
import Firebase
import TwitterKit


protocol finishedCreatingAprofile {
    func didFinishCreatingProfile()
}

enum DataError: Error {
    case errorConvertingImageToData
    case errorUnwrappingDownloadURL
    case errorUnwrappingDictionary
}


enum FirebaseAuthError: Error {
    case errorCreatingUser(Error)
    case errorRetrievingUUID
}

enum FirebaseDatabaseError: Error {
    case errorCreatingUserDetails(Error)
    case errorRetrievingUserDetails(Error)
    case errorRetrievingListOfUsers(Error)
    case errorRetrievingListOfFollowing
    case errorRetrievingUserPosts(Error)
    case errorUpdatingUserPostDetails(Error)
}

class FirebaseAPI {
    
    private init(){}
    static let shared = FirebaseAPI()
    
    let usersRef = Database.database().reference().child("users")
    var delegate: finishedCreatingAprofile!


    func currentUserUID() -> String? {
        return Auth.auth().currentUser?.uid
    }
    
    func getUserProfile(completion: @escaping (TwitterUser?, Error?) -> Void){
        guard let uid = currentUserUID() else {return}
        let currentUserRef = usersRef.child(uid)
        
        currentUserRef.observeSingleEvent(of: .value) { (snapshot) in
            if !snapshot.exists() {
                completion(nil, DataError.errorUnwrappingDictionary)
                return
            }
            
            guard let name = snapshot.childSnapshot(forPath: "name").value as? String,
                  let screenName = snapshot.childSnapshot(forPath: "screenName").value as? String,
                  let profileUrl = snapshot.childSnapshot(forPath: "profileUrl").value as? String,
                  let userId = snapshot.childSnapshot(forPath: "userId").value as? String,
                  let profilePictureUrl = snapshot.childSnapshot(forPath: "profileImgUrl").value as? String,
                  let token = snapshot.childSnapshot(forPath: "token").value as? String,
                  let tokenSecret = snapshot.childSnapshot(forPath: "tokenSecret").value as? String
            else {return}
            
            let userProfile = TwitterUser(name: name, screenName: screenName, profileUrl: profileUrl, userId: userId, profilePictureUrl: profilePictureUrl, token: token, tokenSecret: tokenSecret)
            
            completion(userProfile, nil)
        }
    }

    func signTwitterUserToFirebase(TwitterSession: TWTRSession){
        let credentials = TwitterAuthProvider.credential(withToken: TwitterSession.authToken, secret: TwitterSession.authTokenSecret)
        Auth.auth().signInAndRetrieveData(with: credentials) { (user, error) in
            if let error = error{
                print(error)
                return
            }
        }
    }
    
}
