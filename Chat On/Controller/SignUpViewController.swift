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

class SignUpViewController: UIViewController
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
//                let userUID:String = (Auth.auth().currentUser?.uid)!
//                let emailID:String = (Auth.auth().currentUser?.email)!
//                let usersName:String = (Auth.auth().currentUser?.displayName)!
//
//                let messageDatabase = Database.database().reference().child("UserProfileInfo")
//
//                let messageDictionary = ["email":emailID, "profileImageUrl":"xyz"]
                
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                
                changeRequest?.displayName = self.nameTextField.text!
                changeRequest?.commitChanges(completion:
                    {
                        error in
                        
                        if(error != nil)
                        {
                            print(error!)
                        }
                        else
                        {
                            print("Message Sucessfully saved.")
                            SVProgressHUD.showSuccess(withStatus: "Sucessfully Signed Up")
                            
                            self.performSegue(withIdentifier:"goToChat" , sender: self)
                            
                        }
                
                    })
                
            }
            
        }
    }


}
