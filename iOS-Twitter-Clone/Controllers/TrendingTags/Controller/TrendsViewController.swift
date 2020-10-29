//
//  TrendsViewController.swift
//  iOS-Twitter-Automation
//
//  Created by Ahmed Al Abdulaal on 3/25/19.
//  Copyright © 2019 com.ahmed. All rights reserved.
//

import UIKit
import CoreLocation
import TwitterKit

class TrendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var trends: [Trend] = []
    let dispatchGroup = DispatchGroup()
    let tableView =  UITableView()
    let cellId = "trendsCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        checkLocationServices()
        showAuthorizationMessage()
        setUpNavBar()
        
        TwitterAPI.shared.getTweet(byTrend: "Greedy") { (res) in
            switch res {
            case .failure(let err):
                print(err)
            case .success(let tweets):
                print("Tweets \(tweets)")
            }
        }
        
    }
    
    // MARK:- tableview delegate, datasource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if trends.count == 0 {
            tableView.separatorStyle = .none
            tableView.backgroundView?.isHidden = false
        } else {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView?.isHidden = true
        }
        return trends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TrendsTableViewCell
        let trend = trends[indexPath.row]
        if trend.name.contains("#") {
            cell.informationLabel.attributedText = setUpAttributedString(withTag: trend.name.replacingOccurrences(of: " ", with: "_"), volume: trend.tweetVolume ?? 0)
        } else {
            cell.informationLabel.attributedText = setUpAttributedString(withTag: "#\(trend.name.replacingOccurrences(of: " ", with: "_"))", volume: trend.tweetVolume ?? 0)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    fileprivate func setUpTableView(){
        tableView.register(TrendsTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = UIColor.white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = UIColor(red:0.08, green:0.13, blue:0.16, alpha:1.0)
        
        tableView.separatorColor = UIColor(white: 1, alpha: 0.1)
        view.addSubview(tableView)
        tableView.backgroundColor = UIColor(red:0.08, green:0.13, blue:0.16, alpha:1.0)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    fileprivate func showAuthorizationMessage(){
        tableView.backgroundView = EnableLocationServiceView()
    }
    

    fileprivate let locationManager = CLLocationManager()
    fileprivate func setUpLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    fileprivate func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled() {
            setUpLocationManager()
            checkLocationAuthorization()
        }
    }
    
    fileprivate func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            getData()
        case .denied:
            showAuthorizationMessage()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            showAuthorizationMessage()
        case .authorizedAlways:
            break
        }
    }
    
    fileprivate func getData(){
        ActivityIndicator.shared.showLoaderView()
        dispatchGroup.enter()
        DispatchQueue.main.async {
            guard let location = self.locationManager.location else {return}
            TwitterAPI.shared.getWoeid(lat: String(location.coordinate.latitude), long: String(location.coordinate.longitude)) { (woeid, err) in
                if let err = err {
                    print(err.localizedDescription)
                }
                guard let woeid = woeid else {return}
                print(woeid.count)
                TwitterAPI.shared.getTrends(id: String(woeid[0].WOEID), completion: { (trends, err) in
                    if let err = err {
                        print(err.localizedDescription)
                    }
                    guard let trends = trends else {return}
                    self.trends = trends
                    self.dispatchGroup.notify(queue: .main) {
                        print("Reloading data..")
                        self.tableView.reloadData()
                        ActivityIndicator.shared.hideLoaderView()
                    }
                })
            }
            self.dispatchGroup.leave()
    }
}

    fileprivate func setUpNavBar() {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.prefersLargeTitles = true
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.title = "Trends"
    }
    
    fileprivate func setUpAttributedString(withTag tag: String, volume: Int) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: tag)
        attributedString.append(NSAttributedString(string: "\n"))
        attributedString.append(NSAttributedString(string: "Tweet volume: \(volume)"))
        return attributedString
    }
    
}





extension TrendsViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}
