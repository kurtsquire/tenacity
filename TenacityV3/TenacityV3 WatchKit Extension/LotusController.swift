//
//  LotusController.swift
//  TenacityV3 WatchKit Extension
//
//  Created by PLL on 5/20/19.
//  Copyright © 2019 PLL. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

var randomizeColorsBool = false

var lotusTotalRounds: Int = 10 // should always be the same as default rounds shown on start slider
var lotusCurrentRound = 0
var lotusTimePlayed = 0.0
var lotusTotalSwipes = 0

var lotusTheme = "lotus"
var lotusPalette = 0

var topTile = ""
var leftTile = ""
var rightTile = ""
var bottomTile = ""
var topColor: UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
var leftColor: UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
var rightColor: UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
var bottomColor: UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)

var lotusArray = [0,0,0,0]

class LotusController: WKInterfaceController, WCSessionDelegate {
    
    
    var counter = 0.0
    var gameLengthTimer = Timer()

    // ------------------------ Settings -------------------------
    
    @IBOutlet weak var roundSliderLabel: WKInterfaceLabel!
    @IBOutlet weak var lotusRoundSlider: WKInterfaceSlider!
    @IBAction func lotusRoundSliderAction(_ value: Float) {
        lotusTotalRounds = Int(value)
        roundSliderLabel.setText(String(lotusTotalRounds))
    }
    
    // ------------------------ Tutorials -------------------------
    @IBAction func lotusTutorial2Tapped() {
        WKInterfaceController.reloadRootControllers(withNames: ["Lotus Tutorial 3"], contexts: ["t2"])
        lotusCurrentRound = 1
        lotusTimePlayed = 0.0
        lotusTotalSwipes = 0
        lotusArray = [0,0,0,0]
        inGame = true
        sendData(what: "start game")
    }
    @IBAction func lotusTutorial3Tapped() {
        WKInterfaceController.reloadRootControllers(withNames: ["Lotus Game"], contexts: ["t3"])
        
    }
    @IBAction func lotusResultsTapped() {
        WKInterfaceController.reloadRootControllers(withNames: ["Main Menu"], contexts: [""])
    }
    
    // ------------------------ Force Touch ---------------------------
    
    @IBAction func forceTouchQuit() {
        endGame()
    }
    
    // ------------------------ Game ---------------------------
    
    @IBOutlet weak var lotusGameImage: WKInterfaceImage!
    

    @IBOutlet weak var swipeUp: WKSwipeGestureRecognizer!
    @IBOutlet weak var swipeRight: WKSwipeGestureRecognizer!
    @IBOutlet weak var swipeLeft: WKSwipeGestureRecognizer!
    @IBOutlet weak var swipeDown: WKSwipeGestureRecognizer!
    

    @IBAction func swipeUpAction(_ sender: Any) {
        checkDirection(direction: "up")
    }
    @IBAction func swipeRightAction(_ sender: Any) {
        checkDirection(direction: "right")
    }
    @IBAction func swipeLeftAction(_ sender: Any) {
        checkDirection(direction: "left")
    }
    @IBAction func swipeDownAction(_ sender: Any) {
        checkDirection(direction: "down")
    }
    @IBAction func tapAction(_ sender: Any) {
        let basic = lotusTheme + "_0"
        if (current == basic){
            wrongCount = 0
            randomizeGame()
        }
    }
    
    // ------------------------ Results ---------------------------
    
    @IBOutlet weak var totalRoundsLabel: WKInterfaceLabel!
    @IBOutlet weak var timePlayedLabel: WKInterfaceLabel!
    @IBOutlet weak var swipeMissesLabel: WKInterfaceLabel!
    
    
    // ------------------------ Palettes --------------------------
    
    @IBOutlet weak var topImage: WKInterfaceImage!
    @IBOutlet weak var rightImage: WKInterfaceImage!
    @IBOutlet weak var bottomImage: WKInterfaceImage!
    @IBOutlet weak var leftImage: WKInterfaceImage!


    var current = ""
    var wrongCount = 0
    
    let customRed = UIColor(red: 0.77, green: 0.19, blue: 0.34, alpha: 1.0)
    let customBlue =  UIColor(red:0.19, green: 0.45, blue: 0.77, alpha: 1.0)
    let customYellow = UIColor(red: 0.96, green: 0.945, blue: 0.35, alpha: 1.0)
    let customGreen = UIColor(red: 0.215, green: 0.843, blue: 0.435, alpha: 1.0)
    
