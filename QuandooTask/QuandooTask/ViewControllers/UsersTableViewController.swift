//
//  UsersTableViewController.swift
//  QuandooTask
//
//  Created by Helder Pereira on 24/10/2016.
//  Copyright © 2016 Helder Pereira. All rights reserved.
//

import UIKit
import APESuperHUD

class UsersTableViewController: UITableViewController {

    // Instead of using optionals point to empty Array
    // Keeps the code clean and the overhead is absolutely minimal
    private var users = [User]()
    
    private var didLayoutOnce = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 124
    }
    
    override func viewDidLayoutSubviews() {
        
        // only execute the first time the viewControllerLayout is ready
        // better than view did load to startup animations
        
        if didLayoutOnce { return }
        
        didLayoutOnce = true
        
        loadUsers()
    }
    
    func loadUsers() {
        
        APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard, funnyMessagesLanguage: .english, presentingView: self.view)
        
        NetworkManager.defaultManager.fetchUsers(success: { (users) in
            
            print("\(users)")
            
            self.users = users
            
            self.tableView.reloadData()
            
            APESuperHUD.removeHUD(animated: true, presentingView: self.view, completion: nil)
            
        }) {
            
            APESuperHUD.removeHUD(animated: false, presentingView: self.view, completion: nil)
            
            APESuperHUD.showOrUpdateHUD(icon: .sadFace, message: "Network Error", duration: 3.0, presentingView: self.view, completion:nil)
            
        }
        
    }
    
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return users.count
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "protoCell", for: indexPath) as! UserTableViewCell
        
        let user = users[indexPath.row]
        
        cell.labelName.text = user.name
        cell.labelUsername.text = user.username
        cell.labelEmail.text = user.email
        cell.labelAddress.text = user.address
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "UsersToUserPosts", sender: users[indexPath.row])
        
    }
    
    // MARK: - Navigation
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "UsersToUserPosts") {
            
            let uptvc = segue.destination as! UserPostsTableViewController
            uptvc.user = sender as? User
        }
        
    }
    
    
}
