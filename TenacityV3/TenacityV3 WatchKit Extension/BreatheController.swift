//
//  BreatheController.swift
//  TenacityV3 WatchKit Extension
//
//  Created by PLL on 5/20/19.
//  Copyright © 2019 PLL. All rights reserved.
//

import WatchKit
import WatchConnectivity

var FullCycle = 5
var sessionTime = 15
var time = 0.0 //used for timer, keeps track of how long in game
var correctCyclesTotal = 0
var cycleTotal = 0
var inGame = true
var totalBreaths = 0
var averageFullBreatheTime = 3.5

var breatheTheme = "classic"
var breatheColor = 0

var resetColor: UIColor = UIColor(red: 0.96, green: 0.945, blue: 0.35, alpha: 1.0)

class BreatheController: WatchViewController{

    
    let startRelativeHeight = 0.5
    let startRelativeWidth = 0.5
    
    let customBlue =  UIColor(red:0.102, green: 0.788, blue: 0.827, alpha: 1.0)
    let customRed = UIColor(red: 0.77, green: 0.19, blue: 0.34, alpha: 1.0)
    let customPink = UIColor(red: 0.96, green: 0.62, blue: 0.16, alpha: 1.0) // saffron
    let customGreen = UIColor(red: 0.71, green: 0.49, blue: 0.86, alpha: 1.0) //lavender
    
    lazy var customColors = [customBlue, customPink, customRed, customGreen]
    
    var counter = 0.0
    
    var totalBreatheTimes = 3.5
    //var resetInterval = 2.5   unused right now
    
    var breatheInTimer = Timer()
    var breatheInTime = 0.0
    var gameLengthTimer = Timer()
    
    var cycleStep = 0
    
    
    //----------------------  Initial Settings Page -----------------------
//    @IBOutlet var sessionLengthSlider: WKInterfaceSlider!
//    @IBAction func sessionLengthSliderAction(_ value: Float) {
//        sessionTime = Int(value)
//        sessionLengthLabel.setText(String(Int(sessionTime)))
//    }
//
//    @IBOutlet var sessionLengthLabel: WKInterfaceLabel!
//
//    @IBOutlet var cycleSlider: WKInterfaceSlider!
//    @IBOutlet var cycleNumLabel: WKInterfaceLabel!
//    @IBAction func cycleSliderAction(_ value: Float) {
//        FullCycle = Int(value)
//        cycleNumLabel.setText(String(Int(FullCycle)))
//    }
    
    @IBOutlet weak var timePicker: WKInterfacePicker!
    @IBOutlet weak var cyclePicker: WKInterfacePicker!
    
    var timePickerItems = [WKPickerItem]()
    var cyclePickerItems = [WKPickerItem]()
    
    @IBAction func timePickerAction(_ value: Int) {
        sessionTime = value + 3
        print(sessionTime)
    }
    @IBAction func cyclePickerAction(_ value: Int) {
        FullCycle = value + 2
        print(FullCycle)
    }

    
    @IBAction func startButtonTapped() {    // change to TutorialEnd()
        WKInterfaceController.reloadRootControllers(withNames: ["Breathe Tutorial1"], contexts: [""])
        
        // resets global variables
        inGame = true
        time = 0
        correctCyclesTotal = 0
        cycleTotal = 0
        totalBreaths = 0
        averageFullBreatheTime = 3.5
    }
    
    /////////////////////////// Tutorial
    
    
    @IBOutlet var tutorial2Label: WKInterfaceLabel!
    
    @IBAction func tutorial1Tapped(_ sender: Any) {
        WKInterfaceController.reloadRootControllers(withNames: ["Breathe Tutorial2"], contexts: ["t2"])
    }
    
