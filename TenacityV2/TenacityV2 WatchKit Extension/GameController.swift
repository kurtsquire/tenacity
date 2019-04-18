//
//  InterfaceController.swift
//  Tenacity_Watch Extension
//
//  Created by PLL on 7/26/18.
//  Copyright © 2018 PLL. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

//ALL DATA THAT MUST BE USED OUTSIDE OF THE CURRENT SCENE MUST BE PUT HERE
var seconds = 60
var seshGroups = [Int:[String:Any]] ()
var cycleCount: Int = 0
var device = WKInterfaceDevice.current()
var tapCount = 0
var wrong = 0


class GameController: WKInterfaceController, WCSessionDelegate {
    
    var seshbegin = true
    var seshend = false
    var hapticCount: Int = 5
    
    var cycleTapCount = 0 //Logic breaks if a early swipe is performed, to fix this I made a cycle tap count that is compared against haptic count and resets each cycle
    
    var current_cycle: [String] = []
    var current_ts: [Date] = []
    var timer = Timer()
    
    
    @IBOutlet var Arrow: WKInterfaceGroup!
    @IBOutlet var ArrowMove: WKInterfaceGroup!
    @IBOutlet var animebutton: WKInterfaceGroup!
    @IBOutlet var myLabel: WKInterfaceLabel!
    @IBOutlet var screenTapp: WKTapGestureRecognizer!
    @IBOutlet var timerLabel: WKInterfaceLabel!
    @IBOutlet var timerSlider: WKInterfaceSlider!
    @IBOutlet var swipe: WKSwipeGestureRecognizer!
    @IBOutlet var BlackSpot: WKInterfaceGroup!
    @IBOutlet var Ring1: WKInterfaceButton!
    @IBOutlet var Ring2: WKInterfaceButton!
    @IBOutlet var Ring3: WKInterfaceButton!
    @IBOutlet var Ring4: WKInterfaceButton!
    @IBOutlet var Ring5: WKInterfaceButton!
    @IBOutlet var Button: WKInterfaceButton!
    
    //final screen labels
    @IBOutlet var TapAccuracy: WKInterfaceLabel!
    @IBOutlet var GroupAccuracy: WKInterfaceLabel!
    @IBOutlet var BreatheRate: WKInterfaceLabel!
    
    @IBAction func PrintGames() {
        //print("ATTEMPTING TO PRINT GAMES")
        if UserDefaults.standard.object(forKey: "seshnum") != nil{
            let numberValue = UserDefaults.standard.integer(forKey: "seshnum")
            print("Games Played: \(numberValue)")
            for i in 1...numberValue{
                //print("ATTEMPTING TO PRINT GAME \(i)")
                let string_value = "Sesh: " + String(i)
                if UserDefaults.standard.object(forKey: string_value) != nil{
                    let decoded  = UserDefaults.standard.object(forKey: string_value) as! Data
                    let decodedDict = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [Int:[String:Any]]
                    print(decodedDict)
                }
                else{
                    print("ERROR FINDING GAMES")
                }
            }
        }
        else{
            print("No games played")
        }
    }
    
