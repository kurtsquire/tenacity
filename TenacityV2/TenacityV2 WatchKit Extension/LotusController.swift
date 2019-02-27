//
//  InterfaceController.swift
//  Flower WatchKit Extension
//
//  Created by PLL on 1/26/19.
//  Copyright © 2019 PLL. All rights reserved.
//

import WatchKit
import Foundation

var total_rounds = 10.0

class LotusController: WKInterfaceController {

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    
        // Configure interface objects here.
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
    
    @IBAction func start_game_action() {
        WKInterfaceController.reloadRootControllers(withNames: ["Lotus Game"], contexts: ["Lotus Game"])
    }
    
    var up = "red"
    var down = "blue"
    var right = "green"
    var left = "yellow"
    var current_image = "green"
    
    var press_time = 0.0
    var total_press_time = 0.0
    var successful_swipes = 0.0
    var total_swipes = 0.0
    
    var timer = Timer()
    var timer_open = Timer()
    var timer_reset = Timer()
    var timer_press = Timer()
    
    var seconds = 30.0
    
    @IBOutlet var Welcome: WKInterfaceLabel!
    @IBOutlet var Initial: WKInterfaceLabel!
    @IBAction func InitialTap(_ sender: Any) {
        Welcome.setHidden(true)
        Initial.setHidden(true)
        Instructions.setHidden(false)
    }
    @IBOutlet var Instructions: WKInterfaceLabel!
    @IBAction func InstructionsTap(_ sender: Any) {
        Instructions.setHidden(true)
        closed.setHidden(false)
        Tap.isEnabled = true
        closed.setImageNamed("flower_guide")
    }
    
    
    @IBOutlet var closed: WKInterfaceImage!
    @IBOutlet var Results_label: WKInterfaceLabel!
    @IBOutlet var Accuracy_label: WKInterfaceLabel!
    @IBOutlet var Press_label: WKInterfaceLabel!
    
    @IBOutlet var Restart_button: WKInterfaceButton!
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
    
    @objc func counter(){
        print(seconds)
        closed.setAlpha(CGFloat(seconds/30.0))
        seconds -= 1
        if (seconds < 0)
            {timer.invalidate()}
    }
    
    @objc func counter_open(){
        closed.setAlpha(CGFloat(seconds/20.0))
        seconds += 1
        if (seconds > 20)
            {timer_open.invalidate()
                longPress.isEnabled = false
                SwipeUp.isEnabled = true
                SwipeDown.isEnabled = true
                SwipeRight.isEnabled = true
                SwipeLeft.isEnabled = true
        }
    }
    
    @objc func counter_reset(){
        print(seconds)
        closed.setAlpha(CGFloat(seconds/10.0))
        seconds += 1
        if (seconds >= 10){
            print("reset")
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
    
    @IBOutlet var longPress: WKLongPressGestureRecognizer!
    @IBAction func longPressAction(_ gestureRecognizer: WKLongPressGestureRecognizer) {
        if gestureRecognizer.state == .began{
            timer_press = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector (LotusController.counter_press), userInfo: nil, repeats: true)
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector (LotusController.counter), userInfo: nil, repeats: true)
            //DispatchQueue.main.asyncAfter(1.0)
        }
        if gestureRecognizer.state == .ended{
            seconds = 0
            closed.setAlpha(0.0)
            randomize_color()
            timer_open = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector (LotusController.counter_open), userInfo: nil, repeats: true)
            timer_press.invalidate()
            total_press_time += press_time
            press_time = 0
        }
    }
    
    @objc func reset(){
        current_round += 1
        print(current_round)
        if (current_round > total_rounds){
            longPress.isEnabled = false
            SwipeUp.isEnabled = false
            SwipeDown.isEnabled = false
            SwipeRight.isEnabled = false
            SwipeLeft.isEnabled = false
            closed.setHidden(true)
            Results_label.setHidden(false)
            Accuracy_label.setText("Correct Swipes: " + String(format: "%.2f", (successful_swipes/total_swipes)*100) + "%")
            Accuracy_label.setHidden(false)
            Press_label.setText("Average Press Time: " + String(format: "%.2f", (total_press_time/total_rounds)) + "s")
            Press_label.setHidden(false)
            Restart_button.setHidden(false)
            print("end")
        }
        else{
            closed.setImageNamed("lotus_closed")
            closed.setAlpha(0.0)
            seconds = 0
            timer_reset = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector (LotusController.counter_reset), userInfo: nil, repeats: true)
        }
    }
    
    @objc func randomize_color(){
        let number = Int.random(in: 0 ..< 5)
        print(number)
        if (number == 1){
            current_image = "red"
            closed.setImageNamed("lotus_red")
        }
        else if (number == 2){
            current_image = "green"
            closed.setImageNamed("lotus_green")
        }
        else if (number == 3){
            current_image = "blue"
            closed.setImageNamed("lotus_blue")
        }
        else {
            current_image = "yellow"
            closed.setImageNamed("lotus_yellow")
        }
        print(current_image)
    }
    
    
    @IBOutlet var Tap: WKTapGestureRecognizer!
    @IBAction func TapAction(_ sender: Any) {
        reset()
        Tap.isEnabled = false
    }
    
    @IBOutlet var SwipeUp: WKSwipeGestureRecognizer!
    @IBOutlet var SwipeDown: WKSwipeGestureRecognizer!
    @IBOutlet var SwipeRight: WKSwipeGestureRecognizer!
    @IBOutlet var SwipeLeft: WKSwipeGestureRecognizer!
    
    
    @IBAction func SwipeRightAction(_ sender: Any) {
        if (current_image == right){
            WKInterfaceDevice.current().play(.success)
            successful_swipes += 1
            total_swipes += 1
            reset()
        }
        else{
            WKInterfaceDevice.current().play(.failure)
            total_swipes += 1
        }
        
        
    }
    @IBAction func SwipeUpAction(_ sender: Any) {
        if (current_image == up){
            WKInterfaceDevice.current().play(.success)
            successful_swipes += 1
            total_swipes += 1
            reset()
        }
        else{
            WKInterfaceDevice.current().play(.failure)
            total_swipes += 1
        }
    }
    @IBAction func SwipeDownAction(_ sender: Any) {
        if (current_image == down){
            WKInterfaceDevice.current().play(.success)
            successful_swipes += 1
            total_swipes += 1
            reset()
        }
        else{
            WKInterfaceDevice.current().play(.failure)
            total_swipes += 1
        }
    }
    @IBAction func SwipeLeftAction(_ sender: Any) {
        if (current_image == left){
            WKInterfaceDevice.current().play(.success)
            successful_swipes += 1
            total_swipes += 1
            reset()
        }
        else{
            WKInterfaceDevice.current().play(.failure)
            total_swipes += 1
        }
    }
}
