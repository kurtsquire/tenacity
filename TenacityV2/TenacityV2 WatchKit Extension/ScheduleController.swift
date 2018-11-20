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
    @IBOutlet var GameName: WKInterfaceLabel!
    @IBOutlet var AddBtn: WKInterfaceButton!
    
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
            return ["content": self.time + " " + self.apm, "game": self.game]
        }

        return ""
    }
    
}
