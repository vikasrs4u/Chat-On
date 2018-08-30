//
//  SignUpViewController+Handler.swift
//  Chat On
//
//  Created by Vikas R S on 8/29/18.
//  Copyright © 2018 Vikas Radhakrishna Shetty. All rights reserved.
// This handler file is added to segreate signup profile image task from SignUpViewController
//

import UIKit

extension SignUpViewController
{
    // Method is called when user taps on signup image in Sign Up screen
    @objc func tappedOnImageView()
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
        
        signUpImageViewOutlet.image = selectedImage
        
        dismiss(animated: true, completion:nil)
    }
    
    // This will be called when user clicks on cancels instead of selecting a picture
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
         dismiss(animated: true, completion:nil)
    }
}