    @IBAction func tutorial2Tapped(_ sender: Any) {
        WKInterfaceController.reloadRootControllers(withNames: ["Breathe Main"], contexts: ["start"])
        
        // send data
        sendData(what: "start game", correct: "N/A", cycleSettings: FullCycle, timeSettings: sessionTime)
        //  Game Length Timer
        gameLengthTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector (BreatheController.sessionCounter), userInfo: nil, repeats: true)
    }
    
    ////////////////////  Results Screen Page
    
    @IBOutlet var averageBreathLabel: WKInterfaceLabel!
    @IBOutlet var timePlayedLabel: WKInterfaceLabel!
    @IBOutlet var correctCyclesLabel: WKInterfaceLabel!
    @IBOutlet var totalBreathsLabel: WKInterfaceLabel!
    @IBAction func resultScreenTapped(_ sender: Any) {
        WKInterfaceController.reloadRootControllers(withNames: ["Main Menu"], contexts: ["Finish Breathe"])
    }
    
    //--------------------- AWAKE ----------------------------------
    
    
    @IBOutlet weak var image: WKInterfaceImage!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        
        if ((context as? String) == "Breathe Done"){
            if (cycleTotal == 0){
                correctCyclesLabel.setText("Correct Cycles: 0%")
            }
            else{
                correctCyclesLabel.setText("Correct Cycles: " + String(format: "%.0f", (Double(correctCyclesTotal)/Double(cycleTotal))*100) + "%")
            }
            
            totalBreathsLabel.setText("Total Breaths: " + String(totalBreaths))
            timePlayedLabel.setText("Time Played: " + String(Int(time)) + "s")
            averageBreathLabel.setText("Avg Breath Time: " + String(format: "%.1f", averageFullBreatheTime) + "s")
        }
        
        else if ((context as? String) == "t2"){
            if (FullCycle == 1){
                tutorial2Label.setText("After Your \(String(FullCycle))st breath, swipe to complete your breath cycle")
            }
            else if (FullCycle == 2){
                tutorial2Label.setText("After Your \(String(FullCycle))nd breath, swipe to complete your breath cycle")
            }
            else if (FullCycle == 3){
                tutorial2Label.setText("After Your \(String(FullCycle))rd breath, swipe to complete your breath cycle")
            }
            else {
                tutorial2Label.setText("After Your \(String(FullCycle))th breath, swipe to complete your breath cycle")
            }
        }
        
        else if ((context as? String) == "start"){
            updateTheme()
            self.image.setTintColor(resetColor)
            var isAutorotating: Bool = true
        }
        else if ((context as? String) == "from Menu"){
            
            // resets global slider variables
            FullCycle = 5
            sessionTime = 10
            
            // set picker values on awake
            for i in 3..<31{
                let min = WKPickerItem()
                min.title = String(i)
                timePickerItems.append(min)
            }
            
            for i in 2..<11{
                let cycle = WKPickerItem()
                cycle.title = String(i)
                cyclePickerItems.append(cycle)
            }
            
            timePicker.setItems(timePickerItems)
            cyclePicker.setItems(cyclePickerItems)
            timePicker.setSelectedItemIndex(7)
            cyclePicker.setSelectedItemIndex(3)
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
        if (inGame == true){
            inGame = false
            WKInterfaceController.reloadRootControllers(withNames: ["Breathe Results"], contexts: ["Breathe Done"])
            
            //sends data
            sendData(what: "end game", correct: "N/A", cycleSettings: FullCycle, timeSettings: sessionTime, timePlayed : time, avgBreathLength : averageFullBreatheTime, totalSets : cycleTotal, correctSets : correctCyclesTotal)
        }
        
    }
    
    @IBAction func forceQuit() {
        gameLengthTimer.invalidate()
        endGame()
    }
    
    @objc func sessionCounter(){
        if (inGame == false){
            gameLengthTimer.invalidate()
        }
        if (time < Double(sessionTime*60)){
            time += 0.1
        }
        else{
            endGame()
            gameLengthTimer.invalidate()
        }
    }
    
    @objc func breatheInCounter(){
        if (counter < averageFullBreatheTime){
            animate(withDuration: 0.1){
                //self.alpha = (self.counter/self.averageFullBreatheTime)
                //self.image.setAlpha(CGFloat(self.alpha))
                let addHeight = (1 - self.startRelativeWidth)*(self.counter/averageFullBreatheTime)
                let addWidth = (1 - self.startRelativeHeight)*(self.counter/averageFullBreatheTime)
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
        cycleTotal += 1
        cycleStep = 0
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
        
        if (cycleStep != FullCycle){
            let continueAlert = WKAlertAction(title: "Continue", style: .cancel){
            }
            presentAlert(withTitle: "Oops", message: "You Swiped When You Should Have Held", preferredStyle: .alert, actions: [continueAlert])
            sendData(what: "swipe", correct: "false")
            WKInterfaceDevice.current().play(.notification)
        }
        else{
            correctCyclesTotal += 1
            sendData(what: "swipe", correct: "true")
            WKInterfaceDevice.current().play(.success)
        }
        cycleReset()
    }
    
    @IBAction func longPressHold(_ gestureRecognizer: WKLongPressGestureRecognizer) {
        
        if gestureRecognizer.state == .began{
            resetImage()
            counter = 0
            breatheInTime = 0
            if (cycleStep == FullCycle){
                sendData(what: "start hold", correct: "false")
            }
            else{
                sendData(what: "start hold", correct: "true")
            }
            breatheInTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector (BreatheController.breatheInCounter), userInfo: nil, repeats: true)
            cycleStep += 1
        }
        else if gestureRecognizer.state == .ended || gestureRecognizer.state == .cancelled{
            breatheInTimer.invalidate()
            print("breathe in time: " + String(format: "%.3f", breatheInTime))
            totalBreaths += 1
            print("total breaths: " + String(totalBreaths))
            
            addToAverageBreatheTime(time: breatheInTime)
            print("new avg: " + String(format: "%.3f", averageFullBreatheTime))
            
            //Can use "(breatheInTime - offset)" or global var "resetInterval" for "withDuration"
            var shrinkInterval = (0.8)*(breatheInTime)
            
            if (shrinkInterval > 2.5){
                shrinkInterval = 2.5
            }
            
            animate(withDuration: shrinkInterval){
                self.image.setRelativeWidth(CGFloat(self.startRelativeWidth), withAdjustment: 0)
                self.image.setRelativeHeight(CGFloat(self.startRelativeHeight), withAdjustment: 0)
            }
            if (cycleStep == (FullCycle + 1)){
                cycleReset()
                sendData(what: "stop hold", correct: "false")
                let continueAlert = WKAlertAction(title: "Continue", style: .cancel){
                }
                presentAlert(withTitle: "Oops", message: "You Held When You Should Have Swiped", preferredStyle: .alert, actions: [continueAlert])
            }
            else{
                animate(withDuration: 1){
                    self.image.setTintColor(self.customColors[breatheColor])
                }
                
                sendData(what: "stop hold", correct: "true")
            }
        }
    }
    
    func addToAverageBreatheTime(time : Double){
        totalBreatheTimes = totalBreatheTimes + time
        averageFullBreatheTime = totalBreatheTimes/Double((totalBreaths + 1))
    }
    
    func testUserDefaults(){
        let defaults = UserDefaults.standard
        
        breatheTheme = defaults.string(forKey: "breatheTheme") ?? "classic"
        breatheColor = defaults.integer(forKey: "breatheColor")
    }
    
    func updateTheme(){
        testUserDefaults()
        image.setImageNamed(breatheTheme)
        image.setTintColor(customColors[breatheColor])
    }
    
    func sendData(game : String = "breathe focus", what : String, correct : String, cycleSettings : Int = FullCycle, timeSettings : Int = sessionTime, timePlayed : Double = 0.0, avgBreathLength : Double = 0.0, totalSets : Int = 0, correctSets : Int = 0){
        let session = WCSession.default
        if session.activationState == .activated{
            let timestamp = NSDate().timeIntervalSince1970
            let date = Date()
            
            let data = ["game": game,
                        "what": what,
                        "correct": correct,
                        "date": date,
                        "time": timestamp,
            "breatheFCycleSettings": cycleSettings,
            "breatheFTimeSettings": timeSettings,
            "breatheFTimePlayed": timePlayed,
            "breatheFBreathLength": avgBreathLength,
            "breatheFTotalSets": totalSets,
            "breatheFCorrectSets": correctSets] as [String : Any]
            session.transferUserInfo(data)
        }
    }
}
