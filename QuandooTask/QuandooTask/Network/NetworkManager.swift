//
//  NetworkManager.swift
//  QuandooTask
//
//  Created by Helder Pereira on 24/10/2016.
//  Copyright © 2016 Helder Pereira. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

// Very simple Rest APIs with JSON response, no need for extra session configuration or extra request and response serialization, Alamofire default values do just fine.

class NetworkManager {
    
    // Very simple singleton, that will load and parse network information
    // Will be called from the View Controllers
    
    static let defaultManager = NetworkManager()
    
    func fetchUsers(success:@escaping (_ users:[User]) -> Void, failure:@escaping () -> Void) {
        
        Alamofire.request(Routes.users.url).responseJSON { (responseObject) in
            
            guard !responseObject.result.isFailure else {
                
                failure()
                
                return
            }
            
            var users = [User]()
            
            let swiftyResponse = JSON(responseObject.result.value!)
            
            
            for (_, jsonUser):(String, JSON) in swiftyResponse {
                
                let id = jsonUser["id"].uInt ?? 0
                let name = jsonUser["name"].string ?? ""
                let username = jsonUser["username"].string ?? ""
                let email = jsonUser["email"].string ?? ""
                
                let street = jsonUser["address"]["street"].string ?? ""
                let suite = jsonUser["address"]["suite"].string ?? ""
                let city = jsonUser["address"]["city"].string ?? ""
                let zipcode = jsonUser["address"]["zipcode"].string ?? ""
                
                let address = "\(street), \(suite), \(city) \(zipcode)"
                
                let user = User(
                    id: id,
                    name: name,
                    username: username,
                    email: email,
                    address: address
                )
                
                users.append(user)
                
            }
            
            success(users)
            
        }
        
    }
    
    func fetchPostsFor(user: User, success:@escaping (_ posts:[Post]) -> Void, failure:@escaping () -> Void) {
        
        let params = [
            "userId": user.id
            ]
        
        Alamofire.request(Routes.posts.url, parameters: params).responseJSON { (responseObject) in
           
            guard !responseObject.result.isFailure else {
                
                failure()
                
                return
            }
            
            var posts = [Post]()
            
            let swiftyResponse = JSON(responseObject.result.value!)
            
            for (_, jsonUser):(String, JSON) in swiftyResponse {
                
                let userId = jsonUser["userId"].uInt ?? 0
                let id = jsonUser["id"].uInt ?? 0
                let title = jsonUser["title"].string ?? ""
                let body = jsonUser["body"].string ?? ""
                
                let post = Post(
                    userId: userId,
                    id: id,
                    title: title,
                    body: body
                )
                
                posts.append(post)
                
            }
            
            success(posts)

        
        }
        
        
    }
    
}
