//
//  LoginViewController.swift
//  Chat On
//
//  Created by Vikas R S on 8/20/18.
//  Copyright © 2018 Vikas Radhakrishna Shetty. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    
    @IBOutlet weak var emailTextfield: UITextField!
    
    @IBOutlet weak var passwordTextfield: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

    }

    @IBAction func loginButtonClicked(_ sender: UIButton)
    {
        Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!)
        { (result, error) in
            
            if(error != nil)
            {
                print("Error in login")
            }
            else
            {
                self.performSegue(withIdentifier:"goToChat", sender: self)
            }
        }
    }
    


}
