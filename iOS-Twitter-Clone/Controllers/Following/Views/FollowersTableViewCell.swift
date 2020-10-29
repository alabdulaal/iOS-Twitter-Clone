//
//  DetailsTableViewCell.swift
//  iOS-Twitter-Automation
//
//  Created by ahmed on 2/6/19.
//  Copyright © 2019 com.ahmed. All rights reserved.
//

import UIKit

class FollowersTableViewCell: UITableViewCell {

    let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = UIColor.white
        lbl.textAlignment = .left
        lbl.sizeToFit()
        lbl.font = UIFont.boldSystemFont(ofSize: 15)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let screenNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = UIColor.lightGray
        lbl.textAlignment = .left
        lbl.sizeToFit()
        lbl.font = UIFont.systemFont(ofSize: 15)
        return lbl
    }()

    let desc: UITextView = {
        let txt = UITextView()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.sizeToFit()
        txt.backgroundColor = UIColor.clear
        txt.textColor = UIColor.white
        txt.font = UIFont.systemFont(ofSize: 15)
        txt.isUserInteractionEnabled = false
        return txt
    }()
    
    let imgView: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFill
        img.image?.withRenderingMode(.alwaysOriginal)
//        img.backgroundColor = .red
        return img
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        
        
        let arrangedSubviews = [nameLabel, screenNameLabel]
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        addSubview(imgView)
        addSubview(desc)
        
        imgView.layer.cornerRadius = 25
        imgView.clipsToBounds = true
        imgView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        imgView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        imgView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        imgView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        stackView.leadingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: 10).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: contentView.frame.width / 1.5).isActive = true
//        stackView.backgroundColor = .red

        desc.topAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true
        desc.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        desc.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        desc.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
