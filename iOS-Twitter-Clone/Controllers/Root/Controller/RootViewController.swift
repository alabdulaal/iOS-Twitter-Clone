//
//  RootViewController.swift
//  iOS-Twitter-Automation
//
//  Created by ahmed on 2/3/19.
//  Copyright © 2019 com.ahmed. All rights reserved.
//

import UIKit
import Firebase
import TwitterKit

class RootViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        checkIfUserIsLoggedIn()
        view.backgroundColor = UIColor.white
    }

    
    func checkIfUserIsLoggedIn(){
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil && TWTRTwitter.sharedInstance().sessionStore.hasLoggedInUsers() {
                self.loggedIn()
            } else{
                self.notLoggedIn()
            }
        }
    }
    
    fileprivate func loggedIn(){
        let vc = BaseMenuController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    fileprivate func notLoggedIn(){
        let vc = TwitterLoginViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }

    


}