    func EndSesh() {
        if (tapCount != 0){
            if UserDefaults.standard.object(forKey: "seshnum") != nil{
                let numberValue = UserDefaults.standard.integer(forKey: "seshnum")
                UserDefaults.standard.set(numberValue+1, forKey: "seshnum")
            }
            else {
                UserDefaults.standard.set(1, forKey: "seshnum")
            }
            let numberValue = "Sesh: " + String(UserDefaults.standard.integer(forKey: "seshnum"))
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: seshGroups)
            UserDefaults.standard.set(encodedData, forKey: numberValue)
            

            self.presentController(withName: "Breathe Final", context: "finalscene")
        }
    }
    func DisplayInfo() {
        print("Taps: " + String(tapCount))
        print("Wrong: " + String(wrong))
        print("Right " + String(tapCount-wrong))
        GroupAccuracy.setText(getSeshAccuracy(dictionary: seshGroups))
        
        let right = Double(tapCount)-Double(wrong)
        let tapacc = Int((right/Double(tapCount))*Double(100))
        TapAccuracy.setText(String(tapacc)+"%")
        
        let intervalAvg = calcIntervalAvg(intervals: findTimeDeltas(dictionary: seshGroups))    // calculating seconds per breath
        // breaths screen print change to N/a because only one breath
        // let breathsPerSec = Double(1) / intervalAvg                 // changing seconds per breath to breaths ber second
        BreatheRate.setText(String(format:"%.1f", intervalAvg))
    }
    
    @IBAction func StartGame() {
        WKInterfaceController.reloadRootControllers(withNames: ["Breathe"], contexts: ["Breathe"])
    }
    
    @IBAction func timerSlider(_ value: Float) {
        seconds = Int(value)
        timerLabel.setText(String(seconds))
        print(seconds)
    }
    
    @IBAction func Finish() {
        seconds = 60
        seshGroups = [Int:[String:Any]] ()
        cycleCount = 0
        device = WKInterfaceDevice.current()
        tapCount = 0
        wrong = 0
        WKInterfaceController.reloadRootControllers(withNames: ["Main Menu"], contexts: ["Main Menu"])
    }
    
    @objc func counter(){
        seconds -= 1
        print(seconds)
        if (seconds <= 0){
            EndSesh()
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
        
        if dictionary.count == 0 {      // added to fix division by zero bug in return statement
            return "100%"
        }
        
        for (_,dict) in dictionary {
            for (dataType, data) in dict{
                if dataType == "ToF" && isEqual(type: Bool.self, a: data, b: true) == true{
                    true_total+=1
                }
            }
            total+=1
        }
        
        return String(Int(true_total/total*100)) + "%"
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
            WKInterfaceDevice.current().play(.click)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { // change 2 to desired number of seconds
            self.Ring1.setAlpha(0.5)
            self.Ring2.setAlpha(1)
            self.Ring3.setAlpha(0.5)
            self.BlackSpot.setAlpha(1)
            self.Button.setAlpha(0)
            WKInterfaceDevice.current().play(.click)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { // change 2 to desired number of seconds
            self.Ring1.setAlpha(0)
            self.Ring2.setAlpha(0.5)
            self.Ring3.setAlpha(1)
            self.Ring4.setAlpha(0.5)
            self.set_black(set: 45)
            WKInterfaceDevice.current().play(.click)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { // change 2 to desired number of seconds
            self.Ring2.setAlpha(0)
            self.Ring3.setAlpha(0.5)
            self.Ring4.setAlpha(1)
            self.Ring5.setAlpha(0.5)
            self.set_black(set: 60)
            WKInterfaceDevice.current().play(.click)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // change 2 to desired number of seconds
            self.Ring3.setAlpha(0)
            self.Ring4.setAlpha(0.5)
            self.Ring5.setAlpha(1)
            self.set_black(set: 75)
            WKInterfaceDevice.current().play(.click)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { // change 2 to desired number of seconds
            self.Ring4.setAlpha(0)
            self.Ring5.setAlpha(0.5)
            self.set_black(set: 90)
            WKInterfaceDevice.current().play(.click)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { // change 2 to desired number of seconds
            self.Ring5.setAlpha(1)
            self.reset_black()
            WKInterfaceDevice.current().play(.click)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // change 2 to desired number of seconds
            if(self.cycleTapCount == (self.hapticCount-1)){
                self.animebutton.setHidden(true)
                self.Arrow.setHidden(false)
            }
        }
    }
    
    func animateArrow(success: Bool) -> Void {
        if (success){
            animate(withDuration: 1) {
                self.ArrowMove.setWidth(200)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // change 2 to desired number of seconds
                self.ArrowMove.setWidth(0)
                self.Arrow.setHidden(true)
                self.animebutton.setHidden(false)
            }
        }
        
        else{
            Arrow.setHidden(true)
            animebutton.setHidden(false)
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
        var correct = ""
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
        correct = hapticCallerTap()
        
        //DATA STUFF -------------------
        let session = WCSession.default
        if session.activationState == .activated{
            let timestamp = NSDate().timeIntervalSince1970
            
            let data = ["game": "breathe",
                        "what": "tap",
                        "correct": String(correct),
                        "time": String(timestamp)]
            session.transferUserInfo(data)
        }
        ////////////////////
    }
    
    func swipes() -> Void{
        var correct = ""
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
        correct = hapticCallerSwipe()
        
        //DATA STUFF -------------------
        let session = WCSession.default
        if session.activationState == .activated{
            let timestamp = NSDate().timeIntervalSince1970
            
            let data = ["game": "breathe",
                        "what": "swipe",
                        "correct": String(correct),
                        "time": String(timestamp)]
            session.transferUserInfo(data)
        }
        ////////////////////
    }
    
    @IBAction func buttontap(_ sender: WKTapGestureRecognizer) {
        tap()
    }
    
    @IBAction func buttonswipe(_ sender: WKSwipeGestureRecognizer) {
        swipes()
    }
    
    @IBAction func arrowTap(_ sender: Any) {
        tap()
    }
    
    @IBAction func arrowSwipe(_ sender: Any) {
        swipes()
    }
    
    @IBAction func screenTap(_ sender: WKTapGestureRecognizer) {
        seshbegin = false
        myLabel.setHidden(true)
        animebutton.setHidden(false)
    }
    
    
    func success() {
        cycleCount+=1
        WKInterfaceDevice.current().play(.success)
        seshGroups[cycleCount] = ["cycleInputs":current_cycle,"timeStamps":current_ts,"ToF":true]
        current_cycle.removeAll()
        current_ts.removeAll()
        cycleTapCount = 0
        animateArrow(success:true)
        print(seshGroups)
        print(getSeshAccuracy(dictionary: seshGroups))
    }
    
    func fail(){
        cycleCount+=1
        wrong+=1
        WKInterfaceDevice.current().play(.stop)
        seshGroups[cycleCount] = ["cycleInputs":current_cycle,"timeStamps":current_ts,"ToF":false]
        current_cycle.removeAll()
        current_ts.removeAll()
        cycleTapCount = 0
        animateArrow(success: false)
        print(seshGroups)
        print(getSeshAccuracy(dictionary: seshGroups))
    }
    
    func hapticCallerTap() -> String{
        var correct = ""
        if (cycleTapCount % hapticCount == 0){
            fail()
            correct = "false"
            return correct
        }
        if (cycleTapCount == (hapticCount - 1)){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                WKInterfaceDevice.current().play(.directionDown)
            }
            correct = "true"
        }
        /// Richie Added
        else {
            correct = "true"
        }
        ///
        return correct
    }
    func hapticCallerSwipe() -> String{
        var correct = ""
        if (cycleTapCount % hapticCount == 0){
            success()
            correct = "true"
        }
        else{
            fail()
            correct = "false"
        }
        return correct
        
        // data sending
//        let session = WCSession.default
//        if session.activationState == .activated{
//            let timestamp = NSDate().timeIntervalSince1970
//
//            let currInfo = seshGroups[cycleCount]
//
//            let data = ["game": "breathe",
//                        "what": currInfo["cycleInputs"]!,
//                        "correct": correct,
//                        "time": String(timestamp)]
//            session.transferUserInfo(data)
//        //
        
        
    }
    
    func findTimeDeltas(dictionary:[Int:[String:Any]]) -> [TimeInterval] {  // call this function in calculateBreathRate to gather time deltas
        
        var timeDeltas : [TimeInterval] = []    // creating empty array
        
        if dictionary.isEmpty == true {         // checking to see if there were any inputs/tap groups
            return timeDeltas                   // return empty array if dictionary is empty
        }
        
        for (groupNum, dict) in dictionary {
            
            let stampList = dict["timeStamps"] as! [Date]
            var i = 0                                   // counter for (n-1)th date object in array
            
            if groupNum == 1 {
                if dict.count > 1 {                     // if first group contains more than one date object
                    for stamp in stampList[1...]{       // skip first date, iterate over other dates in the array
                        
                        timeDeltas.append(stamp.timeIntervalSince(stampList[i]))    // append time difference of (n)th date - (n-1)th date
                        i += 1                          // increment counter
                    }
                }
            } else {
                let lastStamp = (dictionary[groupNum - 1]!["timeStamps"] as! [Date]).last   // find the last date in the previous group
                let currStamp = (dict["timeStamps"] as! [Date]).first                       // find the first date in the current group
                
                timeDeltas.append((currStamp!.timeIntervalSince(lastStamp!)))       // appending timeInterval between first date of current group and last date of previous group
                
                if dict.count > 1 {
                    for stamp in stampList[1...]{       // skip first date, iterate over other dates in the list
                        
                        timeDeltas.append(stamp.timeIntervalSince(stampList[i]))    // append time difference of (n)th date - (n-1)th date
                        i += 1                          // increment counter
                    }
                }
            }
        }
        return timeDeltas
    }
    
    func calcIntervalAvg(intervals: [TimeInterval]) -> Double {     // calculates the average of a list of intervals
        var intervalAvg = Double()
        var intervalSum = Double()
        let intervalCount = Double(intervals.count)
        
        for time in intervals {
            intervalSum += time
        }
        
        
        intervalAvg = (intervalSum / intervalCount)
        
        return intervalAvg
    }
    
        override func awake(withContext context: Any?) {
            super.awake(withContext: context)
            
            if WCSession.isSupported(){
                let session = WCSession.default
                session.delegate = self
                session.activate()
            }
                
            if(context == nil){
                print("nope")
            }
            else if (isEqual(type: String.self, a: context as Any, b: "finalscene"))!{
                WKInterfaceController.reloadRootControllers(withNames: ["Breathe Final"], contexts: ["final"])
                DisplayInfo()
            }
            else if (isEqual(type: String.self, a: context as Any, b: "final"))!{
                DisplayInfo()
            }
            else if (isEqual(type: String.self, a: context as Any, b: "game"))!{
                WKInterfaceController.reloadRootControllers(withNames: ["Breathe"], contexts: ["Breathe"])
            }
            // Configure interface objects here.
        }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
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
