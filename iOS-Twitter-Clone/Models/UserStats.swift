//
//  TwitterUserStat.swift
//  iOS-Twitter-Automation
//
//  Created by ahmed on 2/12/19.
//  Copyright © 2019 com.ahmed. All rights reserved.
//

import Foundation

struct UserStats: Decodable {
    let following: Int
    let followers: Int
    
    private enum CodingKeys: String, CodingKey {
        case following = "friends_count"
        case followers = "followers_count"
    }
}
