//
//  ChatViewController.swift
//  Chat On
//
//  Created by Vikas R S on 8/20/18.
//  Copyright © 2018 Vikas Radhakrishna Shetty. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
{

    var messageArray:[Message] = [Message]()
    
    
    
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
        
        // Since we have Text view, we need to regsiter our class as delegate for the text view
        
        messageTextfields.delegate = self
        
        // We need to regsiter the custom cell, below is the code for the same
        messageTableViews.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        
        // Method to resize the cell
        configureTheTableViewCell()
        
        
        //Below is the code added to dismiss the keyboard.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        retriveMessageDataFromDatabase()
        
        // In table view seperate line will no longer be shown
        
        messageTableViews.separatorStyle = .none
        
    }
    
    
    // Required Datasource methods for the table view
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell") as! CustomMessageCell
        
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.senderUsername.text = messageArray[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named: "Default Avatar Image")
        
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
        SVProgressHUD.show()
        do
        {
            try Auth.auth().signOut()
            
            // To take user back to rootview i.e the first screen of our app.
            
            SVProgressHUD.showSuccess(withStatus: "Sucessfully Logged out")

            navigationController?.popToRootViewController(animated: true)
        }
        catch
        {
            let errorMessage:String = error.localizedDescription.description
            
            SVProgressHUD.showError(withStatus:errorMessage)
            
            print(error.localizedDescription)
        }
    
    }
   

    // Whenever the textView is being clicked then we want to know
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        // We know that height of key board is 258, height of our text field is 50
        // 258 + 50 = 308
        
        UIView.animate(withDuration: 0.3)
        {
            self.heightConstraints.constant = 318
            
            // Below code is to redraw the layout again to update to new constraint
            self.view.layoutIfNeeded()
        }

    }


    func textFieldDidEndEditing(_ textField: UITextField)
    {
        // we have to bring back constraint to its original value 50
        
        UIView.animate(withDuration: 0.3)
        {
            self.heightConstraints.constant = 50
            
            // Below code is to redraw the layout again to update to new constraint
            self.view.layoutIfNeeded()
        }
    }
    
    
    // Method is called when send button is clicked in chat box
    @IBAction func sendButtonClicked(_ sender: UIButton)
    {
        dismissKeyboard()
        
        // Just Disabling the text field and send button till data is stored in database
        messageTextfields.isEnabled = false
        sendButtonsOutlet.isEnabled = false
        
        let messageDatabase = Database.database().reference().child("Messages")
        
        let messageDictionary = ["Sender":Auth.auth().currentUser?.email,
                                 "MessageBody": messageTextfields.text!]
        
        messageDatabase.childByAutoId().setValue(messageDictionary)
        {  (error,reference) in
            
            if(error != nil)
            {
                print(error!)
            }
            else
            {
                print("Message Sucessfully saved.")
                self.messageTextfields.isEnabled = true
                self.sendButtonsOutlet.isEnabled = true
                self.messageTextfields.text = ""
            }
        }
    }
    
    //Method to retrive the data
    
    func retriveMessageDataFromDatabase()
    {
        let messageDatabase = Database.database().reference().child("Messages")
        
        messageDatabase.observe(.childAdded)
        {
            (snapshot) in
            
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            
            let message = Message()
            
            message.messageBody = snapshotValue["MessageBody"]!
            
            message.sender = snapshotValue["Sender"]!
            
            self.messageArray.append(message)
            
            // to resize the cell
            self.configureTheTableViewCell()
            
            // so that new data gets reloaded
            self.messageTableViews.reloadData()
            
        }
        
    }
    
   // Method to dismiss the keyboard
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    
}
