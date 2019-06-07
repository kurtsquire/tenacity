//
//  SchedulerController.swift
//  TenacityV3 WatchKit Extension
//
//  Created by PLL on 6/4/19.
//  Copyright © 2019 PLL. All rights reserved.
//

import Foundation
import WatchKit

class SchedulerController: WKInterfaceController{
    
    @IBOutlet weak var timeLabel: WKInterfaceLabel!
    @IBOutlet weak var hourPicker: WKInterfacePicker!
    @IBOutlet weak var minutePicker: WKInterfacePicker!
    @IBOutlet weak var meridiemPicker: WKInterfacePicker!
    @IBOutlet weak var saveButton: WKInterfaceButton!
    
    var hour = 12
    var minute = 0
    var minuteString = "00"
    var meridiem = "AM"
    
    
    var hours = [WKPickerItem]()
    var minutes = [WKPickerItem]()
    var meridiems = [WKPickerItem]()
    let meridiemArray = ["AM", "PM"]
    
    var alarmDict = [String : Int]()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // sets all hours
        for i in 1..<13{
            let hour = WKPickerItem()
            hour.title = String(i)
            hours.append(hour)
        }
        
        //sets all minutes
        for i in 0..<60{
            let min = WKPickerItem()
            min.title = String(i)
            minutes.append(min)
        }
        
        //sets meridiems
        for i in meridiemArray{
            let item = WKPickerItem()
            item.title = i
            meridiems.append(item)
        }
        
        hourPicker.setItems(hours)
        minutePicker.setItems(minutes)
        meridiemPicker.setItems(meridiems)
        
        loadUserDefaults()
        updateCurrentAlarmLabel()
    }
    
    
    @IBAction func hourPicked(_ value: Int) {
        hour = (value + 1)
        updateButtonLabel()
    }
    
    @IBAction func minutePicked(_ value: Int) {
        switch value {
            case 0 ... 9:
            minuteString = "0" + String(value)
        default:
            minuteString = String(value)
        }
        minute = value
        updateButtonLabel()
    }
    
    @IBAction func meridiemPicked(_ value: Int) {
        meridiem = meridiemArray[value]
        updateButtonLabel()
    }
    
    func updateButtonLabel(){
        saveButton.setEnabled(true)
        saveButton.setTitle("Set \(String(hour)):\(minuteString) \(meridiem)")
        
    }
    
    func updateDict(){
        if meridiem == "AM"{
            alarmDict["hour"] = hour
        }
        else if meridiem == "PM"{
            alarmDict["hour"] = hour + 12
        }
        alarmDict["minute"] = minute
        
        saveUserDefaults()
    }
    
    func updateCurrentAlarmLabel(){
        if (alarmDict["hour"] == nil){
            return
        }
        
        hour = alarmDict["hour"] ?? 12
        minute = alarmDict["minute"] ?? 0
        switch minute {
        case 0 ... 9:
            minuteString = "0" + String(minute)
        default:
            minuteString = String(minute)
        }
        
        if (hour > 12){
            hour -= 12
            meridiem = "PM"
        }
        else{
            meridiem = "AM"
        }
        
        timeLabel.setText("Current Alarm: \n \(String(hour)):\(minuteString) \(meridiem)")
    }
    
    @IBAction func saveButtonPressed() {
        updateDict()
        saveButton.setEnabled(false)
        updateCurrentAlarmLabel()
        saveButton.setTitle("Saved")
        
    }
    
    func loadUserDefaults(){
        let defaults = UserDefaults.standard
        if let contents = defaults.dictionary(forKey: "alarmDict"){
            alarmDict = contents as? [String : Int] ?? [String: Int]()
        }
    }
    
    func saveUserDefaults(){
        UserDefaults.standard.set(alarmDict, forKey: "alarmDict")
    }
    
}
