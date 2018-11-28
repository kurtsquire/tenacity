//
//  InterfaceController.swift
//  Tenacity_Watch Extension
//
//  Created by PLL on 7/26/18.
//  Copyright © 2018 PLL. All rights reserved.
//

import WatchKit
import Foundation

//ALL DATA THAT MUST BE USED OUTSIDE OF THE CURRENT SCENE MUST BE PUT HERE
var seconds = 60
var seshGroups = [Int:[String:Any]] ()
var cycleCount: Int = 0
var device = WKInterfaceDevice.current()

class GameController: WKInterfaceController {
    
    var seshbegin = true
    var seshend = false
    var hapticCount: Int = 5
    var tapCount = 0
    var cycleTapCount = 0 //Logic breaks if a early swipe is performed, to fix this I made a cycle tap count that is compared against haptic count and resets each cycle
    
    var current_cycle: [String] = []
    var current_ts: [Date] = []
    var timer = Timer()
    
    @IBOutlet var animebutton: WKInterfaceGroup!
    @IBOutlet var myLabel: WKInterfaceLabel!
    @IBOutlet var screenTapp: WKTapGestureRecognizer!
    @IBOutlet var EndSessionButton: WKInterfaceButton!
    @IBOutlet var timerLabel: WKInterfaceLabel!
    @IBOutlet var ReHome: WKInterfaceButton!
    @IBOutlet var timerSlider: WKInterfaceSlider!
    @IBOutlet var swipe: WKSwipeGestureRecognizer!
    @IBOutlet var BlackSpot: WKInterfaceGroup!
    @IBOutlet var Ring1: WKInterfaceButton!
    @IBOutlet var Ring2: WKInterfaceButton!
    @IBOutlet var Ring3: WKInterfaceButton!
    @IBOutlet var Ring4: WKInterfaceButton!
    @IBOutlet var Ring5: WKInterfaceButton!
    @IBOutlet var BreatheButton: WKInterfaceButton!
    @IBOutlet var Button: WKInterfaceButton!
    
    @IBAction func EndSession() {
        seshend = true
        EndSessionButton.setEnabled(false)
        EndSessionButton.setHidden(true)
        ReHome.setEnabled(true)
        ReHome.setHidden(false)
        myLabel.setHidden(false)
        animebutton.setHidden(true)
        myLabel.setText("Cycles: \(cycleCount) \n Session Accuracy: \(getSeshAccuracy(dictionary: seshGroups))")
    }
    

    @IBAction func ReturnHome() {
        self.popToRootController()
    }

    @IBAction func timerSlider(_ value: Float) {
        seconds = Int(value)
        timerLabel.setText(String(seconds))
        print(seconds)
    }
    
    
    @objc func counter(){
        seconds -= 1
        print(seconds)
        if (seconds == 0){
            timer.invalidate()
        }
    }
    
    func StartSessionTimer(){
        if (tapCount == 0){
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector (GameController.counter), userInfo: nil, repeats: true)
        }
    }
    
    
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
    
    func animatebutton() -> Void {
        Ring5.setAlpha(0)
        set_black(set: 30)
        BlackSpot.setAlpha(0)
        Button.setAlpha(1)
        Ring1.setAlpha(0.5)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // change 2 to desired number of seconds
            self.Ring1.setAlpha(1)
            self.Ring2.setAlpha(0.5)
            self.BlackSpot.setAlpha(0.5)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { // change 2 to desired number of seconds
            self.Ring1.setAlpha(0.5)
            self.Ring2.setAlpha(1)
            self.Ring3.setAlpha(0.5)
            self.BlackSpot.setAlpha(1)
            self.Button.setAlpha(0)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { // change 2 to desired number of seconds
            self.Ring1.setAlpha(0)
            self.Ring2.setAlpha(0.5)
            self.Ring3.setAlpha(1)
            self.Ring4.setAlpha(0.5)
            self.set_black(set: 45)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { // change 2 to desired number of seconds
            self.Ring2.setAlpha(0)
            self.Ring3.setAlpha(0.5)
            self.Ring4.setAlpha(1)
            self.Ring5.setAlpha(0.5)
            self.set_black(set: 60)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // change 2 to desired number of seconds
            self.Ring3.setAlpha(0)
            self.Ring4.setAlpha(0.5)
            self.Ring5.setAlpha(1)
            self.set_black(set: 75)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { // change 2 to desired number of seconds
            self.Ring4.setAlpha(0)
            self.Ring5.setAlpha(0.5)
            self.set_black(set: 90)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { // change 2 to desired number of seconds
            self.Ring5.setAlpha(1)
            self.reset_black()
        }
    }
    
    func reset_black() -> Void {
        BlackSpot.setWidth(100)
        BlackSpot.setHeight(100)
        BlackSpot.setCornerRadius(100/2)
        BlackSpot.setAlpha(1)
        return
    }
    
    func set_black(set: CGFloat) -> Void {
        BlackSpot.setWidth(set)
        BlackSpot.setHeight(set)
        BlackSpot.setCornerRadius(set/2)
        return
    }
    
    func tap() -> Void {
        if(seshend){
            return
        }
        if(seshbegin){
            animatebutton()
            seshbegin = false
            myLabel.setHidden(true)
            animebutton.setHidden(false)
        }
        StartSessionTimer()
        current_ts.append(Date())
        tapCount+=1
        cycleTapCount+=1
        animatebutton()
        myLabel.setText(String(tapCount))
        current_cycle.append("T")
        hapticCallerTap()
    }
    
    func swipes() -> Void{
        if(seshend){
            return
        }
        if(seshbegin){
            animatebutton()
            seshbegin = false
            myLabel.setHidden(true)
            animebutton.setHidden(false)
        }
        current_ts.append(Date())
        tapCount+=1
        cycleTapCount+=1
        animatebutton()
        myLabel.setText(String(tapCount))
        current_cycle.append("S")
        hapticCallerSwipe()
    }
    
    @IBAction func buttontap(_ sender: WKTapGestureRecognizer) {
        tap()
    }
    
    @IBAction func buttonswipe(_ sender: WKSwipeGestureRecognizer) {
        swipes()
    }
    

    
    @IBAction func screenTap(_ sender: WKTapGestureRecognizer) {
        tap()
        
    }
    

    
    @IBAction func swipe(_ sender2: WKSwipeGestureRecognizer) {
        swipes()
    }
    
    func success() {
        cycleCount+=1
        WKInterfaceDevice.current().play(.success)
        seshGroups[cycleCount] = ["cycleInputs":current_cycle,"timeStamps":current_ts,"ToF":true]
        current_cycle.removeAll()
        current_ts.removeAll()
        cycleTapCount = 0
        animatebutton()
        print(seshGroups)
        print(getSeshAccuracy(dictionary: seshGroups))
    }
    
    func fail(){
        cycleCount+=1
        WKInterfaceDevice.current().play(.failure)
        seshGroups[cycleCount] = ["cycleInputs":current_cycle,"timeStamps":current_ts,"ToF":false]
        current_cycle.removeAll()
        current_ts.removeAll()
        cycleTapCount = 0
        animatebutton()
        print(seshGroups)
        print(getSeshAccuracy(dictionary: seshGroups))
    }
    
    func hapticCallerTap() {
        if (cycleTapCount % hapticCount == 0){
            fail()
        }
    }
    func hapticCallerSwipe() {
        if (cycleTapCount % hapticCount == 0){
            success()
        }
        else{
            fail()
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
