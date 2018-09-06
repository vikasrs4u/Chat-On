//
//  ProfileImageViewController.swift
//  Chat On
//
//  Created by Vikas R S on 9/5/18.
//  Copyright © 2018 Vikas Radhakrishna Shetty. All rights reserved.
//

import UIKit
import Firebase
import AlamofireImage

class ProfileImageViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    
    @IBOutlet weak var profileImageOutlet: UIImageView!
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if(Auth.auth().currentUser?.photoURL != nil)
        {
            let theURL = NSURL(string:(Auth.auth().currentUser?.photoURL?.absoluteString)!)
            profileImageOutlet.af_setImage(withURL:theURL! as URL, placeholderImage: UIImage(named: "Default Avatar Image"), imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion:nil)
            
            profileImageOutlet.backgroundColor = UIColor.flatSkyBlue()
        }
        else
        {
            profileImageOutlet.image  = UIImage(named: "Default Avatar Image")
            profileImageOutlet.backgroundColor = UIColor.flatSkyBlue()
            
        }
        
        profileImageOutlet.layer.cornerRadius = profileImageOutlet.frame.size.height / 2
        profileImageOutlet.layer.masksToBounds = true
        profileImageOutlet.layer.borderColor = UIColor.white.cgColor
        profileImageOutlet.layer.borderWidth = 2.0
        

        
    }


    @IBAction func editProfileImage(_ sender: UIBarButtonItem)
    {
        // This code is to enable Profile image and make user select new image from gallery
        
       editProfileImageClicked()
    }
    
    

}
