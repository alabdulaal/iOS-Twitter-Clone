//
//  EnableLocationServiceView.swift
//  iOS-Twitter-Automation
//
//  Created by Ahmed Al Abdulaal on 3/25/19.
//  Copyright © 2019 com.ahmed. All rights reserved.
//

import UIKit

class EnableLocationServiceView: UIView {
    
    let imageView: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFit
        img.image = UIImage(named: "location")?.withRenderingMode(.alwaysTemplate)
        img.tintColor = UIColor(red:0.22, green:0.63, blue:0.95, alpha:1.0)
        return img
    }()
    
    let messageLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.text = "Enable location service to get trends near you"
        lbl.sizeToFit()
        lbl.numberOfLines = 0
        lbl.textColor = .lightGray
        return lbl
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setUpViews() {
        backgroundColor = .white
        addSubview(imageView)
        addSubview(messageLabel)
        
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        messageLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5).isActive = true
        messageLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
        messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
    }

}
