//
//  InterfaceController.swift
//  Flower WatchKit Extension
//
//  Created by PLL on 1/26/19.
//  Copyright © 2019 PLL. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

// should always be the same as default rounds shown on start slider
var total_rounds = 10.0

class LotusController: WKInterfaceController, WCSessionDelegate {

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
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
    
    var current_round = 0.0
    
    @IBOutlet var total_round_label: WKInterfaceLabel!
    @IBOutlet var round_slider: WKInterfaceSlider!
    @IBAction func round_slider_action(_ value: Float) {
        total_rounds = Double(value)
        total_round_label.setText(String(Int(total_rounds)))
    }
    
    //@IBAction func start_game_action() {
    //    WKInterfaceController.reloadRootControllers(withNames: ["Lotus Game"], contexts: ["Lotus Game"])
    //}
    
    //change these based on start 
    var up = "red"
    var down = "blue"
    var right = "green"
    var left = "yellow"
    var current_image = "green"
    
    //how long they hold an individual bloom
    var press_time = 0.0
    //total time they held all blooms
    var total_press_time = 0.0
    var successful_swipes = 0.0
    var total_swipes = 0.0
    
    var timer = Timer()
    var timer_open = Timer()
    var timer_reset = Timer()
    var timer_press = Timer()
    
    //data
    
    var seconds = 30.0
    
    @IBOutlet var Welcome: WKInterfaceLabel! //Title "Lotus"
    @IBOutlet var Initial: WKInterfaceLabel! //Paragraph below "Lotus"
    @IBOutlet var Instructions: WKInterfaceLabel! //2nd Page Paragraph
    @IBOutlet var Main_Pic: WKInterfaceImage!  //main picture used for all flowers and flower guide

    
    @IBOutlet var longPress: WKLongPressGestureRecognizer!
    @IBOutlet var Tap: WKTapGestureRecognizer! //tap on lotus
    @IBOutlet var SwipeUp: WKSwipeGestureRecognizer!
    @IBOutlet var SwipeDown: WKSwipeGestureRecognizer!
    @IBOutlet var SwipeRight: WKSwipeGestureRecognizer!
    @IBOutlet var SwipeLeft: WKSwipeGestureRecognizer!
    
    @IBOutlet var Results_label: WKInterfaceLabel!  //results title
    @IBOutlet var Accuracy_label: WKInterfaceLabel! //Accuracy result
    @IBOutlet var Press_label: WKInterfaceLabel! //Press times result
    @IBOutlet var Restart_button: WKInterfaceButton! //Back to main menu button
    
    //takes away 1st instruction screen after 1st tap and shows the 2nd paragraph
    @IBAction func InitialTap(_ sender: Any) {
        Welcome.setHidden(true)
        Initial.setHidden(true)
        Instructions.setHidden(false)
    }
    
    
    
    //Takes away 2nd paragrpah and shows flower guide
    @IBAction func InstructionsTap(_ sender: Any) {
        Instructions.setHidden(true)
        choose_guide()
        Tap.isEnabled = true
    }
    
    //randomly chooses memorization set
    @objc func choose_guide(){
        let number = Int.random(in: 1 ..< 5)
        if (number == 1){
            Main_Pic.setImageNamed("flower_guide")
            up = "red"
            right = "green"
            down = "blue"
            left = "yellow"
        }
        else if (number == 2){
            Main_Pic.setImageNamed("flower_guide_2")
            up = "yellow"
            right = "red"
            down = "green"
            left = "blue"
        }
        else if (number == 3){
            Main_Pic.setImageNamed("flower_guide_3")
            up = "blue"
            right = "yellow"
            down = "red"
            left = "green"
        }
        else {
            Main_Pic.setImageNamed("flower_guide_4")
            up = "green"
            right = "blue"
            down = "yellow"
            left = "red"
        }
        Main_Pic.setHidden(false)
    }
    
    
    
    //resets all values and returns to main menu
    @IBAction func Restart_button_Action() {
        
        Results_label.setHidden(true)
        Accuracy_label.setHidden(true)
        Press_label.setHidden(true)
        Restart_button.setHidden(true)
        Welcome.setHidden(false)
        Initial.setHidden(false)
        current_round = 0.0
        press_time = 0.0
        total_press_time = 0.0
        successful_swipes = 0.0
        total_swipes = 0.0
        seconds = 30.0
        WKInterfaceController.reloadRootControllers(withNames: ["Main Menu"], contexts: ["Main Menu"])
    }
    
    // holding down on white
    @objc func counter(){
        print("counter")
        print(seconds)
        Main_Pic.setAlpha(CGFloat(seconds/30.0))
        seconds -= 1
        if (seconds <= 0){
            print("invalidating")
            timer.invalidate()
                
        }
    }
    
    // colored flower fading in
    @objc func counter_open(){
        print("counter_open")
        print(seconds)
        Main_Pic.setAlpha(CGFloat(seconds/10.0))
        seconds += 1
        if (seconds >= 10)
            {print("counter open done")
                timer_open.invalidate()
                longPress.isEnabled = false
                SwipeUp.isEnabled = true
                SwipeDown.isEnabled = true
                SwipeRight.isEnabled = true
                SwipeLeft.isEnabled = true
        }
    }
    
