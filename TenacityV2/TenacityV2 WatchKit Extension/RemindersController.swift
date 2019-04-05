//
//  Reminders.swift
//  TenacityV2 WatchKit Extension
//
//  Created by PLL on 4/4/19.
//  Copyright © 2019 PLL. All rights reserved.
//

import WatchKit
import Foundation

class RemindersController: WKInterfaceController {
    
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
    
    @IBOutlet var InstructionsLabel: WKInterfaceLabel!
    
}
