//
//  InterfaceController.swift
//  Tenacity_Watch Extension
//
//  Created by PLL on 7/26/18.
//  Copyright © 2018 PLL. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    var hapticCount: Int = 5
    var tapCount = 0
//    let seshItems: Dictionary = ["Inputs":[], "TimeStapms":[], "Pof":false]
//    var cycleDic:  = [:]
//    var seshGroups: Dictionary< Int, Dictionary< String, Any > > = [:]
    var seshGroups = [Int:[String:Any]] ()
    var current_cycle: [String] = []
    var current_ts: [TimeInterval] = []
    var cycleCount: Int = 0
    
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
    
    var x = 0
    @IBOutlet var myLabel: WKInterfaceLabel!
    
    func getTime() -> TimeInterval {
        return Date().timeIntervalSince1970
    }
    
    func hapticCallerTap() {
        if (tapCount % hapticCount == 0){
            cycleCount+=1
            WKInterfaceDevice.current().play(.failure)
            seshGroups[cycleCount] = ["cycleInputs":current_cycle,"timeStamps":current_ts,"ToF":false]
            current_cycle.removeAll()
            current_ts.removeAll()
            print(seshGroups)
        }
    }
    func hapticCallerSwipe() {
        if (tapCount % hapticCount == 0){
            cycleCount+=1
            WKInterfaceDevice.current().play(.success)
            seshGroups[cycleCount] = ["cycleInputs":current_cycle,"timeStamps":current_ts,"ToF":true]
            current_cycle.removeAll()
            current_ts.removeAll()
            print(seshGroups)
        }
    }
    
    @IBOutlet var screenTapp: WKTapGestureRecognizer!
    
    @IBAction func screenTap(_ sender: WKTapGestureRecognizer) {
        current_ts.append(getTime())
        tapCount+=1
//        print(String(tapCount)+" "+getTime().description)
        myLabel.setText(String(tapCount))
        current_cycle.append("T")
        hapticCallerTap()
    }
    
    @IBOutlet var swipe: WKSwipeGestureRecognizer!
    
    @IBAction func swipe(_ sender2: WKSwipeGestureRecognizer) {
        tapCount+=1
//        print(String(tapCount)+" "+getTime().description)
        myLabel.setText(String(tapCount))
        current_cycle.append("S")
        hapticCallerSwipe()
    }
    
    
    

}