    //white flower fading in
    @objc func counter_reset(){
        print("counter_reset")
        Main_Pic.setAlpha(CGFloat(seconds/10.0))
        seconds += 1
        if (seconds >= 10){
            timer_reset.invalidate()
            longPress.isEnabled = true
            SwipeUp.isEnabled = false
            SwipeDown.isEnabled = false
            SwipeRight.isEnabled = false
            SwipeLeft.isEnabled = false
            seconds = 30
        }
    }
    
    @objc func counter_press(){
        press_time += 0.1
    }
    
    
    @IBAction func longPressAction(_ gestureRecognizer: WKLongPressGestureRecognizer) {
        if gestureRecognizer.state == .began{
            print("began")
            timer_press = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector (LotusController.counter_press), userInfo: nil, repeats: true)
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector (LotusController.counter), userInfo: nil, repeats: true)
            //DispatchQueue.main.asyncAfter(1.0)
        }
        if gestureRecognizer.state == .ended{
            print("ended")
            seconds = 0
            Main_Pic.setAlpha(0.0)
            randomize_color()
            timer_open = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector (LotusController.counter_open), userInfo: nil, repeats: true)
            timer_press.invalidate()
            total_press_time += press_time
            press_time = 0
        }
        else{
            print("else")
        }
    }
    
    @objc func reset(){
        current_round += 1
        if (current_round > total_rounds){
            longPress.isEnabled = false
            SwipeUp.isEnabled = false
            SwipeDown.isEnabled = false
            SwipeRight.isEnabled = false
            SwipeLeft.isEnabled = false
            Main_Pic.setHidden(true)
            Results_label.setHidden(false)
            Accuracy_label.setText("Correct Swipes: " + String(format: "%.2f", (successful_swipes/total_swipes)*100) + "%")
            Accuracy_label.setHidden(false)
            Press_label.setText("Average Press Time: " + String(format: "%.2f", (total_press_time/total_rounds)) + "s")
            Press_label.setHidden(false)
            Restart_button.setHidden(false)
        }
        else{
            Main_Pic.setImageNamed("lotus_closed")
            Main_Pic.setAlpha(0.0)
            seconds = 0
            timer_reset = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector (LotusController.counter_reset), userInfo: nil, repeats: true)
        }
    }
    
    //chooses a random color to show
    @objc func randomize_color(){
        let number = Int.random(in: 1 ..< 5)
        if (number == 1){
            current_image = "red"
            Main_Pic.setImageNamed("lotus_red")
        }
        else if (number == 2){
            current_image = "green"
            Main_Pic.setImageNamed("lotus_green")
        }
        else if (number == 3){
            current_image = "blue"
            Main_Pic.setImageNamed("lotus_blue")
        }
        else {
            current_image = "yellow"
            Main_Pic.setImageNamed("lotus_yellow")
        }
    }
    

    // After tapping on lotus reset and disable tap
    @IBAction func TapAction(_ sender: Any) {
        reset()
        Tap.isEnabled = false
    }
    
    
    @IBAction func SwipeRightAction(_ sender: Any) {
        if (current_image == right){
            WKInterfaceDevice.current().play(.success)
            successful_swipes += 1
            total_swipes += 1
            reset()
            sendData(game: "lotus", what: "swipe", correct: "true")
        }
        else{
            WKInterfaceDevice.current().play(.failure)
            total_swipes += 1
            sendData(game: "lotus", what: "swipe", correct: "false")
        }
    }
    @IBAction func SwipeUpAction(_ sender: Any) {
        if (current_image == up){
            WKInterfaceDevice.current().play(.success)
            successful_swipes += 1
            total_swipes += 1
            reset()
            sendData(game: "lotus", what: "swipe", correct: "true")
        }
        else{
            WKInterfaceDevice.current().play(.failure)
            total_swipes += 1
            sendData(game: "lotus", what: "swipe", correct: "false")
        }
    }
    @IBAction func SwipeDownAction(_ sender: Any) {
        if (current_image == down){
            WKInterfaceDevice.current().play(.success)
            successful_swipes += 1
            total_swipes += 1
            reset()
            sendData(game: "lotus", what: "swipe", correct: "true")
        }
        else{
            WKInterfaceDevice.current().play(.failure)
            total_swipes += 1
            sendData(game: "lotus", what: "swipe", correct: "false")
        }
    }
    @IBAction func SwipeLeftAction(_ sender: Any) {
        if (current_image == left){
            WKInterfaceDevice.current().play(.success)
            successful_swipes += 1
            total_swipes += 1
            reset()
            sendData(game: "lotus", what: "swipe", correct: "true")
        }
        else{
            WKInterfaceDevice.current().play(.failure)
            total_swipes += 1
            sendData(game: "lotus", what: "swipe", correct: "false")
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
