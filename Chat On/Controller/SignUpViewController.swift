//
//  SignUpViewController.swift
//  Chat On
//
//  Created by Vikas R S on 8/20/18.
//  Copyright © 2018 Vikas Radhakrishna Shetty. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController
{

    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - SignUp
    
    //Method will be called when signup button is clicked.
    @IBAction func signUpButtonClicked(_ sender: UIButton)
    {
        guard let email:String = emailTextfield.text else {return}
        guard let password:String = passwordTextfield.text else {return}
        
        Auth.auth().createUser(withEmail: email, password: password)
        { (authResult, error) in
            if (error != nil)
            {
                print(error!)
            }
            else
            {
                
                self.performSegue(withIdentifier:"goToChat" , sender: self)
            }
            
        }
    }
    
    

}
