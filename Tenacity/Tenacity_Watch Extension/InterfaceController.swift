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
    var cycleTapCount = 0 //Logic breaks if a early swipe is performed, to fix this I made a cycle tap count that is compared against haptic count and resets each cycle
    var seshGroups = [Int:[String:Any]] ()
    var current_cycle: [String] = []
    var current_ts: [Date] = []
    var cycleCount: Int = 0
    
    
    //Gets session accuracy and returns it as a string. Needs to be improved so that it shows a percent and not a decimal
    func getSeshAccuracy(dictionary:[Int:[String:Any]]) -> String {
        var total: Float = 0
        var true_total: Float = 0
        for (_,dict) in dictionary {
            for (dataType, data) in dict{
                if dataType == "ToF" && isEqual(type: Bool.self, a: data, b: true) == true{
                    true_total+=1
                }
            }
            total+=1
        }
        print(total)
        print(true_total)
        return String(Double(true_total/total*100)) + "%"
    }
 
    // This function is used to compare Any variable types as swift will not let you use the == comparison if a var is declared as Any
    func isEqual<T: Equatable>(type: T.Type, a: Any, b: Any) -> Bool? {
        guard let a = a as? T, let b = b as? T else { return nil }
        
        return a == b
    }
    
    
    @IBOutlet var myLabel: WKInterfaceLabel!
    
    @IBOutlet var screenTapp: WKTapGestureRecognizer!
    
    @IBAction func screenTap(_ sender: WKTapGestureRecognizer) {
        current_ts.append(Date())
        tapCount+=1
        cycleTapCount+=1
        myLabel.setText(String(tapCount))
        current_cycle.append("T")
        hapticCallerTap()
    }
    
    @IBOutlet var swipe: WKSwipeGestureRecognizer!
    
    @IBAction func swipe(_ sender2: WKSwipeGestureRecognizer) {
        current_ts.append(Date())
        tapCount+=1
        cycleTapCount+=1
        myLabel.setText(String(tapCount))
        current_cycle.append("S")
        hapticCallerSwipe()
    }
    
    func hapticCallerTap() {
        if (cycleTapCount % hapticCount == 0){
            cycleCount+=1
            WKInterfaceDevice.current().play(.failure)
            seshGroups[cycleCount] = ["cycleInputs":current_cycle,"timeStamps":current_ts,"ToF":false]
            current_cycle.removeAll()
            current_ts.removeAll()
            cycleTapCount = 0
            print(seshGroups)
            print(getSeshAccuracy(dictionary: seshGroups))
        }
    }
    func hapticCallerSwipe() {
        if (cycleTapCount % hapticCount == 0){
            cycleCount+=1
            WKInterfaceDevice.current().play(.success)
            seshGroups[cycleCount] = ["cycleInputs":current_cycle,"timeStamps":current_ts,"ToF":true]
            current_cycle.removeAll()
            current_ts.removeAll()
            cycleTapCount = 0
            print(seshGroups)
            print(getSeshAccuracy(dictionary: seshGroups))
        }
        else{
            cycleCount+=1
            WKInterfaceDevice.current().play(.failure)
            seshGroups[cycleCount] = ["cycleInputs":current_cycle,"timeStamps":current_ts,"ToF":false]
            current_cycle.removeAll()
            current_ts.removeAll()
            cycleTapCount = 0
            print(seshGroups)
            print(getSeshAccuracy(dictionary: seshGroups))
        }
    }
    
    //    override func awake(withContext context: Any?) {
    //        super.awake(withContext: context)
    //        // Configure interface objects here.
    //    }
    //
    //    override func willActivate() {
    //        // This method is called when watch view controller is about to be visible to user
    //        super.willActivate()
    //    }
    //
    //    override func didDeactivate() {
    //        // This method is called when watch view controller is no longer visible
    //        super.didDeactivate()
    //    }
    

}
