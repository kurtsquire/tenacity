//
//  InterfaceController.swift
//  TenacityV2 WatchKit Extension
//
//  Created by PLL on 10/8/18.
//  Copyright © 2018 PLL. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    
    var schedulePressed = false
    @IBOutlet var scheduleButton: WKInterfaceButton!
    @IBOutlet var breatheButton: WKInterfaceButton!
    @IBOutlet var breatheEditButton: WKInterfaceButton!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if context != nil {
            setScheduleStatus()
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    
    @IBAction func scheduleAction() {
        if schedulePressed == false{
            schedulePressed = true
            setScheduleStatus()
        }
        else if schedulePressed == true{
            schedulePressed = false
            scheduleButton.setTitle("Schedule")
            breatheButton.setHidden(false)
            breatheEditButton.setHidden(true)
            scheduleButton.setBackgroundImageNamed("Button")
            scheduleButton.setAlpha(1)
        }
    }
    
    func setScheduleStatus() {
        scheduleButton.setTitle("Editing")
        breatheButton.setHidden(true)
        breatheEditButton.setHidden(false)
    scheduleButton.setBackgroundImageNamed("Pressed")
        scheduleButton.setAlpha(0.9)
    }
    
    @IBAction func editBtnPressed() {
        presentController(withName: "Schedule", context: "Breathe Game")
    }
}
