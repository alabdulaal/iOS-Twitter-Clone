//
//  Trends.swift
//  iOS-Twitter-Automation
//
//  Created by Ahmed Al Abdulaal on 3/25/19.
//  Copyright © 2019 com.ahmed. All rights reserved.
//

import UIKit

struct Trend: Decodable {
    
    let name: String
    let url: String
    let tweetVolume: Int?
    
    private enum CodingKeys : String, CodingKey {
        case name = "name"
        case url = "url"
        case tweetVolume = "tweet_volume"
    }
}

struct Trends: Decodable {
    let trends: [Trend]
}
