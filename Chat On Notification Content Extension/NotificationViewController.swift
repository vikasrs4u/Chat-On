//
//  NotificationViewController.swift
//  Chat On Notification Content Extension
//
//  Created by Vikas R S on 9/10/18.
//  Copyright © 2018 Vikas Radhakrishna Shetty. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import AlamofireImage

class NotificationViewController: UIViewController, UNNotificationContentExtension {

 
    @IBOutlet weak var usersName: UILabel!
    
    @IBOutlet weak var messageBody: UILabel!
    
    @IBOutlet weak var usersProfileImage: UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any required interface initialization here.
        
        self.usersProfileImage.layer.cornerRadius = self.usersProfileImage.frame.size.height / 2
        self.usersProfileImage.layer.masksToBounds = true
        
        self.usersProfileImage.layer.borderWidth = 0.25
        self.usersProfileImage.layer.borderColor = UIColor.black.cgColor
    }
    
    func didReceive(_ notification: UNNotification)
    {
        self.usersName.text = notification.request.content.title
        
        self.messageBody.text = notification.request.content.body
        
        
        print(notification.request.content.userInfo.values)
        
        if let notification = notification.request.content.userInfo as? [String:AnyObject]
        {
            let imageUrl = parseRemoteNotification(notification: notification)
            
            if (imageUrl?.count == 0)
            {
                self.usersProfileImage.image = UIImage(named: "Default Avatar Image")
            }
            else
            {
                let theURL = NSURL(string:imageUrl!)
                self.usersProfileImage.af_setImage(withURL:theURL! as URL, placeholderImage: UIImage(named: "Default Avatar Image"), imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion:nil)
            }
            
        }
    }
    
    
func parseRemoteNotification(notification:[String:AnyObject]) -> String?
{
        if let imageUrl = notification["image_url"] as? String
        {
            return imageUrl
        }
        
        return nil
    }
}
