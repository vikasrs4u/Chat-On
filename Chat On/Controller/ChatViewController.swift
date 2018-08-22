//
//  ChatViewController.swift
//  Chat On
//
//  Created by Vikas R S on 8/20/18.
//  Copyright © 2018 Vikas Radhakrishna Shetty. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController
{

    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var messageTextfield: UITextField!
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // This function is called when we click on logout button.
    @IBAction func logOutButtonClicked(_ sender: UIBarButtonItem)
    {
        do
        {
            try Auth.auth().signOut()
            
            // To take user back to rootview i.e the first screen of our app.

            navigationController?.popToRootViewController(animated: true)
        }
        catch
        {
            
            print(error.localizedDescription)
        }
    
    }
   



}
