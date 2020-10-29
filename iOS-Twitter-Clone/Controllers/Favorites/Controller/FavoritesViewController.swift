//
//  FavoritesViewController.swift
//  iOS-Twitter-Automation
//
//  Created by Ahmed Al Abdulaal on 4/25/19.
//  Copyright © 2019 com.ahmed. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let tableView = UITableView()
    let dispatchGroup = DispatchGroup()
    var favorites: [Favorites] = [] 
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red:0.08, green:0.13, blue:0.16, alpha:1.0)
        setUpNavBar()
        setUpTableView()
        getData()
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesCell", for: indexPath) as! FavoritesTableViewCell
        let fav = favorites[indexPath.row]
        cell.nameLabel.text = fav.user.name
        cell.screenNameLabel.text = fav.user.screenName
        cell.imgView.sd_setImage(with: URL(string: fav.user.profileImg.replacingOccurrences(of: "_normal", with: "")))
        cell.tweetText.text = fav.text
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let approximateWidthOfBioTextView = view.frame.width - 20
        let size = CGSize(width: approximateWidthOfBioTextView, height: 1000)
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]
        let estimatedFrame = NSString(string: favorites[indexPath.row].text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        return estimatedFrame.height + 120
    }
    
    fileprivate func getData(){
        ActivityIndicator.shared.showLoaderView()
        dispatchGroup.enter()
        DispatchQueue.main.async {
            TwitterAPI.shared.getUserInformation(completion: { (user, err) in
                if let err = err {
                    print(err)
                    return
                }
                guard let user = user else {return}
                TwitterAPI.shared.getFavorites(name: user.name, completion: { (res) in
                    switch res {
                    case .failure(let err):
                        print(err)
                    case .success(let favorites):
                        self.favorites = favorites
                        self.dispatchGroup.notify(queue: .main) {
                            ActivityIndicator.shared.hideLoaderView()
                            self.tableView.reloadData()
                        }
                    }
                })
            })
            self.dispatchGroup.leave()
        }
    }
    
    fileprivate func setUpTableView() {
        tableView.allowsSelection = false
        tableView.register(FavoritesTableViewCell.self, forCellReuseIdentifier: "FavoritesCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = UIColor.white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red:0.08, green:0.13, blue:0.16, alpha:1.0)
        tableView.separatorColor = UIColor(white: 1, alpha: 0.1)
        view.addSubview(tableView)
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = UIColor(red:0.08, green:0.13, blue:0.16, alpha:1.0)
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    fileprivate func setUpNavBar() {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.prefersLargeTitles = true
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.title = "Favorites"
    }

}
