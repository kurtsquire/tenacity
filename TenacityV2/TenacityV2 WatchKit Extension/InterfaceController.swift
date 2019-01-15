//
//  InterfaceController.swift
//  TenacityV2 WatchKit Extension
//
//  Created by PLL on 10/8/18.
//  Copyright © 2018 PLL. All rights reserved.
//this is a comment richard is here 

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    
    var schedulePressed = false
    var timer :Timer?
    var red = 32, green = 148, blue = 250
    var editColor: UIColor?
    let breatheGame = "Breathe Game"
    let lineAtkGame = "Line Attack Game"
    let gpsDrawGame = "GPS Draw Game"
    let semaphore = DispatchSemaphore(value: 1)
    @IBOutlet var scheduleButton: WKInterfaceButton!
    @IBOutlet var breatheBtnGrp: WKInterfaceGroup!
    @IBOutlet var breatheTimeLabel: WKInterfaceLabel!
    @IBOutlet var lineAtkBtnGrp: WKInterfaceGroup!
    @IBOutlet var lineAtkTimeLabel: WKInterfaceLabel!
    @IBOutlet var gpsDrawBtnGrp: WKInterfaceGroup!
    @IBOutlet var gpmDrawTimeLabel: WKInterfaceLabel!

    @IBOutlet var empty1: WKInterfaceImage!
    @IBOutlet var empty2: WKInterfaceImage!
    @IBOutlet var empty3: WKInterfaceImage!
    @IBOutlet var empty4: WKInterfaceImage!
    @IBOutlet var filled1: WKInterfaceImage!
    @IBOutlet var filled2: WKInterfaceImage!
    @IBOutlet var filled3: WKInterfaceImage!
    @IBOutlet var filled4: WKInterfaceImage!

//    @IBOutlet var filledFreCircles: [WKInterfaceImage]!
    func changeFreTagColor(gameName:String, white:Int, green:Int){
        var emptyFreCircle:[WKInterfaceImage] = [empty1, empty2, empty3, empty4]
        var filledFreCircle:[WKInterfaceImage] = [filled1, filled2, filled3, filled4]
        for i in 0...3{
            emptyFreCircle[i].setHidden(false)
        }
        print(String(white)+String(green))
        for i in 0..<(4 - white){
            emptyFreCircle[i].setHidden(true)
        }
        for i in 0...3{
            filledFreCircle[i].setHidden(false)
        }
        for i in 0..<(4 - green){
            filledFreCircle[i].setHidden(true)
        }
    }
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        setTitle("")
        if let timeApm = context as? [String: String]{
            if timeApm["game"] == breatheGame {
                breatheTimeLabel.setHidden(false)
                breatheTimeLabel.setText(timeApm["content"])
                changeFreTagColor(gameName: "Breathe Game", white: 1, green: 2)
            }
            else if timeApm["game"] == lineAtkGame {
                lineAtkTimeLabel.setHidden(false)
                lineAtkTimeLabel.setText(timeApm["content"])
            }
            else if timeApm["game"] == gpsDrawGame {
                gpmDrawTimeLabel.setHidden(false)
                gpmDrawTimeLabel.setText(timeApm["content"])
            }
        }
        else{
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
    

    
    @objc func fireTimer() {
        self.changeBtnColor()
    }
    
    func changeBtnColor(){
        let random = Int(arc4random_uniform(3))+1
        //var random = Int.random(in: 1 ... 3)
        if(random == 1){self.red = (self.red + 50) % 255}
        else if(random == 2){
            self.green = (self.green + 50) % 255
        }
        else{self.blue = (self.blue + 50) % 255}
        self.editColor = UIColor.init(red: CGFloat(self.red)/255, green: CGFloat(self.green)/255, blue: CGFloat(self.blue)/255, alpha: 1)
        animate(withDuration: 0.8) {
            self.breatheBtnGrp.setBackgroundColor(self.editColor)
            self.lineAtkBtnGrp.setBackgroundColor(self.editColor)
            self.gpsDrawBtnGrp.setBackgroundColor(self.editColor)
        }
    }
    
    func startTimer(){
        if(self.timer == nil){
            print("start")
            self.timer = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector:  #selector(fireTimer), userInfo: nil, repeats: true)
        }
        self.changeBtnColor()
    }
    
    @IBAction func scheduleAction() {
        let defaultColor = UIColor.init(red: 32/255, green: 148/255, blue: 250/255, alpha: 1)
        if schedulePressed == false{
            schedulePressed = true
            scheduleButton.setTitle("Editing")
            
            startTimer()
        }
        else if schedulePressed == true{
            schedulePressed = false
            if (self.timer != nil){
                print("stop")
                self.timer!.invalidate()
                self.timer = nil
            }
            scheduleButton.setTitle("Schedule")
            breatheBtnGrp.setBackgroundColor(defaultColor)
            lineAtkBtnGrp.setBackgroundColor(defaultColor)
            gpsDrawBtnGrp.setBackgroundColor(defaultColor)
        }
    }
    
    @IBAction func breatheBtnPressed() {
        if schedulePressed == false{
            presentController(withName: "Breathe Main", context: "Breathe Game")
        }
        else{
            presentController(withName: "Schedule", context: breatheGame)
        }
    }
    
    @IBAction func lineAtkBtnPressed() {
        if schedulePressed == false{
            print("line atk btn clicked")
        }
        else{
            presentController(withName: "Schedule", context: lineAtkGame)
        }
    }
    
    @IBAction func gpsDrawBtnPressed() {
        if schedulePressed == false{
            print("gps draw btn clicked")
        }
        else{
            presentController(withName: "Schedule", context: gpsDrawGame)
        }
    }
}

