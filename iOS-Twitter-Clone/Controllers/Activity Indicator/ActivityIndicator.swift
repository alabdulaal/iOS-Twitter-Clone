//
//  ActivityIndicator.swift
//  iOS-Twitter-Automation
//
//  Created by ahmed on 2/13/19.
//  Copyright © 2019 com.ahmed. All rights reserved.
//

import UIKit

class ActivityIndicator: UIView {
    
    
    static let shared = ActivityIndicator()
    var gifName: String = "spinner"
    
    lazy var transparentView: UIView = {
        let transparentView = UIView(frame: UIScreen.main.bounds)
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        transparentView.isUserInteractionEnabled = false
        return transparentView
    }()
    
    lazy var activityGif: UIImageView = {
        let img = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        img.contentMode = .scaleAspectFit
        img.center = transparentView.center
        img.isUserInteractionEnabled = false
        img.loadGif(asset: gifName)
        return img
    }()
    
    func showLoaderView() {
        //        self.transparentView.layoutIfNeeded()
        self.addSubview(self.transparentView)
        self.transparentView.addSubview(self.activityGif)
        self.transparentView.bringSubviewToFront(self.activityGif)
        UIApplication.shared.keyWindow?.addSubview(transparentView)
    }
    
    func hideLoaderView() {
        self.transparentView.removeFromSuperview()
    }
    
}
