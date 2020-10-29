//
//  Followers.swift
//  iOS-Twitter-Automation
//
//  Created by ahmed on 2/6/19.
//  Copyright © 2019 com.ahmed. All rights reserved.
//

import UIKit

struct User: Decodable {
    
    let id: String
    let name: String
    let screenName: String
    let profileImg: String
    let isFollowingYou: Bool
    let description: String
    
    private enum CodingKeys : String, CodingKey {
        case id = "id_str"
        case name = "name"
        case screenName = "screen_name"
        case profileImg = "profile_image_url_https"
        case isFollowingYou = "following"
        case description = "description"
    }
}

struct Followers: Decodable {
    let users: [User]
}
