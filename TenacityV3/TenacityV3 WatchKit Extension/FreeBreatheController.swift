//
//  FreeBreatheController.swift
//  TenacityV3 WatchKit Extension
//
//  Created by PLL on 5/22/19.
//  Copyright © 2019 PLL. All rights reserved.
//

import WatchKit
import WatchConnectivity

//var FullCycle = 5
//var sessionTime = 2
var timeFree = 0.0
//var correctCyclesTotal = 0
var cycleTotalFree = 0

var totalBreathsFree = 0
var averageFullBreatheTimeFree = 3.5
var cycleDict = [String : Int]()

class FreeBreatheController: WatchViewController{
    
    let startRelativeHeight = 0.5
    let startRelativeWidth = 0.5
    
    var counter = 0.0
    
    var totalBreatheTimes = 35.0
    //var resetInterval = 2.5   unused right now
    
    var breatheInTimer = Timer()
    var breatheInTime = 0.0
    var gameLengthTimer = Timer()
    
    var cycleStep = 0
    @IBOutlet weak var holdNumberLabel: WKInterfaceLabel!
    
    
    let customBlue =  UIColor(red:0.102, green: 0.788, blue: 0.827, alpha: 1.0)
    let customRed = UIColor(red: 0.77, green: 0.19, blue: 0.34, alpha: 1.0)
    let customPink = UIColor(red: 0.96, green: 0.62, blue: 0.16, alpha: 1.0) // saffron
    let customGreen = UIColor(red: 0.71, green: 0.49, blue: 0.86, alpha: 1.0) //lavender
    
    lazy var customColors = [customBlue, customPink, customRed, customGreen]
    
    /////////////////////////// Tutorial ---------------------------------------
    
