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
import AlamofireImage
import Alamofire

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
{
    var messageArray:[Message] = [Message]()
    
    var keyboardHeight:CGFloat = 200
    
    var isKeyBoardCurrentlyShown = false
    
    var counter:Int = 0
    
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
        messageTableViews.backgroundView = UIImageView(image: UIImage(named:"Message Background"))

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
        
        if(Auth.auth().currentUser?.photoURL != nil)
        {
            
            let theURL = NSURL(string:(Auth.auth().currentUser?.photoURL?.absoluteString)!)
            navigationProfileImageOutlet.af_setImage(withURL:theURL! as URL, placeholderImage: UIImage(named: "Default Avatar Image"), imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion:nil)
            
            navigationProfileImageOutlet.backgroundColor = UIColor.flatSkyBlue()
        }
        else
        {
            navigationProfileImageOutlet.image  = UIImage(named: "Default Avatar Image")
            navigationProfileImageOutlet.backgroundColor = UIColor.flatSkyBlue()
            
        }
        
        navigationProfileImageOutlet.layer.cornerRadius = 20
        navigationProfileImageOutlet.layer.masksToBounds = true
        
        roundingTheTextField()
        
        sendButtonsOutlet.layer.cornerRadius = 20
        sendButtonsOutlet.layer.masksToBounds = true
        
        // By default when view loads send button should not be shown
        messageButtonWidthConstriant.constant = 0
        
        // nofification to check if message textfield has some data change or not. 
        NotificationCenter.default.addObserver(self, selector: #selector(changeSendButtonColor), name: .UITextFieldTextDidChange, object: nil)
        
        // On click of profile image, we will be opening profile image view
       let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ChatViewController.imageTapped(gesture:)))
        // add it to the image view;
        navigationProfileImageOutlet.addGestureRecognizer(tapGesture)
        // make sure imageView can be interacted with by user
        navigationProfileImageOutlet.isUserInteractionEnabled = true



    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        {
            let orientation = UIApplication.shared.statusBarOrientation
            
            // Keyboard height should be set based on orientation
            if(!UIInterfaceOrientationIsPortrait(orientation) && (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1))
            {
               keyboardHeight = keyboardSize.width
            }
            else
            {
                keyboardHeight = keyboardSize.height
            }
            
            UIView.animate(withDuration: 0.3)
            {
                if(!self.isKeyBoardCurrentlyShown)
                {
                  self.heightConstraints.constant = self.heightConstraints.constant + self.keyboardHeight
                  self.isKeyBoardCurrentlyShown = true
                }
                else
                {
                    //Code added for orientation change handling when keyboard is shown
                    self.heightConstraints.constant = 42 + self.keyboardHeight
                }
                
                
                // Below code is to redraw the layout again to update to new constraint
                self.view.layoutIfNeeded()
                
                if (self.messageArray.count > 0)
                {
                    let indexPath = IndexPath(row: self.messageArray.count-1, section: 0);
                    self.messageTableViews.scrollToRow(at: indexPath, at:.bottom, animated: false)
                }
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
        cell.senderUsername.text = messageArray[indexPath.row].name
        cell.avatarImageView.image = UIImage(named: "Default Avatar Image")
        
        // To make the image avatars to be rounded
        cell.avatarImageView.layer.cornerRadius = 26
        cell.avatarImageView.layer.masksToBounds = true
        
        // To make the message cell have rounded corners
        cell.messageBackground.layer.cornerRadius = 20
        cell.messageBackground.layer.masksToBounds = true
        
        if(messageArray[indexPath.row].sender == Auth.auth().currentUser?.email)
        {
            let theURL = NSURL(string:(Auth.auth().currentUser?.photoURL?.absoluteString)!)
            
            if (counter == 0)
            {
                let URL = NSURL(string: (Auth.auth().currentUser?.photoURL?.absoluteString)!)
                let mURLRequest = NSURLRequest(url: URL! as URL)
                let urlRequest = URLRequest(url: URL! as URL, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData)
                
                let imageDownloader = UIImageView.af_sharedImageDownloader
                _ = imageDownloader.imageCache?.removeImage(for: mURLRequest as URLRequest, withIdentifier: nil)
                cell.avatarImageView.af_setImage(withURLRequest: urlRequest, placeholderImage: UIImage(named: "placeholder"), completion: { (response) in
                    cell.avatarImageView.image = response.result.value
                })
            }
            else
            {
                cell.avatarImageView.af_setImage(withURL:theURL! as URL, placeholderImage: UIImage(named: "Default Avatar Image"), imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion:nil)
                

            }
            
            
            cell.avatarImageView.backgroundColor = UIColor.flatSkyBlue()
            cell.messageBackground.backgroundColor = UIColor(hexString:"DCF8C6")
            cell.senderUsername.textColor = UIColor.flatOrange()
            


        }
        else
        {
            let theURL = NSURL(string:messageArray[indexPath.row].profileImageOfSender)
            
            cell.avatarImageView.af_setImage(withURL:theURL! as URL, placeholderImage: UIImage(named: "Default Avatar Image"), imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion:nil)
            
            cell.avatarImageView.backgroundColor = UIColor.flatPlum()
            cell.messageBackground.backgroundColor = UIColor.flatWhite()
            cell.senderUsername.textColor = UIColor.flatBlue()
        }
        
       
        cell.avatarImageView.layer.borderColor = UIColor.white.cgColor
        
        if (indexPath.row == messageArray.count - 1)
        {
            counter = counter + 1;
        }

        cell.backgroundView = UIImageView(image: UIImage(named:"Message Background"))

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
            
            // When user logs out we need to degrisgter him to all types of notifications
            
            UIApplication.shared.unregisterForRemoteNotifications()
            
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
            self.heightConstraints.constant = 42
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
                                     "MessageBody": messageTextfields.text!,
                                     "ProfileImageOfSender":Auth.auth().currentUser?.photoURL?.absoluteString,
                                     "Name":Auth.auth().currentUser?.displayName]
            
            messageDatabase.childByAutoId().setValue(messageDictionary)
            {  (error,reference) in
                
                if(error != nil)
                {
                    print(error!)
                    SVProgressHUD.showError(withStatus:error?.localizedDescription)
                }
                else
                {
                    print("Message Sucessfully saved.")

                }
                
                self.messageTextfields.isEnabled = true
                self.sendButtonsOutlet.isEnabled = true
                self.messageTextfields.text = ""
                self.sendButtonsOutlet.setTitleColor(UIColor.white, for: .normal)
                // Once the message is sent, by default send button should not be shown
                self.messageButtonWidthConstriant.constant = 0
            }
        }

    }
    
    
    
    //Method to retrive the data from Firebase database
    
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
            
            message.profileImageOfSender = snapshotValue["ProfileImageOfSender"]!
            
            message.name = snapshotValue["Name"]!
            
            self.messageArray.append(message)
            
            // to resize the cell
            self.configureTheTableViewCell()
            
            // so that new data gets reloaded
            self.messageTableViews.reloadData()
            
            let indexPath = IndexPath(row: self.messageArray.count-1, section: 0);
            self.messageTableViews.scrollToRow(at: indexPath, at:.bottom, animated: false)
            
        }
        
    }
    
    
    //Method to retrive Online information
    
    func retriveOnlineInfoFromDatabase()
    {
        
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
    
    
    //Method to round the message textField
    func roundingTheTextField()
    {
        //Basic texfield Setup
        messageTextfields.borderStyle = .none
        messageTextfields.backgroundColor = UIColor.white
        
        //To apply corner radius
        messageTextfields.layer.cornerRadius = messageTextfields.frame.size.height / 2
        
        //To apply border
        messageTextfields.layer.borderWidth = 0.25
        messageTextfields.layer.borderColor = UIColor.white.cgColor
        
        //To apply Shadow
        messageTextfields.layer.shadowOpacity = 1
        messageTextfields.layer.shadowRadius = 1.2
        messageTextfields.layer.shadowOffset = CGSize.zero // Use any CGSize
        messageTextfields.layer.shadowColor = UIColor.gray.cgColor
        
        //To apply padding
        let paddingView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: messageTextfields.frame.height))
        messageTextfields.leftView = paddingView
        messageTextfields.leftViewMode = UITextFieldViewMode.always
    }
    

    @objc func imageTapped(gesture: UIGestureRecognizer) {
        // if the tapped view is a UIImageView then set it to imageview
        
        if (gesture.view as? UIImageView) != nil
        {
            print("Image Tapped")
            self.performSegue(withIdentifier:"goToProfileImage" , sender: self)
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        messageTableViews.reloadData()
        
        if(Auth.auth().currentUser?.photoURL != nil)
        {
            let theURL = NSURL(string:(Auth.auth().currentUser?.photoURL?.absoluteString)!)
            navigationProfileImageOutlet.af_setImage(withURL:theURL! as URL, placeholderImage: UIImage(named: "Default Avatar Image"), imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion:nil)
            
            navigationProfileImageOutlet.backgroundColor = UIColor.flatSkyBlue()
        }
        else
        {
            navigationProfileImageOutlet.image  = UIImage(named: "Default Avatar Image")
            navigationProfileImageOutlet.backgroundColor = UIColor.flatSkyBlue()
            
        }
        
    }
    
    

    
    //Method to draw button inside the textfield
    //    func setupUI()
    //    {
    //        let button = UIButton(type:.custom)
    //        button.setTitle("↑", for:.normal)
    //        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
    //
    //        button.backgroundColor = UIColor(hexString:"2969D2")
    //        button.setTitleColor(UIColor.white, for:.normal)
    //        button.frame = CGRect(x: 0, y: 0, width: CGFloat(25), height: CGFloat(25))
    //        button.layer.cornerRadius = button.frame.size.height / 2
    //        button.layer.masksToBounds = true
    //        //button.addTarget(self, action: #selector(self.refresh), for: .touchUpInside)
    //        messageTextfields.rightView = button
    //        messageTextfields.rightViewMode = .never
    //    }
    
}


