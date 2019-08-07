//
//  PhoneScheduler.swift
//  TenacityV3
//
//  Created by PLL on 6/10/19.
//  Copyright © 2019 PLL. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class PhoneScheduler: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var month: Int? = nil
    var day: Int? = nil
    var hour: Int? = nil
    var min: Int? = nil
    var dateString = ""
   
    @IBOutlet weak var pickedTimeLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        dateString = "No Current Nudge"
        dateLabel.text = "No Current Nudge"
        
        UserDefaults.standard.set(dateString, forKey: "dateString")
        
        let center = UNUserNotificationCenter.current()
        
        //requests permissions for notifications
        center.requestAuthorization(options: [.alert, .sound])
        { success, error in
            //if they allow notifications
            if success {
                // removes current notification
                center.removeAllPendingNotificationRequests()
            }
        }
    }
    
    
    override func viewDidLoad() {
        //datePicker.backgroundColor = UIColor.white
        datePicker.setValue(UIColor.white, forKey: "textColor")
        testUserDefaults()
        
        dateLabel.text = dateString
       
    }
    
    @IBAction func datePickerPicked(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let somedateString = dateFormatter.string(from: sender.date)
        
        pickedTimeLabel.text = somedateString
        dateString = somedateString
    }
    
    func createNotification(){

        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "It's Time!"
        content.body = "Your scheduled play time is now"
        
        content.categoryIdentifier = "play_reminder"
        
        content.sound = UNNotificationSound.default
        
        
        //takes the values from datepicker
        
        let components = datePicker.calendar.dateComponents([.hour, .minute], from: datePicker.date)
        //day = components.day
        //month = components.month
        hour = components.hour
        min = components.minute
        
        //var date = DateComponents()
        //date.month =  month
        //date.day = day
        //date.hour = hour
        //date.minute = min
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        center.add(request)
    }
    
    func setPlayReminder() {
        let center = UNUserNotificationCenter.current()
        
        //requests permissions for notifications
        center.requestAuthorization(options: [.alert, .sound])
        { success, error in
            //if they allow notifications
            if success {
                // removes current notification
                center.removeAllPendingNotificationRequests()
                
                //sets the new notification
                self.createNotification()
            }
        }
    }
    
    func registerCategories(){
        
        let center = UNUserNotificationCenter.current()
        let play = UNNotificationAction(identifier : "play", title: "Play Now", options: .foreground)
        let category = UNNotificationCategory(identifier: "play_reminder", actions: [play], intentIdentifiers: [])
        
        center.setNotificationCategories([category])
    }
    @IBAction func saveButtonpressed(_ sender: Any) {
        setPlayReminder()
        dateLabel.text = "Current Nudge: " + dateString
        UserDefaults.standard.set(dateString, forKey: "dateString")
    }
    
    func testUserDefaults(){
        let defaults = UserDefaults.standard
        
        dateString = defaults.string(forKey: "dateString") ?? "No Current Nudge"
    }
    
}

