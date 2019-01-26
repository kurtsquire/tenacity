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

    override func didReceive(_ notification: UNNotification, withCompletion completionHandler: @escaping (WKUserNotificationInterfaceType) -> Swift.Void) {
        // After populating your dynamic notification interface call the completion block.
//        let gameName = "Time to play " + notification["aps"]!["gameName"]!
//        gameNameLabel.setText("Time to play "+gameName+"!")
        print("this method is called")
        print(notification)
        
        completionHandler(.custom)
    }
 
    
    
}
