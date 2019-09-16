//
//  NudgesViewController.swift
//  TenacityV3
//
//  Created by Richie on 8/30/19.
//  Copyright © 2019 PLL. All rights reserved.
//

import UIKit
import UserNotifications

var editingNudge = 0

class NudgesViewController: PhoneViewController{
    
    
    @IBOutlet var nudgeButtons: [UIButton]!
    @IBOutlet var switches: [UISwitch]!

    
    @IBAction func nudgePressed(_ sender: UIButton) {
        editingNudge = sender.tag

    }
    
    override func viewDidAppear(_ animated: Bool) { //openign back up the tab (works from other tabs)
        super.viewDidAppear(animated)
        
        testUserDefaults()
    }
    
    // no switches
    @IBAction func switchAction(_ sender: UISwitch) {
        //print(sender.tag)
        //print(sender.isOn)
        if (sender.isOn){
            //turn notification on
            // tell realm notification (time) is on
        }
        else{
            //turn notification off
            // tell realm notification is off
        }
    }
    
    override func testUserDefaults(){
        let defaults = UserDefaults.standard
        
        var i = 0
        for  button in nudgeButtons{
            button.setTitle(defaults.string(forKey: "dateString" + String(i)) ?? "No Current Nudge", for: .normal)
            i += 1
        }
    }
    
    
}