    @IBAction func tutorial2Tapped(_ sender: Any) {
        WKInterfaceController.reloadRootControllers(withNames: ["FreeBreathe Main"], contexts: ["start"])
        
        //resets global variables
        timeFree = 0.0
        cycleTotalFree = 0
        totalBreathsFree = 0
        averageFullBreatheTimeFree = 3.5
        cycleDict.removeAll()
        inGame = true
        
        sendData(what: "start game")
        
    //  Game Length Timer
        gameLengthTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector (BreatheController.sessionCounter), userInfo: nil, repeats: true)
    }
    
    ///// start screen
    
    @IBOutlet weak var prevSessionLabel: WKInterfaceLabel!
    
    ////////////////////  Results Screen Page ----------------------------------
    
    @IBOutlet var averageBreathLabel: WKInterfaceLabel!
    @IBOutlet var timePlayedLabel: WKInterfaceLabel!
    @IBOutlet var totalCyclesLabel: WKInterfaceLabel!
    @IBOutlet var totalBreathsLabel: WKInterfaceLabel!
    @IBAction func resultScreenTapped(_ sender: Any) {
        WKInterfaceController.reloadRootControllers(withNames: ["Main Menu"], contexts: [""])
    }
    
    ////////////////////////////////////////
    
    @IBOutlet weak var image: WKInterfaceImage!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        //let sample = ["1":2]
        //UserDefaults.standard.set
        
        // awake transition from game -> results screen
        if ((context as? String) == "Breathe Done"){
            UserDefaults.standard.set(cycleDict, forKey: "cycleDict")
            
            if (cycleDict.count > 0){
                var result = ""
                for (key, value) in cycleDict.sorted(by: { $0.value > $1.value }){
                    result += "\n"
                    result += "\(String(key)) breaths : \(String(value))x"
                }
                totalCyclesLabel.setText(result)
            }
            else{
                totalCyclesLabel.setText("Total Cycles: " + String(cycleTotalFree))
            }
            
            totalBreathsLabel.setText("Total Breaths: " + String(totalBreathsFree))
            timePlayedLabel.setText("Time Played: " + String(Int(timeFree)) + "s")
            averageBreathLabel.setText("Avg Breath Time: " + String(format: "%.1f", averageFullBreatheTimeFree) + "s")
        }
        
        // On awake transition from tutorial 2
        else if ((context as? String) == "start"){
            updateTheme()
            self.image.setTintColor(resetColor)
        }
        
        // On awake transition from main menu
        else if ((context as? String) == "from Menu"){
            testUserDefaults()
            if (cycleDict.count == 1 && cycleDict["0"] == 0){
                prevSessionLabel.setText("No Previous Session")
            }
            else if (cycleDict.count > 0){
                var result = ""
                for (key, value) in cycleDict.sorted(by: { $0.value > $1.value }){
                    result += "\(String(key)) breaths : \(String(value))x\n"
                }
                prevSessionLabel.setText(result)
            }
            
            else{
                prevSessionLabel.setText("No Previous Session")
            }
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
    
    func endGame(){
        inGame = false
        
        UserDefaults.standard.set(cycleDict, forKey: "cycleDict")
        sendData(what: "end game", timePlayed : timeFree, avgBreathLength : averageFullBreatheTimeFree, totalSets : cycleTotalFree, breatheCycleDict: cycleDict)
        WKInterfaceController.reloadRootControllers(withNames: ["FreeBreathe Results"], contexts: ["Breathe Done"])
    }
    
    @IBAction func forceQuit() { //stops game and goes to results screen
        breatheInTimer.invalidate()
        endGame()
    }
    
    @objc func sessionCounter(){
        timeFree += 0.1
        if (inGame == false){
            gameLengthTimer.invalidate()
        }
    }
    
    @objc func breatheInCounter(){
        if (counter < averageFullBreatheTimeFree){
            animate(withDuration: 0.1){
                //self.alpha = (self.counter/self.averageFullBreatheTimeFree)
                //self.image.setAlpha(CGFloat(self.alpha))
                let addHeight = (1 - self.startRelativeWidth)*(self.counter/averageFullBreatheTimeFree)
                let addWidth = (1 - self.startRelativeHeight)*(self.counter/averageFullBreatheTimeFree)
                self.image.setRelativeWidth(CGFloat(self.startRelativeWidth + addWidth), withAdjustment: 0)
                self.image.setRelativeHeight(CGFloat(self.startRelativeHeight + addHeight), withAdjustment: 0)
                self.counter += 0.1
            }
        }
        WKInterfaceDevice.current().play(.directionUp)
        breatheInTime += 0.1
    }
    
    func resetImage(){
        self.image.setRelativeWidth(CGFloat(startRelativeWidth), withAdjustment: 0)
        self.image.setRelativeHeight(CGFloat(startRelativeHeight), withAdjustment: 0)
    }
    
    func cycleReset(){ //goes back to step one
        cycleTotalFree += 1
        cycleStep = 0
        //self.image.setImageNamed("breathey")
        animate(withDuration: 1){
            self.image.setTintColor(resetColor)
        }
    }
    
    @IBAction func swipeAction(_ sender: Any) {
        
        animate(withDuration: 0.1){
            self.image.setRelativeWidth(CGFloat(1), withAdjustment: 0)
            self.image.setRelativeHeight(CGFloat(1), withAdjustment: 0)
        }
        animate(withDuration: 0.25){
            self.image.setRelativeWidth(CGFloat(self.startRelativeWidth), withAdjustment: 0)
            self.image.setRelativeHeight(CGFloat(self.startRelativeHeight), withAdjustment: 0)
        }
        holdNumberLabel.setText(String(cycleStep))
        holdNumberLabel.setHidden(false)
        
        sendData(what: "swipe")
        WKInterfaceDevice.current().play(.success)
        
        
        ///// insert into dict
        cycleDict[String(cycleStep)] = (cycleDict[String(cycleStep)] ?? 0) + 1
        cycleReset()
    }
    
    @IBAction func longPressHold(_ gestureRecognizer: WKLongPressGestureRecognizer) {
        
        if gestureRecognizer.state == .began{
            resetImage()
            holdNumberLabel.setHidden(true)
            
            counter = 0
            breatheInTime = 0

            sendData(what: "start hold")
            
            breatheInTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector (BreatheController.breatheInCounter), userInfo: nil, repeats: true)
            
            cycleStep += 1
        }
        else if gestureRecognizer.state == .ended || gestureRecognizer.state == .cancelled{
            breatheInTimer.invalidate()
            print("breathe in time: " + String(format: "%.3f", breatheInTime))
            totalBreathsFree += 1
            print("total breaths: " + String(totalBreathsFree))
            
            addToAverageBreatheTime(time: breatheInTime)
            print("new avg: " + String(format: "%.3f", averageFullBreatheTimeFree))
            
            //Can use "(breatheInTime - offset)" or global var "resetInterval" for "withDuration"
            var shrinkInterval = (0.8)*(breatheInTime)
            
            if (shrinkInterval > 2.5){
                shrinkInterval = 2.5
            }
            
            animate(withDuration: shrinkInterval){
                self.image.setRelativeWidth(CGFloat(self.startRelativeWidth), withAdjustment: 0)
                self.image.setRelativeHeight(CGFloat(self.startRelativeHeight), withAdjustment: 0)
            }

            animate(withDuration: 1){
                self.image.setTintColor(self.customColors[breatheColor])
            }
            sendData(what: "stop hold")
        }
    }
    
    func addToAverageBreatheTime(time : Double){
        totalBreatheTimes = totalBreatheTimes + time
        averageFullBreatheTimeFree = totalBreatheTimes/Double((totalBreathsFree + 10))
    }
    
    func testUserDefaults(){
        let defaults = UserDefaults.standard
        cycleDict = defaults.dictionary(forKey: "cycleDict") as? [String : Int] ?? ["0": 0]
        breatheTheme = defaults.string(forKey: "breatheTheme") ?? "classic"
        breatheColor = defaults.integer(forKey: "breatheColor")
    }
    
    func updateTheme(){
        //testUserDefaults()
        image.setImageNamed(breatheTheme)
        image.setTintColor(customColors[breatheColor])
    }
    
    func sendData(game : String = "breathe infinite", what : String, correct : String = "N/A", timePlayed : Double = 0.0, avgBreathLength : Double = 0.0, totalSets : Int = 0, breatheCycleDict : [String : Int] = [:]){
        let session = WCSession.default
        if session.activationState == .activated{
            let timestamp = NSDate().timeIntervalSince1970
            let date = Date()
            
            let data = ["game": game,
                        "what": what,
                        "correct": correct,
                        "date": date,
                        "time": timestamp,
                        //"settings": settings,
                "breatheITimePlayed": timePlayed,
                "breatheIBreathLength": avgBreathLength,
                "breatheITotalSets": totalSets,
                "breatheICycleDict": breatheCycleDict] as [String : Any]
            session.transferUserInfo(data)
        }
    }
}

