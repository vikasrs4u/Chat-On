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
import ChameleonFramework

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
{
    var messageArray:[Message] = [Message]()
    
    var keyboardHeight:CGFloat = 256
    
    var isKeyBoardCurrentlyShown = false
    
    @IBOutlet weak var tableViewHeightConstriant: NSLayoutConstraint!
    @IBOutlet weak var messageTableViews: UITableView!
    
    @IBOutlet weak var sendButtonsOutlet: UIButton!
    
    @IBOutlet weak var heightConstraints: NSLayoutConstraint!
    
    
    @IBOutlet weak var navigationProfileImageOutlet: UIImageView!
    @IBOutlet weak var navigationBarOutlet: UINavigationItem!
    
    @IBOutlet weak var messageTextfields: UITextField!
    
    
    @IBOutlet weak var messageButtonWidthConstriant: NSLayoutConstraint!
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        
        navigationBarOutlet.title = Auth.auth().currentUser?.displayName
    
        navigationBarOutlet.hidesBackButton = true
        
        if(Auth.auth().currentUser?.email == "vshetty@scu.edu")
        {
           navigationProfileImageOutlet.image  = UIImage(named: "Vikas")
        }
        else
        {
            navigationProfileImageOutlet.image  = UIImage(named: "Default Avatar Image")
            navigationProfileImageOutlet.backgroundColor = UIColor.flatSkyBlue()
            
        }
        
        navigationProfileImageOutlet.layer.cornerRadius = 20
        navigationProfileImageOutlet.layer.masksToBounds = true

        messageTextfields.layer.cornerRadius = 20
        messageTextfields.layer.masksToBounds = true
        
        sendButtonsOutlet.layer.cornerRadius = 20
        sendButtonsOutlet.layer.masksToBounds = true
        
        // By default when view loads send button should not be shown
        messageButtonWidthConstriant.constant = 0
        
        // nofification to check if message textfield has some data change or not. 
        NotificationCenter.default.addObserver(self, selector: #selector(changeSendButtonColor), name: .UITextFieldTextDidChange, object: nil)
        

    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        {
            keyboardHeight = keyboardSize.height
            print(keyboardHeight)
            
            UIView.animate(withDuration: 0.3)
            {
                if(!self.isKeyBoardCurrentlyShown)
                {
                  self.heightConstraints.constant = self.heightConstraints.constant + self.keyboardHeight
                  self.isKeyBoardCurrentlyShown = true
                }
                
                
                // Below code is to redraw the layout again to update to new constraint
                self.view.layoutIfNeeded()
                
                let indexPath = IndexPath(row: self.messageArray.count-1, section: 0);
                self.messageTableViews.scrollToRow(at: indexPath, at:.bottom, animated: false)
                
            }
        }
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
        
        // To make the image avatars to be rounded
        cell.avatarImageView.layer.cornerRadius = 26
        cell.avatarImageView.layer.masksToBounds = true
        
        // To make the message cell have rounded corners
        cell.messageBackground.layer.cornerRadius = 20;
        cell.messageBackground.layer.masksToBounds = true;
        
        
        if(messageArray[indexPath.row].sender == Auth.auth().currentUser?.email)
        {
            cell.avatarImageView.backgroundColor = UIColor.flatSkyBlue()
            cell.messageBackground.backgroundColor = UIColor.flatMint()

        }
        else
        {
            cell.avatarImageView.backgroundColor = UIColor.flatPlum()
            cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()
        }
        
        if(messageArray[indexPath.row].sender == "vshetty@scu.edu")
        {
            cell.avatarImageView.image = UIImage(named: "Vikas")
        }

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
   
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        // we have to bring back constraint to its original value 50
        
        UIView.animate(withDuration: 0.3)
        {
            self.heightConstraints.constant = 45
            // Below code is to redraw the layout again to update to new constraint
            self.view.layoutIfNeeded()
            self.isKeyBoardCurrentlyShown = false
        }
    }
    
    
    // Method is called when send button is clicked in chat box
    @IBAction func sendButtonClicked(_ sender: UIButton)
    {
        dismissKeyboard()
        
        if (messageTextfields.text?.count != 0)
        {
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
                    self.messageButtonWidthConstriant.constant = 30
                }
                else
                {
                    print("Message Sucessfully saved.")
                    self.messageTextfields.isEnabled = true
                    self.sendButtonsOutlet.isEnabled = true
                    self.messageTextfields.text = ""
                    self.sendButtonsOutlet.setTitleColor(UIColor.white, for: .normal)
                    // Once the message is sent, by default send button should not be shown
                    self.messageButtonWidthConstriant.constant = 0
                }
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
            
            let indexPath = IndexPath(row: self.messageArray.count-1, section: 0);
            self.messageTableViews.scrollToRow(at: indexPath, at:.bottom, animated: false)
            
        }
        
    }
    
    // Method to show or hide the send button and also to make send button a circle
    @objc func changeSendButtonColor()
    {
        if (messageTextfields.text?.count == 0)
        {
            sendButtonsOutlet.layer.cornerRadius = 20
            sendButtonsOutlet.layer.masksToBounds = true
            sendButtonsOutlet.backgroundColor = UIColor.clear
            messageButtonWidthConstriant.constant = 0
        }
        else
        {
            messageButtonWidthConstriant.constant = 30
            sendButtonsOutlet.layer.cornerRadius = 15
            sendButtonsOutlet.layer.masksToBounds = true
            sendButtonsOutlet.backgroundColor = UIColor(hexString:"2969D2")
        }
    }
    
   // Method to dismiss the keyboard
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    
}
