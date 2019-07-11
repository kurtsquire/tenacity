//
//  BreatheController.swift
//  TenacityV3 WatchKit Extension
//
//  Created by PLL on 5/20/19.
//  Copyright © 2019 PLL. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

var FullCycle = 5
var sessionTime = 2
var time = 0.0 //used for timer, keeps track of how long in game
var correctCyclesTotal = 0
var cycleTotal = 0
var inGame = true
var totalBreaths = 0
var averageFullBreatheTime = 3.5


class BreatheController: WKInterfaceController, WCSessionDelegate  {
    
    let startRelativeHeight = 0.5
    let startRelativeWidth = 0.5
    
    var counter = 0.0
    
    var totalBreatheTimes = 3.5
    //var resetInterval = 2.5   unused right now
    
    
    var breatheInTimer = Timer()
    var breatheInTime = 0.0
    var gameLengthTimer = Timer()
    
    var cycleStep = 0
    
    let customYellow = UIColor(red: 0.929, green: 0.929, blue: 0.475, alpha: 1.0)
    let customBlue =  UIColor(red:0.102, green: 0.788, blue: 0.827, alpha: 1.0)
    
    //Initial Settings Page
    @IBOutlet var sessionLengthSlider: WKInterfaceSlider!
    @IBAction func sessionLengthSliderAction(_ value: Float) {
        sessionTime = Int(value)
        sessionLengthLabel.setText(String(Int(sessionTime)))
    }
    
    @IBOutlet var sessionLengthLabel: WKInterfaceLabel!
    
    @IBOutlet var cycleSlider: WKInterfaceSlider!
    @IBOutlet var cycleNumLabel: WKInterfaceLabel!
    @IBAction func cycleSliderAction(_ value: Float) {
        FullCycle = Int(value)
        cycleNumLabel.setText(String(Int(FullCycle)))
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
        sendData(game: "breathe", what: "start game", correct: "N/A", settings: "cycle: " + String(FullCycle) + ", time(min): " + String(sessionTime))
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
    
    ////////////////////////////////////////
    
    
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
            self.image.setTintColor(self.customYellow)
        }
        
        if WCSession.isSupported(){
            let session = WCSession.default
            session.delegate = self
            session.activate()
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
            sendData(game: "breathe", what: "end game", correct: "N/A", settings: "cycle: " + String(FullCycle) + ", time(min): " + String(sessionTime), timePlayed : time, avgBreathLength : averageFullBreatheTime, totalSets : cycleTotal, correctSets : correctCyclesTotal)
            
            // resets global slider variables
            FullCycle = 5
            sessionTime = 2
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
        print(time)
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
        //self.image.setImageNamed("breathey")
        animate(withDuration: 1){
            self.image.setTintColor(self.customYellow)
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
            sendData(game: "breathe", what: "swipe", correct: "false", settings: "N/A")
            WKInterfaceDevice.current().play(.notification)
        }
        else{
            correctCyclesTotal += 1
            sendData(game: "breathe", what: "swipe", correct: "true", settings: "N/A")
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
                sendData(game: "breathe", what: "start hold", correct: "false", settings: "N/A")
            }
            else{
                sendData(game: "breathe", what: "start hold", correct: "true", settings: "N/A")
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
                sendData(game: "breathe", what: "stop hold", correct: "false", settings: "N/A")
                let continueAlert = WKAlertAction(title: "Continue", style: .cancel){
                }
                presentAlert(withTitle: "Oops", message: "You Held When You Should Have Swiped", preferredStyle: .alert, actions: [continueAlert])
            }
            else{
                //self.image.setImageNamed("breathe")
                animate(withDuration: 1){
                    self.image.setTintColor(self.customBlue)
                }
                
                sendData(game: "breathe", what: "stop hold", correct: "true", settings: "N/A")
            }
            
        }
        
    }
    
    func addToAverageBreatheTime(time : Double){
        totalBreatheTimes = totalBreatheTimes + time
        averageFullBreatheTime = totalBreatheTimes/Double((totalBreaths + 1))
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    func sendData(game : String, what : String, correct : String, settings : String, timePlayed : Double = 0.0, avgBreathLength : Double = 0.0, totalSets : Int = 0, correctSets : Int = 0){
        let session = WCSession.default
        if session.activationState == .activated{
            let timestamp = NSDate().timeIntervalSince1970
            let date = Date()
            
            let data = ["game": game,
                        "what": what,
                        "correct": correct,
                        "date": date,
                        "time": timestamp,
                        "settings": settings,
            "breatheFTimePlayed": timePlayed,
            "breatheFBreathLength": avgBreathLength,
            "breatheFTotalSets": totalSets,
            "breatheFCorrectSets": correctSets] as [String : Any]
            session.transferUserInfo(data)
        }
    }
}
