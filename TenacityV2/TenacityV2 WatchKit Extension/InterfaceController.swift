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
    @IBOutlet var breatheBtnGrp: WKInterfaceGroup!
    @IBOutlet var breatheButton: WKInterfaceButton!
    @IBOutlet var breatheFreLabel: WKInterfaceLabel!
    @IBOutlet var breatheTimeLabel: WKInterfaceLabel!
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        setTitle("")
        if context != nil {
            breatheTimeLabel.setText(context as! String)
        }
        else{
            breatheFreLabel.setHidden(true)
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
            scheduleButton.setTitle("Editing")
            var editColor = UIColor.init(red: 90/255, green: 200/255, blue: 250/255, alpha: 1)
            breatheBtnGrp.setBackgroundColor(editColor)
        }
        else if schedulePressed == true{
            schedulePressed = false
            var defaultColor = UIColor.init(red: 32/255, green: 148/255, blue: 250/255, alpha: 1)
            scheduleButton.setTitle("Schedule")
            breatheBtnGrp.setBackgroundColor(defaultColor)
        }
    }
    
    @IBAction func breatheBtnPressed() {
        if schedulePressed == false{
            presentController(withName: "Breathe Main", context: "Breathe Game")
        }
        else{
            presentController(withName: "Schedule", context: "Breathe Game")
        }
    }
}
