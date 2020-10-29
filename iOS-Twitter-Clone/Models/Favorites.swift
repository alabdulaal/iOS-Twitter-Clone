//
//  Favorites.swift
//  iOS-Twitter-Automation
//
//  Created by Ahmed Al Abdulaal on 4/25/19.
//  Copyright © 2019 com.ahmed. All rights reserved.
//

import Foundation

struct Favorites: Decodable {
    
    let text: String
    let user: User
    
    private enum CodingKeys: String, CodingKey {
        case text = "text"
        case user = "user"
    }
}
