//
//  ViewController.swift
//  GameOfChat
//
//  Created by Sabbir on 11/6/19.
//  Copyright © 2019 Sabbir. All rights reserved.
//

import UIKit
import Firebase

class MessagesController: UITableViewController {
    
 
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain , target: self, action: #selector(handleLogout))
        
       
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(handleNewMessage))
 
        checkIfUserLoggedIn()

    }
    
    @objc func handleNewMessage() {
        
        let newMessageController = NewMessageController()
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil)
        
        
    }
    
    func checkIfUserLoggedIn(){
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
            handleLogout()
        }else {
            
            fetchUserAndSetUpNavbarTitle()
 
        }
        
    }
    
    
    func fetchUserAndSetUpNavbarTitle() {
        Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value) { (snapshot) in
            
            //print(snapshot)
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.navigationItem.title = dictionary["name"] as? String
            }
            
        }
        
        
    }
    
    
    @objc func handleLogout() {
        
        do {
            try Auth.auth().signOut()
            
        }catch let logoutError {
            print(logoutError)
        }
        
        let loginController = LoginController()
        loginController.messagesController = self
        present(loginController, animated: true , completion: nil )
        
        
        
    }
    
    
    
    
    
    
    
    
    


}

