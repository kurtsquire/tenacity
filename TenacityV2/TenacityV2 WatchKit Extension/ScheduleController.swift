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
        var dateComponents = Calendar(identifier: .gregorian).dateComponents(Set(arrayLiteral: .timeZone, .year, .month, .day, .hour, .minute, .second), from: tomorrow!)
        
        var tempTime:Int = Int(self.time) ?? -1
        if (self.apm == "PM" && tempTime != -1){
            tempTime += 12
        }
        
        if (tempTime != -1){
            // Schedule the request with the system.
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.getNotificationSettings { (settings) in
                // Do not schedule notifications if not authorized.
                guard settings.authorizationStatus == .authorized else {return}
                    dateComponents.hour = tempTime
                    dateComponents.minute = 0
                    
                    let trigger = UNCalendarNotificationTrigger(
                        dateMatching: dateComponents, repeats: false)
                
                    let content = UNMutableNotificationContent()
                    content.title = "Time to Play Game!"
                    content.body = "It is time to play \(gameName)!"
                    content.categoryIdentifier = "myCategory"
                    content.sound = UNNotificationSound.default()
                    
                    let uuidString = UUID().uuidString
                    let request = UNNotificationRequest(identifier: uuidString,content: content, trigger: trigger)
                    notificationCenter.add(request) { (error) in
                        if error != nil {
                            print(error!)
                        }
                    }
                print("notification will be triggered at \(dateComponents.month!)/\(dateComponents.day!) at \(dateComponents.hour!):\(dateComponents.minute!)")
            }// getNotificationSetting
        }// tempTime
    }// func

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
    
    func modifyLocalStorage(time:String, apm:String, gameName:String){
        let defaults = UserDefaults.standard
        var gameInfo = UserDefaults.standard.object(forKey: "gameInfo") as? [String : [String : String]]
        if gameInfo == nil {
            gameInfo = [gameName: ["time": time, "apm": apm]]
        }
        else{
            gameInfo![gameName] = ["time": time, "apm": apm]
        }
        defaults.set(gameInfo, forKey: "gameInfo")
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String) -> Any? {
        if segueIdentifier == "schedule_to_main" {
            self.notificationTrigger(time: self.time, apm: self.apm, gameName: self.game)
            self.modifyLocalStorage(time: self.time, apm: self.apm, gameName: self.game)
            return ["content": self.time + " " + self.apm, "game": self.game]
        }

        return ""
    }
    
}
