//
//  WOEID.swift
//  iOS-Twitter-Automation
//
//  Created by Ahmed Al Abdulaal on 3/25/19.
//  Copyright © 2019 com.ahmed. All rights reserved.
//

import Foundation

struct Location: Decodable {
    
    let WOEID: Int
    private enum CodingKeys: String, CodingKey {
        case WOEID = "woeid"
    }
}

struct Locations: Decodable {
    let woeid: [Location]
}


