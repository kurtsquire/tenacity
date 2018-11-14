//
//  ScheduleController.swift
//  TenacityV2 WatchKit Extension
//
//  Created by Hangzhi Pang on 11/13/18.
//  Copyright © 2018 PLL. All rights reserved.
//

import WatchKit
import Foundation


class ScheduleController: WKInterfaceController {

    @IBOutlet var TimePicker: WKInterfacePicker!
    @IBOutlet var APMPicker: WKInterfacePicker!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        let timePickerItems: [WKPickerItem] = (0...12).map {
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

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func APMPicker(_ value: Int) {
          NSLog("Time Picker: \(["AM","PM"][value]) selected.")
    }
    
    @IBAction func pickerSelectedItem(_ value: Int) {
        NSLog("Time Picker: \(Array((0...12))[value]) selected.")
    }
}