    lazy var customColors = [[customRed, customBlue, customYellow, customGreen]]
    
    
    // -------------------------  AWAKE  ------------------------------
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // wc session connect
        if WCSession.isSupported(){
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        
        if ((context as? String) == "t2"){
            testUserDefaults()
            randomizeImages(palette: customColors[lotusPalette], randomColors: randomizeColorsBool)
            setTiles()
            gameLengthTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector (LotusController.sessionCounter), userInfo: nil, repeats: true)
        }
        
        if ((context as? String) == "t3"){
            current = lotusTheme + "_0"
            lotusGameImage.setImageNamed(lotusTheme + "_0")
            lotusGameImage.setTintColor(UIColor.white)
        }
        
        if ((context as? String) == "lotus game end"){
            let min = Int(lotusTimePlayed/60)
            let sec = (Int(lotusTimePlayed)%60)
            totalRoundsLabel.setText("Rounds: " + String(lotusCurrentRound))
            timePlayedLabel.setText("Time: " + String(min) + " mins " + String(sec) + " s")
            swipeMissesLabel.setText("0 misses: " + String(lotusArray[0]) + "\n1 miss: " + String(lotusArray[1]) + "\n2 misses: " + String(lotusArray[2]) + "\n3+ misses: " + String(lotusArray[3]))
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
    
    // --------------------- TIMER ----------------------------
    
    @objc func sessionCounter(){
        if (inGame == false){
            gameLengthTimer.invalidate()
        }
        lotusTimePlayed += 0.1
    }
    
    // --------------------- WC SESSION ------------------------
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        lotusTheme = (userInfo["theme"] as? String)!
        UserDefaults.standard.set(lotusTheme, forKey: "lotusTheme")
    }

    
    // --------------------- GAMEPLAY --------------------------
    func randomizeImages(palette: Array<Any>, randomColors: Bool){
        var shape : Set<Int> = [1,2,3,4]
        var color : Set<Int> = [0,1,2,3]
        
        topTile = (lotusTheme + "_")
        rightTile = (lotusTheme + "_")
        leftTile = (lotusTheme + "_")
        bottomTile = (lotusTheme + "_")
        
        var chosen = shape.randomElement()!
        topTile += String(chosen)
        if (randomColors == false){
            topColor = palette[(chosen - 1)] as! UIColor
        }
        else{
            let chosenColor = color.randomElement()!
            topColor = palette[chosenColor] as! UIColor
            color.remove(chosenColor)
        }
        self.topImage.setTintColor(topColor)
        shape.remove(chosen)
        
        chosen = shape.randomElement()!
        leftTile += String(chosen)
        if (randomColors == false){
            leftColor = palette[(chosen - 1)] as! UIColor
        }
        else{
            let chosenColor = color.randomElement()!
            leftColor = palette[chosenColor] as! UIColor
            color.remove(chosenColor)
        }
        self.leftImage.setTintColor(leftColor)
        shape.remove(chosen)
        
        chosen = shape.randomElement()!
        rightTile += String(chosen)
        if (randomColors == false){
            rightColor = palette[(chosen - 1)] as! UIColor
        }
        else{
            let chosenColor = color.randomElement()!
            rightColor = palette[chosenColor] as! UIColor
            color.remove(chosenColor)
        }
        self.rightImage.setTintColor(rightColor)
        shape.remove(chosen)
    
        chosen = shape.randomElement()!
        bottomTile += String(chosen)
        if (randomColors == false){
            bottomColor = palette[(chosen - 1)] as! UIColor
        }
        else{
            let chosenColor = color.randomElement()!
            bottomColor = palette[chosenColor] as! UIColor
            color.remove(chosenColor)
        }
        self.bottomImage.setTintColor(bottomColor)
        shape.remove(chosen)
    }
    
