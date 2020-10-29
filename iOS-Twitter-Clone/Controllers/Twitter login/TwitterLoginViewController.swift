//
//  ViewController.swift
//  iOS-Twitter-Automation
//
//  Created by ahmed on 2/1/19.
//  Copyright © 2019 com.ahmed. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import TwitterKit

class TwitterLoginViewController: UIViewController {
    
    var twitterSession: TWTRSession?
    var ref: DatabaseReference!
    var userName = String()
    var uid = String()
    
    let twitterLoginButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.backgroundColor = UIColor(red:0.22, green:0.63, blue:0.95, alpha:1.0)
        bt.setTitle("Login with Twitter", for: .normal)
        bt.tintColor = .white
        bt.addTarget(self, action: #selector(handleTwitterLogin), for: .touchUpInside)
        bt.layer.cornerRadius = 20
        bt.clipsToBounds = true
        return bt
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    func setUpView(){
        view.backgroundColor = UIColor.white
        
        view.addSubview(twitterLoginButton)
        twitterLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        twitterLoginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        twitterLoginButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20).isActive = true
        twitterLoginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc func handleTwitterLogin(){
        let mainVC = BaseMenuController()
        mainVC.modalPresentationStyle = .fullScreen
        TwitterAPI.shared.logInWithTwitter(vc: self) {
            self.present(mainVC, animated: true, completion: nil)
        }
    }
    


}




