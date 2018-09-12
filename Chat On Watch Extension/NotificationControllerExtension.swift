//
//  NotificationControllerExtension.swift
//  Chat On Watch Extension
//
//  Created by Vikas R S on 9/11/18.
//  Copyright © 2018 Vikas Radhakrishna Shetty. All rights reserved.
//

import WatchKit

public extension WKInterfaceImage {
    
    public func setImageWithUrl(url:String, scale: CGFloat = 1.0) -> WKInterfaceImage?
    {
        
        URLSession.shared.dataTask(with: NSURL(string: url)! as URL) { data, response, error in
            if (data != nil && error == nil) {
                let image = UIImage(data: data!, scale: scale)
                
                DispatchQueue.main.async() {
                    self.setImage(image)
                }
            }
            }.resume()
        
        return self
    }
}
