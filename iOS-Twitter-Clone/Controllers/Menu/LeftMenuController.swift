//
//  LeftMenuController.swift
//  iOS-Twitter-Automation
//
//  Created by ahmed on 2/11/19.
//  Copyright © 2019 com.ahmed. All rights reserved.
//

import UIKit
import TwitterKit

class LeftMenuController: UITableViewController {
    
    var user: TwitterUser?
    var userStats: UserStats?
    let header = MenuHeaderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        tableviewSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getHeaderData()
    }
    
    let menuItems: [MenuItem] = [
        MenuItem(title: "Profile", image: "person"),
        MenuItem(title: "Lists", image: "lists"),
        MenuItem(title: "Topics", image: "topics"),
        MenuItem(title: "Bookmarks", image: "bookmark"),
        MenuItem(title: "Moments", image: "lightning"),
        MenuItem(title: "Follower requests", image: "follow_arrow_left"),
    ]
    
    fileprivate func tableviewSetup() {
        tableView.allowsSelection = false
        tableView.register(MenuItemCell.self, forCellReuseIdentifier: "MenuItemCell")
        tableView.separatorStyle = .none
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemCell") as! MenuItemCell
        cell.titleLabel.text = menuItems[indexPath.row].title
        cell.iconImageView.image = UIImage(named: menuItems[indexPath.row].image)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let slidingController = UIApplication.shared.keyWindow?.rootViewController as? BaseMenuController
        slidingController?.didSelectMenuItem(indexPath: indexPath)
    }
    
    fileprivate func getHeaderData(){
        guard let twitterSession = TWTRTwitter.sharedInstance().sessionStore.session() else {return}
        TwitterAPI.shared.getUserInformation() { (userInformation, err) in
            if let err = err {
                print(err.localizedDescription)
                return
            }
            guard let userInformation = userInformation else {return}
            TwitterAPI.shared.getUserStat(twitterSession: twitterSession, userId: twitterSession.userID, screenName: userInformation.screenName, name: userInformation.name) { (userStats, err) in
                if let err = err {
                    print(err.localizedDescription)
                    return
                }
                guard let userStats = userStats else {return}
                self.userStats = userStats
                self.user = userInformation
                self.header.userStat = userStats
                self.header.profileImageView.sd_setImage(with: URL(string: userInformation.profilePictureUrl), completed: nil)
                self.header.nameLabel.text = userInformation.name
                self.header.usernameLabel.text = "@" + userInformation.screenName
            }
        }
    }

}
