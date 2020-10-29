//
//  Tweet.swift
//  iOS-Twitter-Automation
//
//  Created by Ahmed Al Abdulaal on 4/26/19.
//  Copyright © 2019 com.ahmed. All rights reserved.
//

import Foundation

struct Tweet: Decodable {
    
    let user: User
    let text: String
    let numberOfRetweet: Int
    let numberOfFavorites: Int
    
    private enum CodingKeys: String, CodingKey {
        case user = "user"
        case text = "text"
        case numberOfRetweet = "retweet_count"
        case numberOfFavorites = "favorite_count"
    }
}

struct Tweets: Decodable {
    let tweets: [Tweet]
    private enum CodingKeys: String, CodingKey {
        case tweets = "statuses"
    }
}
