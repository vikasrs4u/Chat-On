//
//  SignUpViewController.swift
//  Chat On
//
//  Created by Vikas R S on 8/20/18.
//  Copyright © 2018 Vikas Radhakrishna Shetty. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD



class SignUpViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate
{

    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var signUpImageViewOutlet: UIImageView!
    
    @IBOutlet weak var nameTextField: UITextField!
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Code to make signup image view look round, instead of square.
        signUpImageViewOutlet.layer.cornerRadius = 50
        signUpImageViewOutlet.layer.masksToBounds = true
        signUpImageViewOutlet.backgroundColor = UIColor.flatSkyBlue()
        
        // This code is to enable signup image and make user select new image from gallery
        signUpImageViewOutlet.isUserInteractionEnabled = true
        signUpImageViewOutlet.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedOnImageView)))
        
        //Below is the code added to dismiss the keyboard.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
 
    }

    // MARK: - SignUp
    
    //Method will be called when signup button is clicked.
    @IBAction func signUpButtonClicked(_ sender: UIButton)
    {
        SVProgressHUD.show()
        
        guard let email:String = emailTextfield.text else {return}
        guard let password:String = passwordTextfield.text else {return}
        
        Auth.auth().createUser(withEmail: email, password: password)
        { (authResult, error) in
            if (error != nil)
            {
                let errorMessage:String = (error?.localizedDescription.description)!
                
                SVProgressHUD.showError(withStatus:errorMessage)
                
                print(error!)
            }
            else
            {
                self.profileImageUpload()
            
            }
            
        }
    }

    func profileImageUpload()
    {
        let userUID:String = (Auth.auth().currentUser?.uid)!

        let storageRef = Storage.storage().reference().child("\(userUID)\(".png")")
        
        // Image uploaded to firebase must be Data and not UIImage, so below changes are made
        
        if let uploadImage = UIImagePNGRepresentation(signUpImageViewOutlet.image!)
        {
            storageRef.putData(uploadImage, metadata: nil)
            { (metadata, error)in
            
                if(error != nil)
                {
                    SVProgressHUD.showError(withStatus:"Profile Image Upload was not successful!!!")
                }
                else
                {
                  storageRef.downloadURL(completion:
                    {(url, error) in
                        if (error == nil)
                        {
                            let downloadImageUrlString:String = (url?.absoluteString)!
                            self.profileInformationStorage(downloadImageUrl:downloadImageUrlString)
                            self.profileModification(downloadUrl: downloadImageUrlString)
                            return
                        }
                    })

                }
                
            }
        }
    }
    
    
    func profileInformationStorage(downloadImageUrl:String)
    {
        let userUID:String = (Auth.auth().currentUser?.uid)!
        let emailID:String = (Auth.auth().currentUser?.email)!
        let usersName:String = self.nameTextField.text!
        
        let userProfileDatabase = Database.database().reference().child("UserProfileInfo").child(userUID)
        let userProfileDictionary = ["Name":usersName,"email":emailID, "profileImageUrl":downloadImageUrl]
        
        userProfileDatabase.setValue(userProfileDictionary)
        {
            (error,reference ) in
            
            if(error != nil)
            {
                SVProgressHUD.showError(withStatus:"Error while storing user info")
            }
            else
            {
                return
            }
            
        }
    }
    
    // Once signup is successful this method is called to update the name and
    func profileModification(downloadUrl:String)
    {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        
        changeRequest?.displayName = self.nameTextField.text!
        changeRequest?.photoURL = URL(string: downloadUrl)
        changeRequest?.commitChanges(completion:
            {
                error in
                
                if(error != nil)
                {
                    print(error!)
                }
                else
                {
                    let fcmTokenValue:String = String(Messaging.messaging().fcmToken!)
                    
                    self.postTheTokenToFireBaseDB(token: fcmTokenValue)
                    print("Message Sucessfully saved.")
                    SVProgressHUD.showSuccess(withStatus: "Sucessfully Signed Up")
                    // we need to register on signup
                    UIApplication.shared.registerForRemoteNotifications()
                    self.performSegue(withIdentifier:"goToChat" , sender: self)
                    
                }
                
        })
    }
    
    // Method to dismiss the keyboard
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    // method to store token in database so that we get notification
    
    func postTheTokenToFireBaseDB(token:String)
    {
        if (token.count != 0)
        {
            let databaseReference = Database.database().reference().child("FCMToken").child(token)
            
            let tokenDictionary = [token:token]
            
            databaseReference.setValue(tokenDictionary)
            {  (error,reference) in
                
                if(error != nil)
                {
                    print(error!)
                }
                else
                {
                    print("Token Sucessfully saved.")
                    
                }
            }
        }

    }
    
}


