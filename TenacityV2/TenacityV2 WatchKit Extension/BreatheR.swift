//
//  BreatheR.swift
//  TenacityV2 WatchKit Extension
//
//  Created by PLL on 5/9/19.
//  Copyright © 2019 PLL. All rights reserved.
//


import WatchKit
import Foundation
import WatchConnectivity

var FullCycle = 5
var sessionTime = 60
var time = 0.0
var correctCyclesTotal = 0
var cycleTotal = 0
var inGame = true
var resetInterval = 2.5


class BreatheR: WKInterfaceController, WCSessionDelegate  {
    
    let startRelativeHeight = 0.45
    let startRelativeWidth = 0.5
    
    var counter = 0.0
    
    
    var averageFullBreatheTime = 3.5
    var totalBreaths = 0
    
    var breatheInTimer = Timer()
    var breatheInTime = 0.0
    var gameLengthTimer = Timer()
    
    //var FullCycle = 5
    
    var cycleStep = 0
    
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
    
    @IBAction func startButtonTapped() {
        WKInterfaceController.reloadRootControllers(withNames: ["BreatheR Main"], contexts: ["start game"])
        inGame = true
        time = 0
        var correctCyclesTotal = 0
        var cycleTotal = 0
        gameLengthTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector (BreatheR.sessionCounter), userInfo: nil, repeats: true)
    }
    ////////////////////////////////////////
    
    //Results Screen Page
    @IBOutlet var timePlayedLabel: WKInterfaceLabel!
    @IBOutlet var correctCyclesLabel: WKInterfaceLabel!
    @IBOutlet var totalCyclesLabel: WKInterfaceLabel!
    @IBAction func resultScreenTapped(_ sender: Any) {
        WKInterfaceController.reloadRootControllers(withNames: ["Main Menu"], contexts: ["Finish Breathe"])
    }
    /////////////////////////////
    
    
    @IBOutlet weak var image: WKInterfaceImage!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        
        if((context as! String) == "Breathe Done"){
            correctCyclesLabel.setText("Correct Cycles: " + String(correctCyclesTotal))
            totalCyclesLabel.setText("Total Cycles: " + String(cycleTotal))
            timePlayedLabel.setText("Time Played: " + String(Int(time)))
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
            WKInterfaceController.reloadRootControllers(withNames: ["BreatheR Results"], contexts: ["Breathe Done"])
        }
        
    }
    
    @IBAction func forceQuit() {
        gameLengthTimer.invalidate()
        endGame()
    }
    
    @objc func sessionCounter(){
        if (time < Double(sessionTime)){
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
                let addHeight = (1 - self.startRelativeWidth)*(self.counter/self.averageFullBreatheTime)
                let addWidth = (1 - self.startRelativeHeight)*(self.counter/self.averageFullBreatheTime)
                self.image.setRelativeWidth(CGFloat(self.startRelativeWidth + addWidth), withAdjustment: 0)
                self.image.setRelativeHeight(CGFloat(self.startRelativeWidth + addHeight), withAdjustment: 0)
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
        self.image.setImageNamed("breathey")
    }
    
    @IBAction func swipeAction(_ sender: Any) {
        if (cycleStep != FullCycle){
            let continueAlert = WKAlertAction(title: "Continue", style: .cancel){
            }
            presentAlert(withTitle: "Oops", message: "You Swiped When You Should Have Held", preferredStyle: .alert, actions: [continueAlert])
            sendData(game: "breathe", what: "swipe", correct: "false")
        }
        else{
            correctCyclesTotal += 1
            sendData(game: "breathe", what: "swipe", correct: "true")
        }
        WKInterfaceDevice.current().play(.directionDown)
        cycleReset()
    }
    
    @IBAction func longPressHold(_ gestureRecognizer: WKLongPressGestureRecognizer) {
        
        if gestureRecognizer.state == .began{
            resetImage()
            counter = 0
            breatheInTime = 0
            if (cycleStep == FullCycle){
                sendData(game: "breathe", what: "start hold", correct: "false")
            }
            else{
                sendData(game: "breathe", what: "start hold", correct: "true")
            }
            breatheInTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector (BreatheR.breatheInCounter), userInfo: nil, repeats: true)
            
            cycleStep += 1
        }
        else if gestureRecognizer.state == .ended || gestureRecognizer.state == .cancelled{
            breatheInTimer.invalidate()
            print("breathe in time: " + String(format: "%.3f", breatheInTime))
            totalBreaths += 1
            print("total breaths: " + String(totalBreaths))
            
            //Can use "(breatheInTime - offset)" or global var "resetInterval" for "withDuration"
            animate(withDuration: resetInterval){
                self.image.setRelativeWidth(CGFloat(self.startRelativeWidth), withAdjustment: 0)
                self.image.setRelativeHeight(CGFloat(self.startRelativeHeight), withAdjustment: 0)
            }
            if (cycleStep == (FullCycle + 1)){
                cycleReset()
                sendData(game: "breathe", what: "stop hold", correct: "false")
                let continueAlert = WKAlertAction(title: "Continue", style: .cancel){
                }
                presentAlert(withTitle: "Oops", message: "You Held When You Should Have Swiped", preferredStyle: .alert, actions: [continueAlert])
            }
            else{
                self.image.setImageNamed("breathe")
                sendData(game: "breathe", what: "stop hold", correct: "true")
            }
            
        }
        
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    func sendData(game : String, what : String, correct : String){
        let session = WCSession.default
        if session.activationState == .activated{
            let timestamp = NSDate().timeIntervalSince1970
            
            let data = ["game": game,
                        "what": what,
                        "correct": correct,
                        "time": String(timestamp)]
            session.transferUserInfo(data)
            
        }
    }
}
