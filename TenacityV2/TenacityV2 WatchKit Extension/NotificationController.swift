//
//  NotificationController.swift
//  TenacityV2 WatchKit Extension
//
//  Created by PLL on 10/8/18.
//  Copyright © 2018 PLL. All rights reserved.
//

import WatchKit
import Foundation
import UserNotifications


class NotificationController: WKUserNotificationInterfaceController {
    
    
    @IBOutlet var gameNameLabel: WKInterfaceLabel!
    private static let center = UNUserNotificationCenter.current()
    private static let options: UNAuthorizationOptions = [.alert, .badge, .sound]
    /// The title for alert box.
    private static let alertTitle = "Permission Not Granted"
    /// The message in the alert box.
    private static let alertMessage = "Permission for pushing notification is not granted. This may result "
        + "in malfunction. Please go to the system settings to change it."
    
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
    
//    /// Checks whether the application has been authorized to push notifications
//    /// and request authorization if not.
//    /// - Parameter handler: The handler after the permission request with a parameter
//    /// indicating whether authorization was granted.
//    static func checkPermission(onRequest handler: @escaping (Bool, Error?) -> Void) {
//        center.getNotificationSettings { settings in
//            if settings.authorizationStatus != .authorized {
//                center.requestAuthorization(options: options, completionHandler: handler)
//            }
//        }
//    }
//
//    /// Checks whether the application has been authorized to push notifications
//    /// and request authorization if not. Shows an alert message if the user does
//    /// not grant the permission.
//    static func checkPermission(in controller: WKInterfaceController) {
//        checkPermission { isGranted, _ in
//            if !isGranted {
//                print("permission not granted")
//            }
//        }
//    }
    
    override func didReceive(_ notification: UNNotification, withCompletion completionHandler: @escaping (WKUserNotificationInterfaceType) -> Swift.Void) {
//        print("apn notification")
        print(notification)
        
        completionHandler(.custom)
    }
 
    
    
}
