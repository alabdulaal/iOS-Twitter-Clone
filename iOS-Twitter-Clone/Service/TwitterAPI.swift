//
//  TwitterAPI.swift
//  iOS-Twitter-Automation
//
//  Created by ahmed on 2/4/19.
//  Copyright © 2019 com.ahmed. All rights reserved.
//

import UIKit
import TwitterKit
import Firebase

class TwitterAPI {
    
    private init() {}
    static let shared = TwitterAPI()
    
    func logInWithTwitter(vc: UIViewController, completion: @escaping () -> Void){
        TWTRTwitter.sharedInstance().logIn { (twitterSession, err) in
            if let err = err {
                print(err.localizedDescription)
            }
            guard let twitterSession = twitterSession else {return}
            TWTRTwitter.sharedInstance().sessionStore.save(twitterSession, completion: { (session, err) in
                if let err = err {
                    print(err.localizedDescription)
                }
                print("Succesfully saved session in store")
                FirebaseAPI.shared.signTwitterUserToFirebase(TwitterSession: twitterSession)
                completion()
            })
        }
    }
    
    // After signing in and having a session 
    func getUserInformation(completion: @escaping (TwitterUser?, Error?) -> Void){
        guard let session = TWTRTwitter.sharedInstance().sessionStore.session() else {return}
        let client = TWTRAPIClient(userID: session.userID)
        client.loadUser(withID: session.userID) { (user, error) in
            if let error = error{
                print(error)
                completion(nil, error)
                return
            }
            guard let user = user else {return}
            let name = user.name
            let screenName = user.screenName
            let profileUrl = user.profileURL.absoluteString
            let userId = user.userID
            let profilePictureUrl = user.profileImageLargeURL
            let info = TwitterUser(name: name, screenName: screenName, profileUrl: profileUrl, userId: userId, profilePictureUrl: profilePictureUrl, token: session.authToken, tokenSecret: session.authTokenSecret)
            completion(info, nil)
        }
    }
    
    
    func getUserProfileAndInformation(UID: String, completion: @escaping (TwitterUser, UserStats) -> Void){
        FirebaseAPI.shared.getUserProfile { (user, err) in
            if let err = err {
                print("Inside getUserProfile")
                print(err.localizedDescription)
                return
            }
            guard let user = user else{return}
            let session = TWTRSession(authToken: user.token, authTokenSecret: user.tokenSecret, userName: user.screenName, userID: user.userId)

            self.getUserStat(twitterSession: session, userId: user.userId, screenName: user.screenName, name: user.name, completion: { (userStat, err) in
                
                if let err = err {
                    print("Inside getUserStat")
                    print(err.localizedDescription)
                    return
                }
                guard let userStat = userStat else {return}
                completion(user, userStat)
            })
            
        }
    }
    
    
    // getFriends would get user's friends
    func getFriends(completion: @escaping ([User]?, Error?) -> Void){
        guard let twitterSession = TWTRTwitter.sharedInstance().sessionStore.session() else {return}
        let client = TWTRAPIClient(userID: twitterSession.userID)
        let statusesShowEndpoint = "https://api.twitter.com/1.1/friends/list.json"
        let params = ["user_id": twitterSession.userID, "count": "200", "skip_status": "1", "include_user_entities": "0"]
        var clientError : NSError?
        let request = client.urlRequest(withMethod: "GET", urlString: statusesShowEndpoint, parameters: params, error: &clientError)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if let connectionError = connectionError {
                completion(nil, connectionError)
                print("Error: \(connectionError.localizedDescription)")
            }
            guard let data = data else {return}
            do {
                let followers = try JSONDecoder().decode(Followers.self, from: data)
                completion(followers.users, nil)
            } catch let jsonError {
                print(jsonError)
            }
        }
    }
    
    // destroyFriendShip would distroy friendship
    func destroyFriendShip(twitterSession: TWTRSession, userId: String, screenName: String){
        let client = TWTRAPIClient(userID: twitterSession.userID)
        let statusesShowEndpoint = "https://api.twitter.com/1.1/friendships/destroy.json"
        let params: [String: Any] = ["screen_name": screenName, "user_id": userId]
        var clientError : NSError?
        
        let request = client.urlRequest(withMethod: "POST", urlString: statusesShowEndpoint, parameters: params, error: &clientError)

        client.sendTwitterRequest(request) { (response, data, connectionError) in
            if let connectionError = connectionError {
                print("Error: \(connectionError.localizedDescription)")
            }
            
            guard let data = data else {return}
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print("json: \(json)")
            } catch let jsonError as NSError {
                print("json error: \(jsonError.localizedDescription)")
            }
            
        }
    }
    
    
    func getUserStat(twitterSession: TWTRAuthSession, userId: String, screenName: String, name: String, completion: @escaping (UserStats?, Error?) -> Void){
        let client = TWTRAPIClient(userID: twitterSession.userID)
        let statusesShowEndpoint = "https://api.twitter.com/1.1/users/show.json"
        let params: [String: Any] = ["Name": name, "screen_name": screenName, "user_id": userId]
        var clientError : NSError?
        
        let request = client.urlRequest(withMethod: "GET", urlString: statusesShowEndpoint, parameters: params, error: &clientError)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) in
            if let connectionError = connectionError {
                completion(nil, connectionError)
                print("Error: \(connectionError.localizedDescription)")
            }
            
            guard let data = data else {return}
            do {
                let stat = try JSONDecoder().decode(UserStats.self, from: data)
                completion(stat, nil)
            } catch let jsonError as NSError {
                completion(nil, jsonError)
                print("json error: \(jsonError.localizedDescription)")
            }
        }
    }
    
    
    func getRateLimits(twitterSession: TWTRAuthSession){
        let client = TWTRAPIClient(userID: twitterSession.userID)
        let statusesShowEndpoint = "https://api.twitter.com/1.1/application/rate_limit_status.json"
        let params = ["user_id": twitterSession.userID]
        var clientError : NSError?

        let request = client.urlRequest(withMethod: "GET", urlString: statusesShowEndpoint, parameters: params, error: &clientError)

        client.sendTwitterRequest(request) { (response, data, connectionError) in
            if let connectionError = connectionError {
                print("Error: \(connectionError.localizedDescription)")
            }
            guard let data = data else {return}
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print("json: \(json)")
            } catch let jsonError as NSError {
                print("json error: \(jsonError.localizedDescription)")
            }
        }
    }
    
    
    func getFollowers(completion: @escaping ([User]?, Error?) -> Void) {
        guard let twitterSession = TWTRTwitter.sharedInstance().sessionStore.session() else {return}
        let client = TWTRAPIClient(userID: twitterSession.userID)
        let statusesShowEndpoint = "https://api.twitter.com/1.1/followers/list.json"
        let params = ["user_id": twitterSession.userID, "count": "200", "skip_status": "1", "include_user_entities": "0"]
        var clientError : NSError?
        
        let request = client.urlRequest(withMethod: "GET", urlString: statusesShowEndpoint, parameters: params, error: &clientError)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if let connectionError = connectionError {
                print("Error: \(connectionError.localizedDescription)")
                completion(nil, connectionError)
            }
            guard let data = data else {return}
            do {
                let following = try JSONDecoder().decode(Followers.self, from: data)
                completion(following.users, nil)
            } catch let jsonError {
                completion(nil, jsonError)
                print(jsonError)
            }
        }
    }
    
    func getWoeid(lat: String, long: String, completion: @escaping (Array<Location>?, Error?) -> Void){
        guard let twitterSession = TWTRTwitter.sharedInstance().sessionStore.session() else {return}
        let client = TWTRAPIClient(userID: twitterSession.userID)
        let statusesShowEndpoint = "https://api.twitter.com/1.1/trends/closest.json"
        let params = ["lat": lat, "long": long]
        var clientError : NSError?
        
        let request = client.urlRequest(withMethod: "GET", urlString: statusesShowEndpoint, parameters: params, error: &clientError)
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if let connectionError = connectionError {
                print("Error: \(connectionError.localizedDescription)")
                completion(nil, connectionError)
            }
            guard let data = data else {return}
            do {
                let woeids = try JSONDecoder().decode(Array<Location>.self, from: data)
                completion(woeids, nil)
            } catch let jsonError {
                completion(nil, jsonError)
                print(jsonError)
            }
        }
    }
    
    func getTrends(id: String, completion: @escaping ([Trend]?, Error?) -> Void){
        guard let twitterSession = TWTRTwitter.sharedInstance().sessionStore.session() else {return}
        let client = TWTRAPIClient(userID: twitterSession.userID)
        let statusesShowEndpoint = "https://api.twitter.com/1.1/trends/place.json"
        let params = ["id": id]
        var clientError : NSError?
        
        let request = client.urlRequest(withMethod: "GET", urlString: statusesShowEndpoint, parameters: params, error: &clientError)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if let connectionError = connectionError {
                print("Error: \(connectionError.localizedDescription)")
                completion(nil, connectionError)
            }
            guard let data = data else {return}
            do {
                let trends = try JSONDecoder().decode([Trends].self, from: data)
                print(trends as Array)
                completion(trends[0].trends, nil)
            } catch let jsonError {
                print(jsonError)
                completion(nil, jsonError)
            }
        }
    }
    

    func getFavorites(name: String, completion: @escaping (Result<[Favorites], Error>) -> Void) {
        guard let twitterSession = TWTRTwitter.sharedInstance().sessionStore.session() else {return}
        let client = TWTRAPIClient(userID: twitterSession.userID)
        let statusesShowEndpoint = "https://api.twitter.com/1.1/favorites/list.json"
        let params = ["name": name, "count": "200"]
        var clientError : NSError?
        
        let request = client.urlRequest(withMethod: "GET", urlString: statusesShowEndpoint, parameters: params, error: &clientError)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if let connectionError = connectionError {
                print("Error: \(connectionError.localizedDescription)")
                completion(.failure(connectionError))
            }
            guard let data = data else {return}
            do {
                let trends = try JSONDecoder().decode([Favorites].self, from: data)
                print(trends as Array)
                completion(.success(trends))
            } catch let jsonError {
                print(jsonError)
                completion(.failure(jsonError))
            }
        }
    }
    
    func getTweet(byTrend name: String, completion: @escaping (Result<[Tweets], Error>) -> Void) {
        guard let twitterSession = TWTRTwitter.sharedInstance().sessionStore.session() else {return}
        let client = TWTRAPIClient(userID: twitterSession.userID)
        let statusesShowEndpoint = "https://api.twitter.com/1.1/search/tweets.json"
        let params = ["q": name, "count": "200", "result_type": "popular"]
        var clientError : NSError?
        
        let request = client.urlRequest(withMethod: "GET", urlString: statusesShowEndpoint, parameters: params, error: &clientError)

        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if let connectionError = connectionError {
                print("Error: \(connectionError.localizedDescription)")
                completion(.failure(connectionError))
            }
            guard let data = data else {return}
            do {
                let tweets = try JSONDecoder().decode([Tweets].self, from: data)
                completion(.success(tweets))
            } catch let jsonError {
                print(jsonError)
                completion(.failure(jsonError))
            }
        }
    }
    


    
    
}
