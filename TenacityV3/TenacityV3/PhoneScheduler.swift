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

class PhoneScheduler: PhoneViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // puts in top bar
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // takes out top bar again
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    var month: Int? = nil
    var day: Int? = nil
    var hour: Int? = nil
    var min: Int? = nil
    var dateString = ""
   
    //@IBOutlet weak var pickedTimeLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        if (dateString != "No Current Nudge"){
            saveToRealm(what: "nudge deleted: " + dateString)
            dateString = "No Current Nudge"
            dateLabel.text = "No Current Nudge"
            
            UserDefaults.standard.set(dateString, forKey: "dateString" + String(editingNudge))
            
            let center = UNUserNotificationCenter.current()
            
            //requests permissions for notifications
            center.requestAuthorization(options: [.alert, .sound])
            { success, error in
                //if they allow notifications
                if success {
                    // removes current notification
                    //center.removeAllPendingNotificationRequests()
                    center.removePendingNotificationRequests(withIdentifiers: ["nudge" + String(editingNudge)])
                }
            }
        }
        
        
        
        
        
    }
    
    
    override func viewDidLoad() {
        //datePicker.backgroundColor = UIColor.white
        datePicker.setValue(UIColor.white, forKey: "textColor")
        testUserDefaults()
        
        dateLabel.text = "Current Nudge: " + dateString
        saveButton.setTitle("Save " + dateString, for: .normal)
       
    }
    
    @IBAction func datePickerPicked(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let somedateString = dateFormatter.string(from: sender.date)
        
        //pickedTimeLabel.text = somedateString
        saveButton.setTitle("Save " + somedateString, for: .normal)
        dateString = somedateString
    }
    
    func createNotification(){

        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "It's Time!"
        content.body = "Your scheduled play time is now"
        
        content.categoryIdentifier = "nudge" + String(editingNudge)
        
        content.sound = UNNotificationSound.default
        
        
        //takes the values from datepicker
        DispatchQueue.main.async {
            let components = self.datePicker.calendar.dateComponents([.hour, .minute], from: self.datePicker.date)
            
            //day = components.day
            //month = components.month
            self.hour = components.hour
            self.min = components.minute
            
            //var date = DateComponents()
            //date.month =  month
            //date.day = day
            //date.hour = hour
            //date.minute = min
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
            
            //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: "nudge" + String(editingNudge), content: content, trigger: trigger)
            
            center.add(request)
        }
    }
    
    func setPlayReminder() {
        let center = UNUserNotificationCenter.current()
        
        //requests permissions for notifications
        center.requestAuthorization(options: [.alert, .sound])
        { success, error in
            //if they allow notifications
            if success {
                // removes current notification
                center.removePendingNotificationRequests(withIdentifiers: ["nudge" + String(editingNudge)])
                
                //sets the new notification
                self.createNotification()
            }
        }
    }
    
    func registerCategories(){
        
        let center = UNUserNotificationCenter.current()
        let play = UNNotificationAction(identifier : "play", title: "Play Now", options: .foreground)
        let category = UNNotificationCategory(identifier: "play_reminder" + String(editingNudge), actions: [play], intentIdentifiers: [])
        
        center.setNotificationCategories([category])
    }
    @IBAction func saveButtonpressed(_ sender: Any) {
        setPlayReminder()
        dateLabel.text = "Current Nudge: " + dateString
        UserDefaults.standard.set(dateString, forKey: "dateString" + String(editingNudge))
        saveToRealm(what: "nudge set: " + dateString)
    }
    
    override func testUserDefaults(){
        let defaults = UserDefaults.standard
        
        dateString = defaults.string(forKey: "dateString" + String(editingNudge)) ?? "No Current Nudge"
    }
    
}

