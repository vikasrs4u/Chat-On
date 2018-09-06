//
//  ProfileImageViewController+Handler.swift
//  Chat On
//
//  Created by Vikas R S on 9/5/18.
//  Copyright © 2018 Vikas Radhakrishna Shetty. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import AlamofireImage


extension ProfileImageViewController
{
    // Method is called when user taps on signup image in Sign Up screen
    func editProfileImageClicked()
    {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        
        // Below code enables editing the image to be added as profile image
        picker.allowsEditing = true
        
        present(picker, animated: true, completion:nil)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        var selectedImage:UIImage?
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage
        {
            selectedImage = editedImage
        }
        else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            selectedImage = originalImage
        }
        
        profileImageOutlet.image = selectedImage
        
        SVProgressHUD.show()
        
        profileImageUpload()
        
        dismiss(animated: true, completion:nil)
    }
    
    // This will be called when user clicks on cancels instead of selecting a picture
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion:nil)
    }
    
    func profileImageUpload()
    {
        let userUID:String = (Auth.auth().currentUser?.uid)!
        
        let storageRef = Storage.storage().reference().child("\(userUID)\(".png")")
        
        // Image uploaded to firebase must be Data and not UIImage, so below changes are made
        
        if let uploadImage = UIImagePNGRepresentation(profileImageOutlet.image!)
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

        let userProfileDatabase = Database.database().reference().child("UserProfileInfo").child((Auth.auth().currentUser?.uid)!)
        
        userProfileDatabase.child("profileImageUrl").setValue(downloadImageUrl)
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
                  print("Message Sucessfully saved.")
                  SVProgressHUD.showSuccess(withStatus: "Sucessfully Updated the profile image")
                    
                }
                
        })
    }
}
