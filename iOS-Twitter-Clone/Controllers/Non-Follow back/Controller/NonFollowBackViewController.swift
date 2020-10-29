//
//  NonFollowBackViewController.swift
//  iOS-Twitter-Automation
//
//  Created by Ahmed Al Abdulaal on 3/23/19.
//  Copyright © 2019 com.ahmed. All rights reserved.
//

import UIKit
import TwitterKit

class NonFollowBackViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    fileprivate let cellId = "NonFollowingCellID"
    var followers: [User] = []
    let tableView =  UITableView()
    let dispatchGroup = DispatchGroup()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarSetup()
        tableViewSetup()
        getData()
    }
    
    private func tableViewSetup(){
        tableView.register(NonFollowBackTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = UIColor.white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red:0.08, green:0.13, blue:0.16, alpha:1.0)
        tableView.separatorColor = UIColor(white: 1, alpha: 0.1)
        view.addSubview(tableView)
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = UIColor(red:0.08, green:0.13, blue:0.16, alpha:1.0)
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func navigationBarSetup() {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.prefersLargeTitles = true
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.title = "Non-Follow back"
    }
    
    func getData(){
        ActivityIndicator.shared.showLoaderView()
        dispatchGroup.enter()
        DispatchQueue.main.async {
            TwitterAPI.shared.getFriends() { (users, err) in
                if let err = err {
                    print(err.localizedDescription)
                    ActivityIndicator.shared.hideLoaderView()
                }
                guard let users = users else {return}
                for user in users {
                    if (user.isFollowingYou) {
                        self.followers.append(user)
                    }
                }
                self.dispatchGroup.notify(queue: .main) {
                    print("Reloading data..")
                    ActivityIndicator.shared.hideLoaderView()
                    self.tableView.reloadData()
                }
            }
            self.dispatchGroup.leave()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! NonFollowBackTableViewCell
        let friends = followers[indexPath.row]
        cell.nameLabel.text = friends.name
        cell.screenNameLabel.text = "@" + friends.screenName
        cell.desc.text = friends.description
        cell.imgView.sd_setImage(with: URL(string: friends.profileImg.replacingOccurrences(of: "_normal", with: "")))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let approximateWidthOfBioTextView = view.frame.width - 20
        let size = CGSize(width: approximateWidthOfBioTextView, height: 1000)
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
        
        let estimatedFrame = NSString(string: followers[indexPath.row].description).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        return estimatedFrame.height + 80
    }

    


}
