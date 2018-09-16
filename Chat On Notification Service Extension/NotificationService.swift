//
//  NotificationService.swift
//  Chat On Notification Service Extension
//
//  Created by Vikas R S on 9/15/18.
//  Copyright © 2018 Vikas Radhakrishna Shetty. All rights reserved.
//

import MobileCoreServices
import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    var currentDownloadTask: URLSessionDownloadTask?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void)
    {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let mutableContent = self.bestAttemptContent,
            let urlString = mutableContent.userInfo["image_url"] as? String,
            let url = URL(string: urlString) {
            // Create a download task using the url passed in the push payload.
            currentDownloadTask = URLSession.shared.downloadTask(with: url, completionHandler: { fileURL, _, error in
                
                if let error = error
                {
                    // Handle the case where the download task fails.
                    NSLog("download task failed with \(error)")

                }
                else
                {
                    // Handle the case where the download task succeeds.
                    if let fileURL = fileURL,
                        // Temporary files usually do not have a type extension, so get the type of the original url.
                        let fileType = NotificationService.fileType(fileExtension: url.pathExtension),
                        // Pass the type as type hint key to help out.
                        let attachment = try? UNNotificationAttachment(identifier: "pushAttachment", url: fileURL, options: [UNNotificationAttachmentOptionsTypeHintKey: fileType])
                    {
                        // Add the attachment to the notification content.
                        mutableContent.attachments = [attachment]
                        
                        // Set the category after successfully attaching an image.
                        mutableContent.categoryIdentifier = "messageNotificaionCategory"
                    }
                }
                
                contentHandler(mutableContent)
            })
            
            currentDownloadTask?.resume()
        }

    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        // Cancel running download task.
        if let downloadTask = currentDownloadTask {
            downloadTask.cancel()
        }
    }
    
    // Helper function to get a kUTType from a file extension.
    class func fileType(fileExtension: String) -> CFString? {
        return UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension as CFString, nil)?.takeRetainedValue()
    }

}

