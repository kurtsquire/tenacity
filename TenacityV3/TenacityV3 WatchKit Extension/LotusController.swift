//
//  LotusController.swift
//  TenacityV3 WatchKit Extension
//
//  Created by PLL on 5/20/19.
//  Copyright © 2019 PLL. All rights reserved.
//

import WatchKit
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

class LotusController: WatchViewController{
    
    
    var counter = 0.0
    var gameLengthTimer = Timer()

    // ------------------------ Settings -------------------------

//    @IBOutlet weak var roundSliderLabel: WKInterfaceLabel!
//    @IBOutlet weak var lotusRoundSlider: WKInterfaceSlider!
//    @IBAction func lotusRoundSliderAction(_ value: Float) {
//        lotusTotalRounds = Int(value)
//        roundSliderLabel.setText(String(lotusTotalRounds))
//    }
    @IBOutlet weak var lotusRoundPicker: WKInterfacePicker!
    var roundPickerItems = [WKPickerItem]()
    @IBAction func lotusRoundPickerAction(_ value: Int) {
        lotusTotalRounds = ((value + 1) * 5) // 0 = 5, 1 = 10....
        print(lotusTotalRounds)
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
    
    let customForest1 = UIColor(red: 0.20, green: 0.52, blue: 0.43, alpha: 1.0)
    let customForest2 = UIColor(red: 0.47, green: 0.28, blue: 0.20, alpha: 1.0)
    let customForest3 = UIColor(red: 0.72, green: 0.78, blue: 0.55, alpha: 1.0)
    let customForest4 = UIColor(red: 0.97, green: 0.97, blue: 0.41, alpha: 1.0)
    
    let customOutrun1 = UIColor(red: 1.00, green: 0.26, blue: 0.40, alpha: 1.0)
    let customOutrun2 = UIColor(red: 0.47, green: 0.12, blue: 0.58, alpha: 1.0)
    let customOutrun3 = UIColor(red: 0.18, green: 0.89, blue: 0.90, alpha: 1.0)
    let customOutrun4 = UIColor(red: 1.00, green: 0.42, blue: 0.07, alpha: 1.0)
    
    let customPool1 = UIColor(red: 0.23, green: 0.68, blue: 0.83, alpha: 1.0)
    let customPool2 = UIColor(red: 0.98, green: 0.40, blue: 0.66, alpha: 1.0)
    let customPool3 = UIColor(red: 0.95, green: 0.84, blue: 0.37, alpha: 1.0)
    let customPool4 = UIColor(red: 1.00, green: 0.05, blue: 0.31, alpha: 1.0)
    
    
    lazy var customColors = [[customRed, customBlue, customYellow, customGreen], [customForest1, customForest2, customForest3, customForest4], [customOutrun1, customOutrun2, customOutrun3, customOutrun4], [customPool1, customPool2, customPool3, customPool4]]
    
    
    // -------------------------  AWAKE  ------------------------------
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // after tutorial and into memorization screen
        if ((context as? String) == "t2"){
            testUserDefaults()
            randomizeImages(palette: customColors[lotusPalette], randomColors: randomizeColorsBool)
            setTiles()
            gameLengthTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector (LotusController.sessionCounter), userInfo: nil, repeats: true)
        }
        // after memorization screen
        else if ((context as? String) == "t3"){
            current = lotusTheme + "_0"
            lotusGameImage.setImageNamed(lotusTheme + "_0")
            lotusGameImage.setTintColor(UIColor.white)
        }
        // when game ends to display result stats
        else if ((context as? String) == "lotus game end"){
            let min = Int(lotusTimePlayed/60)
            let sec = (Int(lotusTimePlayed)%60)
            totalRoundsLabel.setText("Rounds: " + String(lotusCurrentRound))
            timePlayedLabel.setText("Time: " + String(min) + " mins " + String(sec) + " s")
            swipeMissesLabel.setText("0 misses: " + String(lotusArray[0]) + "\n1 miss: " + String(lotusArray[1]) + "\n2 misses: " + String(lotusArray[2]) + "\n3+ misses: " + String(lotusArray[3]))
        }
        // from main menu
        else if ((context as? String) == "from Menu"){
            print("main menu")
            
            // set initial rounds to default
            lotusTotalRounds = 10
            
            // set up the picker items
            for i in 1..<11{
                let x = WKPickerItem()
                x.title = String(i*5)
                roundPickerItems.append(x)
            }
            // set picker default value to 20 (3rd index)
            lotusRoundPicker.setItems(roundPickerItems)
            lotusRoundPicker.setSelectedItemIndex(3)

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
                    WKInterfaceDevice.current().play(.failure)
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
