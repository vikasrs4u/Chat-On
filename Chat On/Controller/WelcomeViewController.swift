//
//  ViewController.swift
//  Chat On
//
//  Created by Vikas R S on 8/20/18.
//  Copyright © 2018 Vikas Radhakrishna Shetty. All rights reserved.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Below code is added to keep user logged in even when user quits the app. 
        let currentUser = Auth.auth().currentUser
        
        Auth.auth().addStateDidChangeListener
            {
                (auth, user) in
                
                if (user == currentUser && user != nil)
                {
                    self.performSegue(withIdentifier:"goToChatFromWelcome" , sender: self)
                }
                
        }
        

    }

}

