//
//  PhoneScheduler.swift
//  TenacityV3
//
//  Created by PLL on 6/10/19.
//  Copyright © 2019 PLL. All rights reserved.
//

// Controls the Date Picker Screen when editing a Nudge

import Foundation
import UIKit
import UserNotifications

class PhoneScheduler: PhoneViewController {
    
    var month: Int? = nil
    var day: Int? = nil
    var hour: Int? = nil
    var min: Int? = nil
    var dateString = ""
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    // ----------------------------------- View Loads -----------------------------------------
    
    
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
  
    override func viewDidLoad() {
        datePicker.setValue(UIColor.white, forKey: "textColor")
        testUserDefaults()
        
        dateLabel.text = "Current Nudge: " + dateString
        saveButton.setTitle("Save " + dateString, for: .normal)
       
    }
    
    // ----------------------------------- Actions ---------------------------------------
    
    // when the date on the date picker is changed
    @IBAction func datePickerPicked(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let somedateString = dateFormatter.string(from: sender.date)
        
        saveButton.setTitle("Save " + somedateString, for: .normal)
        dateString = somedateString
    }
    
    @IBAction func saveButtonpressed(_ sender: Any) {
        // sets notification
        setPlayReminder()
        // updates text on screen
        dateLabel.text = "Current Nudge: " + dateString
        // saves locally
        UserDefaults.standard.set(dateString, forKey: "dateString" + String(editingNudge))
        // tells realm user set a notification
        saveToRealm(what: "nudge set: " + dateString)
    }
    
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
    
    // --------------------------------------------- Functions -------------------------------------------
    
    func createNotification(){

        // content is what the notification says
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "It's Time!"
        content.body = "Your scheduled play time is now"
        content.categoryIdentifier = "nudge" + String(editingNudge)
        content.sound = UNNotificationSound.default
        
        DispatchQueue.main.async {
            //takes the values from datepicker
            let components = self.datePicker.calendar.dateComponents([.hour, .minute], from: self.datePicker.date)
            
            self.hour = components.hour
            self.min = components.minute
            
            // this is the trigger for the notification popup, and whether or not it repeats
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
            // the identifier is what allows us to have multiple different nudges and turn them off individually
            let request = UNNotificationRequest(identifier: "nudge" + String(editingNudge), content: content, trigger: trigger)
            // sets the notification
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
        // this category opens the app when users touch it
        let center = UNUserNotificationCenter.current()
        let play = UNNotificationAction(identifier : "play", title: "Play Now", options: .foreground)
        let category = UNNotificationCategory(identifier: "play_reminder" + String(editingNudge), actions: [play], intentIdentifiers: [])
        
        center.setNotificationCategories([category])
    }

    // gets saved data of current nudge if any and updates the text label
    override func testUserDefaults(){
        let defaults = UserDefaults.standard
        dateString = defaults.string(forKey: "dateString" + String(editingNudge)) ?? "No Current Nudge"
    }
    
}

