//
//  RhythmController.swift
//  TenacityV2 WatchKit Extension
//
//  Created by PLL on 4/4/19.
//  Copyright © 2019 PLL. All rights reserved.
//

import WatchKit
import Foundation

class RhythmController: WKInterfaceController {
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBOutlet var BotBtn: WKInterfaceButton!
    @IBOutlet var TopBtn: WKInterfaceButton!
    @IBOutlet var Instructions: WKInterfaceLabel!
    @IBOutlet var InstructionsTap: WKTapGestureRecognizer!
    
    
    @IBAction func InstructionsTapAction(_ sender: Any) {
        Instructions.setHidden(true)
        BotBtn.setHidden(false)
        TopBtn.setHidden(false)
        InstructionsTap.isEnabled = false
    }
    
    @IBAction func TopBtnAction() {
        WKInterfaceDevice.current().play(.failure)
    }
    @IBAction func BotBtnAction() {
        WKInterfaceDevice.current().play(.directionDown)
    }
}
