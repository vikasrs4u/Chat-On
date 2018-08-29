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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Code to make signup image view look round, instead of square.
        signUpImageViewOutlet.layer.cornerRadius = 50
        signUpImageViewOutlet.layer.masksToBounds = true
        signUpImageViewOutlet.backgroundColor = UIColor.flatSkyBlue()
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
                SVProgressHUD.showSuccess(withStatus: "Sucessfully Signed Up")
                
                self.performSegue(withIdentifier:"goToChat" , sender: self)
            }
            
        }
    }
    
    

}
