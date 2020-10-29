//
//  MainTableViewController.swift
//  iOS-Twitter-Automation
//
//  Created by ahmed on 2/3/19.
//  Copyright © 2019 com.ahmed. All rights reserved.
//

import UIKit
import Firebase
import TwitterKit
import SDWebImage
import Alamofire
import AlamofireImage

protocol MenuDelegate {
    func showMenu()
}

class MainTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var user: TwitterUser?
    var menuDelegte: MenuDelegate?
    
    private let cellId = "MainCellId"
    private let tableView: UITableView = UITableView()
    let optionText = ["Followers", "Non-Follow back", "Trending tags", "Favorites"]
    let imgArray: [UIImage] = [#imageLiteral(resourceName: "user"), #imageLiteral(resourceName: "secret-agent"), #imageLiteral(resourceName: "icon"), #imageLiteral(resourceName: "like")]
    let downloader = ImageDownloader()

    let profileImage: UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSetup()
        setupTabbarItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUserProfile()
    }
    
    @objc func showMenu(){
        NotificationCenter.default.post(name: Notification.Name(rawValue: "openMenu"), object: nil)
    }
    
    fileprivate func getUserProfile(){
        TwitterAPI.shared.getUserInformation() { (userInfo, err) in
            if let err = err {
                print(err)
            }
            self.user = userInfo
            self.circualrNavBarButton()
        }
    }
    
    
    fileprivate func setupTabbarItem(){

        navigationController?.navigationBar.barTintColor = UIColor(red:0.22, green:0.63, blue:0.95, alpha:1.0)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        navigationItem.rightBarButtonItem?.tintColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.title = "Home"
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.backgroundColor = UIColor(red:0.22, green:0.63, blue:0.95, alpha:1.0)
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        }
    }
    
    fileprivate func circualrNavBarButton(){
        guard let user = user else {return}
        let profilePictureUrl = URL(string: user.profilePictureUrl)
        let urlRequest = URLRequest(url: profilePictureUrl!)
        
        let customView = UIButton(type: .custom)
        customView.addTarget(self, action: #selector(showMenu), for: .touchUpInside)
        customView.imageView?.contentMode = .scaleAspectFit
        customView.layer.cornerRadius = 16
        customView.clipsToBounds = true
        customView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        customView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        let barButtonItem = UIBarButtonItem(customView: customView)
        navigationItem.leftBarButtonItem = barButtonItem
        
        downloader.download(urlRequest) { response in
            if let image = response.result.value {
                customView.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
    }
    
    fileprivate func tableViewSetup(){
        
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.backgroundColor = UIColor(red:0.08, green:0.13, blue:0.16, alpha:1.0)
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    
    @objc func logout(){
        try! Auth.auth().signOut()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MainTableViewCell
        cell.optionLabel.text = optionText[indexPath.row]
        cell.imgView.image = imgArray[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionText.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = FollowersViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = NonFollowBackViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = TrendsViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = FavoritesViewController()
            navigationController?.pushViewController(vc, animated: true)
        default:
            fatalError()
        }

    }
    
}



