//
//  NudgesViewController.swift
//  TenacityV3
//
//  Created by Richie on 8/30/19.
//  Copyright © 2019 PLL. All rights reserved.
//


// Controls the Nudges tab

import UIKit
import UserNotifications

var editingNudge = 0

class NudgesViewController: PhoneViewController{
    
    
    @IBOutlet var nudgeButtons: [UIButton]!
    @IBOutlet var switches: [UISwitch]!
    var nudgesTutorialCompleted = false
    
    @IBAction func nudgePressed(_ sender: UIButton) {
        editingNudge = sender.tag
    }
    
    override func viewDidAppear(_ animated: Bool) { //openign back up the tab (works from other tabs)
        super.viewDidAppear(animated)
        
        testUserDefaults()
        
        if !nudgesTutorialCompleted{
            let storyBoard: UIStoryboard = UIStoryboard(name: "Nudges", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "Nudges Popup")

            self.present(newViewController, animated: true, completion: nil)
        }
    }
    
    // no switches
    @IBAction func switchAction(_ sender: UISwitch) {
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
        
        nudgesTutorialCompleted = UserDefaults.standard.bool(forKey: "nudgesTutorialCompleted")
    }
    
    
}
