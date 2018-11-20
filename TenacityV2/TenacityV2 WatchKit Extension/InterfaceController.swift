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
    let breatheGame = "Breathe Game"
    let lineAtkGame = "Line Attack Game"
    let gpsDrawGame = "GPS Draw Game"
    @IBOutlet var scheduleButton: WKInterfaceButton!
    @IBOutlet var breatheBtnGrp: WKInterfaceGroup!
    @IBOutlet var breatheTimeLabel: WKInterfaceLabel!
    @IBOutlet var lineAtkBtnGrp: WKInterfaceGroup!
    @IBOutlet var lineAtkTimeLabel: WKInterfaceLabel!
    @IBOutlet var gpsDrawBtnGrp: WKInterfaceGroup!
    @IBOutlet var gpmDrawTimeLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        setTitle("")
        if let timeApm = context as? [String: String]{
            if timeApm["game"] == breatheGame {
                breatheTimeLabel.setHidden(false)
                breatheTimeLabel.setText(timeApm["content"])
            }
            else if timeApm["game"] == lineAtkGame {
                lineAtkTimeLabel.setHidden(false)
                lineAtkTimeLabel.setText(timeApm["content"])
            }
            else if timeApm["game"] == gpsDrawGame {
                gpmDrawTimeLabel.setHidden(false)
                gpmDrawTimeLabel.setText(timeApm["content"])
            }
        }
        else{
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
            lineAtkBtnGrp.setBackgroundColor(editColor)
            gpsDrawBtnGrp.setBackgroundColor(editColor)
        }
        else if schedulePressed == true{
            schedulePressed = false
            var defaultColor = UIColor.init(red: 32/255, green: 148/255, blue: 250/255, alpha: 1)
            scheduleButton.setTitle("Schedule")
            breatheBtnGrp.setBackgroundColor(defaultColor)
            lineAtkBtnGrp.setBackgroundColor(defaultColor)
            gpsDrawBtnGrp.setBackgroundColor(defaultColor)
        }
    }
    
    @IBAction func breatheBtnPressed() {
        if schedulePressed == false{
            presentController(withName: "Breathe Main", context: "Breathe Game")
        }
        else{
            presentController(withName: "Schedule", context: breatheGame)
        }
    }
    
    @IBAction func lineAtkBtnPressed() {
        if schedulePressed == false{
            print("line atk btn clicked")
        }
        else{
            presentController(withName: "Schedule", context: lineAtkGame)
        }
    }
    
    @IBAction func gpsDrawBtnPressed() {
        if schedulePressed == false{
            print("gps draw btn clicked")
        }
        else{
            presentController(withName: "Schedule", context: gpsDrawGame)
        }
    }
}
