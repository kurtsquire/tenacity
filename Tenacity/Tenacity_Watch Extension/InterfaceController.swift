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
    
    func hapticCallerTap() {
        if (tapCount % hapticCount == 0){
            WKInterfaceDevice.current().play(.failure)
        }
    }
    func hapticCallerSwipe() {
        if (tapCount % hapticCount == 0){
            WKInterfaceDevice.current().play(.success)
        }
    }
    
    @IBOutlet var screenTapp: WKTapGestureRecognizer!
    
    @IBAction func screenTap(_ sender: WKTapGestureRecognizer) {
        tapCount+=1
        print(String(tapCount)+" "+String(NSDate().timeIntervalSince1970))
        myLabel.setText(String(tapCount))
        hapticCallerTap()
    }
    
    @IBOutlet var swipe: WKSwipeGestureRecognizer!
    
    @IBAction func swipe(_ sender2: WKSwipeGestureRecognizer) {
        tapCount+=1
        print(String(tapCount)+" "+String(NSDate().timeIntervalSince1970))
        myLabel.setText(String(tapCount))
        hapticCallerSwipe()
    }
    
    
    

}
