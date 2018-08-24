//
//  LoginViewController.swift
//  Chat On
//
//  Created by Vikas R S on 8/20/18.
//  Copyright © 2018 Vikas Radhakrishna Shetty. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LoginViewController: UIViewController {

    
    @IBOutlet weak var emailTextfield: UITextField!
    
    @IBOutlet weak var passwordTextfield: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

    }

    @IBAction func loginButtonClicked(_ sender: UIButton)
    {
        SVProgressHUD.show()
        
        Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!)
        { (result, error) in
            
            if(error != nil)
            {
                let errorMessage:String = (error?.localizedDescription.description)!
                
                SVProgressHUD.showError(withStatus:errorMessage)
            
            }
            else
            {
                SVProgressHUD.showSuccess(withStatus: "Sucessfully Logged In")
                self.performSegue(withIdentifier:"goToChat", sender: self)
            }
        }
    }
    


}
