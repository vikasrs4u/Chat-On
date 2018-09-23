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
import ChameleonFramework

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet weak var nameLabelOutlet: UILabel!
    
    @IBOutlet weak var usersName: UILabel!
    
    @IBOutlet weak var messageBody: UILabel!
    
    @IBOutlet weak var usersProfileImage: UIImageView!
    
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any required interface initialization here.
        
        self.usersProfileImage.layer.cornerRadius = self.usersProfileImage.frame.size.height / 2
        self.usersProfileImage.layer.masksToBounds = true
        
        self.usersProfileImage.layer.borderWidth = 0.25
        self.usersProfileImage.layer.borderColor = UIColor.black.cgColor
        self.containerView.backgroundColor = UIColor.flatWhite()
        self.containerView.layer.cornerRadius = 20
        self.containerView.layer.masksToBounds = true
        self.nameLabelOutlet.textColor = UIColor.flatBlue()
        
    }
    
    func didReceive(_ notification: UNNotification)
    {
        self.usersName.text = notification.request.content.title
        
        self.messageBody.text = notification.request.content.body
        
        guard let attachment = notification.request.content.attachments.first else { return }
        
        // Get the attachment and set the image view.
        if attachment.url.startAccessingSecurityScopedResource(),
            let data = try? Data(contentsOf: attachment.url)
        {
            self.usersProfileImage.image = UIImage(data: data)
            
            attachment.url.stopAccessingSecurityScopedResource()
        }
    }
    
    
}