    func setTiles(){
        topImage.setImageNamed(topTile)
        leftImage.setImageNamed(leftTile)
        rightImage.setImageNamed(rightTile)
        bottomImage.setImageNamed(bottomTile)
    }

    
    func randomizeGame(){
        let number = Int.random(in: 1 ..< 5)
        if (number == 1){
            current = topTile
            animate(withDuration: 0.5){
                self.lotusGameImage.setImageNamed(topTile)
                self.lotusGameImage.setTintColor(topColor)
            }
            
        }
        else if (number == 2){
            current = rightTile
            animate(withDuration: 0.5){
                self.lotusGameImage.setImageNamed(rightTile)
                self.lotusGameImage.setTintColor(rightColor)
            }
        }
        else if (number == 3){
            current = leftTile
            animate(withDuration: 0.5){
                self.lotusGameImage.setImageNamed(leftTile)
                self.lotusGameImage.setTintColor(leftColor)
            }
        }
        else {
            current = bottomTile
            animate(withDuration: 0.5){
                self.lotusGameImage.setImageNamed(bottomTile)
                self.lotusGameImage.setTintColor(bottomColor)
            }
        }
    }
    
    func checkDirection(direction: String){
        if (direction == "up"){
            if (current == topTile){
                resetRound()
                // haptic feedback, reset to current, send data
                sendData(what: "swipe", correct: "true")
                WKInterfaceDevice.current().play(.success)
            }
            else{
                if (current != (lotusTheme + "_0")){
                    wrongCount += 1
                    sendData(what: "swipe", correct: "false")
                }
            }
        }
        else if (direction == "right"){
            if (current == rightTile){
                resetRound()
                // do something
                sendData(what: "swipe", correct: "true")
                WKInterfaceDevice.current().play(.success)
            }
            else{
                if (current != (lotusTheme + "_0")){
                   wrongCount += 1
                    sendData(what: "swipe", correct: "false")
                    WKInterfaceDevice.current().play(.failure)
                }
            }
        }
        else if (direction == "left"){
            if (current == leftTile){
                resetRound()
                // do something
                sendData(what: "swipe", correct: "true")
                WKInterfaceDevice.current().play(.success)
            }
            else{
                if (current != (lotusTheme + "_0")){
                    wrongCount += 1
                    sendData(what: "swipe", correct: "false")
                    WKInterfaceDevice.current().play(.failure)
                }
            }
        }
        else if (direction == "down"){
            if (current == bottomTile){
                resetRound()
                // do something
                sendData(what: "swipe", correct: "true")
                WKInterfaceDevice.current().play(.success)
            }
            else{
                if (current != (lotusTheme + "_0")){
                    wrongCount += 1
                    sendData(what: "swipe", correct: "false")
                    WKInterfaceDevice.current().play(.failure)
                }
            }
        }
    }
    
    func resetRound(){
        if (wrongCount > 3){
            lotusArray[3] += 1
        }
        else{
            lotusArray[wrongCount] += 1
        }
        wrongCount = 0
        if (lotusCurrentRound >= lotusTotalRounds){
            endGame()
        }
        else{
            lotusCurrentRound += 1
            current = lotusTheme + "_0"
            animate(withDuration: 1){
                self.lotusGameImage.setTintColor(UIColor.white)
                self.lotusGameImage.setImageNamed(self.current)
            }
            
        }
    }
    
    func endGame(){
        inGame = false
        sendData(what: "end game", lotusRoundsPlayed: lotusCurrentRound, timePlayed: lotusTimePlayed, missArray: lotusArray)
        WKInterfaceController.reloadRootControllers(withNames: ["Lotus Results"], contexts: ["lotus game end"])
        lotusTotalRounds = 10
    }
    
    func sendData(game : String = "lotus", what : String, correct : String = "N/A", settings : Int = lotusTotalRounds, lotusRoundsPlayed : Int = 0, timePlayed : Double = 0.0, missArray : [Int] = [0,0,0,0]){
        let session = WCSession.default
        if session.activationState == .activated{
            let timestamp = NSDate().timeIntervalSince1970
            let date = Date()
            let data = ["game": game,
                        "what": what,
                        "correct": correct,
                        "date": date,
                        "time": timestamp,
                        "roundSettings": settings,
                        "lotusRoundsPlayed": lotusRoundsPlayed,
                        "timePlayed": timePlayed,
                        "missArray": missArray
                        ] as [String : Any]
            session.transferUserInfo(data)
        }
    }
    
    func testUserDefaults(){
        let defaults = UserDefaults.standard
        
        lotusTheme = defaults.string(forKey: "lotusTheme") ?? "lotus"
        lotusPalette = defaults.integer(forKey: "lotusColor")
    }
    
}
