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
        //Below is the code added to dismiss the keyboard.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)

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
                let fcmTokenValue:String = String(Messaging.messaging().fcmToken!)
                self.updateUserInfo(token: fcmTokenValue)
                // we need to register on login 
                UIApplication.shared.registerForRemoteNotifications()
                SVProgressHUD.showSuccess(withStatus: "Sucessfully Logged In")
                self.performSegue(withIdentifier:"goToChat", sender: self)
            }
        }
    }
    
    // Method to dismiss the keyboard
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    func updateUserInfo(token:String)
    {
        if (token.count != 0)
        {
            let VC:SignUpViewController = SignUpViewController()
            
            VC.postTheTokenToFireBaseDB(token:token)
        }

    }
    


}
