//
//  NotificationController.swift
//  Chat On Watch Extension
//
//  Created by Vikas R S on 9/11/18.
//  Copyright © 2018 Vikas Radhakrishna Shetty. All rights reserved.
//

import WatchKit
import Foundation
import UserNotifications
import AlamofireImage
import Alamofire



class NotificationController: WKUserNotificationInterfaceController {

    @IBOutlet var messageBodyLabel: WKInterfaceLabel!
    @IBOutlet var nameLabel: WKInterfaceLabel!
    @IBOutlet var imageView: WKInterfaceImage!
    override init() {
        // Initialize variables here.
        super.init()
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }


    override func didReceive(_ notification: UNNotification, withCompletion completionHandler: @escaping (WKUserNotificationInterfaceType) -> Swift.Void)
    {
        // This method is called when a notification needs to be presented.
        // Implement it if you use a dynamic notification interface.
        // Populate your dynamic notification interface as quickly as possible.
        //
        // After populating your dynamic notification interface call the completion block.
        
        
        nameLabel.setText(notification.request.content.title)
        messageBodyLabel.setText(notification.request.content.body)
        
        if let notification = notification.request.content.userInfo as? [String:AnyObject]
        {
            let imageUrl = parseRemoteNotification(notification: notification)
            if (imageUrl?.count == 0)
            {
                self.imageView.setImage(UIImage(named: "Default Avatar Image"))
            }
            else
            {
                self.imageView.setImageWithUrl(url: imageUrl!)
            }
            
        }
        
        completionHandler(.custom)
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


