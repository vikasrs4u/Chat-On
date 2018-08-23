//
//  ChatViewController.swift
//  Chat On
//
//  Created by Vikas R S on 8/20/18.
//  Copyright © 2018 Vikas Radhakrishna Shetty. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    @IBOutlet weak var messageTableViews: UITableView!
    
    @IBOutlet weak var sendButtonsOutlet: UIButton!
    
    @IBOutlet weak var heightConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var messageTextfields: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Since we have table view, we need to regsiter our class as delegate and data source for the table view
        
        messageTableViews.delegate = self
        messageTableViews.dataSource = self
        
        // We need to regsiter the custom cell, below is the code for the same
        messageTableViews.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        
        // Method to resize the cell
        configureTheTableViewCell()
        
    }
    
    
    // Required Datasource methods for the table view
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell") as! CustomMessageCell
        
        let message = ["First Message","Seconddndfbdfbdfbdnfbdfndbfnbdnfdbfndbfnbdfbdfbndfbndbfndbfnbdfbdnbfndbfndbfndb Message","Third Message"]
        
        cell.messageBody.text = message[indexPath.row]
        
        return cell
        
    }
    
    
    // If data in the cell is too long, then cell should resize itself
    func configureTheTableViewCell()
    {
        messageTableViews.rowHeight = UITableViewAutomaticDimension
        messageTableViews.estimatedRowHeight = UITableViewAutomaticDimension
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
