//
//  MainTableViewCell.swift
//  iOS-Twitter-Automation
//
//  Created by ahmed on 2/3/19.
//  Copyright © 2019 com.ahmed. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    let optionLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = UIColor.white
        lbl.textAlignment = .left
        lbl.font = UIFont.boldSystemFont(ofSize: 30)
        return lbl
    }()
    
    let imgView: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFit
        img.image?.withRenderingMode(.alwaysOriginal)
        return img
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        addSubview(optionLabel)
        addSubview(imgView)
        
        optionLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        optionLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        optionLabel.leadingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: 5).isActive = true
        optionLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        

        imgView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        imgView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imgView.widthAnchor.constraint(equalToConstant: contentView.frame.width * 1/3).isActive = true
        imgView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
