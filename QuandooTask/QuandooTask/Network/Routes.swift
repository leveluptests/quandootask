//
//  Routes.swift
//  QuandooTask
//
//  Created by Helder Pereira on 24/10/2016.
//  Copyright © 2016 Helder Pereira. All rights reserved.
//

import Foundation

enum Routes: String {
    case base = "https://jsonplaceholder.typicode.com/"
    case users = "users/"
    case posts = "posts/"
    
    var fullPath: String {
        
        switch self {
        case .base:
            return self.rawValue
        default:
            return Routes.base.rawValue + self.rawValue
        }
    }
    
    var url: URL {
        return URL(string: self.fullPath)!
    }
}
