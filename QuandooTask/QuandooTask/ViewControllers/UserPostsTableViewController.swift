//
//  UserPostsTableViewController.swift
//  QuandooTask
//
//  Created by Helder Pereira on 24/10/2016.
//  Copyright © 2016 Helder Pereira. All rights reserved.
//

import UIKit
import APESuperHUD

class UserPostsTableViewController: UITableViewController {
    
    var user:User?
    
    private var posts = [Post]()
    private var didLayoutOnce = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 124
        
        if let user = self.user {
            navigationItem.title = "Posts by \(user.username)"
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        
        if didLayoutOnce { return }
        
        didLayoutOnce = true
        
        loadPosts()
    }
    
    func loadPosts() {
        
        if let user = self.user {
           
            APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard, funnyMessagesLanguage: .english, presentingView: self.view)
            
            NetworkManager.defaultManager.fetchPostsFor(user: user, success: { (posts) in
                
                self.posts = posts
                
                self.tableView.reloadData()
                
                APESuperHUD.removeHUD(animated: true, presentingView: self.view, completion: nil)
                
                }, failure: {
                    APESuperHUD.removeHUD(animated: false, presentingView: self.view, completion: nil)
                    
                    APESuperHUD.showOrUpdateHUD(icon: .sadFace, message: "Network Error", duration: 3.0, presentingView: self.view, completion:nil)
            })
            
        }
        
    }
    
    // MARK: - Table view data source

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "protoCell", for: indexPath) as! PostTableViewCell
        
        let post = posts[indexPath.row]
        
        cell.labelTitle.text = post.title
        cell.labelBody.text = post.body
        
        return cell
    }
    
}
