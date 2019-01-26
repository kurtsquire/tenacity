//
//  ScheduleController.swift
//  TenacityV2 WatchKit Extension
//
//  Created by Hangzhi Pang on 11/13/18.
//  Copyright © 2018 PLL. All rights reserved.
//

import WatchKit
import Foundation
import UserNotifications

class ScheduleController: WKInterfaceController {

    @IBOutlet var TimePicker: WKInterfacePicker!
    @IBOutlet var APMPicker: WKInterfacePicker!
    @IBOutlet var GameName: WKInterfaceLabel!
    
    var apm:String
    var time:String
    var game:String
    
    override init() {
        self.apm = "AM"
        self.time = "1"
        self.game = "Default"
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    self.game = context as! String
    GameName.setText(self.game)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        let timePickerItems: [WKPickerItem] = (1...12).map {
            let timePickerItem = WKPickerItem()
            timePickerItem.title = String($0)
            return timePickerItem
        }
        let apmPickerItems: [WKPickerItem] = ["AM","PM"].map {
            let apmPickerItem = WKPickerItem()
            apmPickerItem.title = $0
            return apmPickerItem
        }
        TimePicker.setItems(timePickerItems)
        APMPicker.setItems(apmPickerItems)
        
    }
    
    func notificationTrigger(time:String, apm:String, gameName:String){
        // Configure the recurring date.
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        let test = Calendar.current.date(byAdding: .day, value: 0, to: Date())
        var dateComponents = Calendar(identifier: .gregorian).dateComponents(Set(arrayLiteral: .timeZone, .year, .month, .day, .hour, .minute, .second), from: test!)
        
        var tempTime:Int = Int(self.time) ?? -1
        if (self.apm == "PM" && tempTime != -1){
            tempTime += 12
        }
        
        if (tempTime != -1){
            dateComponents.hour = tempTime
            dateComponents.minute = 7
            

            // Create the trigger as a repeating event.
            let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents, repeats: false)
        
        
            let content = UNMutableNotificationContent()
            content.title = "Time to Play Game!"
            content.body = "It is time to play \(gameName)!"
            content.categoryIdentifier = "myCategory"
            
            let uuidString = UUID().uuidString
            let request = UNNotificationRequest(identifier: uuidString,content: content, trigger: trigger)
            
            // Schedule the request with the system.
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.add(request) { (error) in
                if error != nil {
                    print(error)
                }
            }
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func APMPicker(_ value: Int) {
        self.apm = ["AM","PM"][value]
    }
    
    @IBAction func pickerSelectedItem(_ value: Int) {
        self.time = String(Array((1...12))[value])
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String) -> Any? {
        if segueIdentifier == "schedule_to_main" {
            if (self.time != nil){
                self.notificationTrigger(time: self.time, apm: self.apm, gameName: self.game)
            }
            return ["content": self.time + " " + self.apm, "game": self.game]
        }

        return ""
    }
    
}
