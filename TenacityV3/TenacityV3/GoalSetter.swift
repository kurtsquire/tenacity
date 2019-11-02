//
//  GoalSetter.swift
//  TenacityV3
//
//  Created by Richie on 10/24/19.
//  Copyright © 2019 PLL. All rights reserved.
//

import Foundation
import UIKit

class GoalSetter: PhoneViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var breatheFGoalTime = 0.0
    var breatheIGoalTime = 0.0
    var lotusGoalTime = 0.0
    
    @IBOutlet weak var goalPicker: UIPickerView!
    @IBOutlet weak var goalLabel: UILabel!
    var pickerData: [String] = [String]()
    
    var tempString = "temp"
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // puts in top bar
        navigationController?.setNavigationBarHidden(false, animated: false)
        //goalPicker.setValue(UIColor.white, forKey: "textColor")
        testUserDefaults()
        //goalPicker.reloadAllComponents()
        updateTemp()
        
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // takes out top bar again
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        self.goalPicker.delegate = self
        self.goalPicker.dataSource = self
        fillPicker(x: 10)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // number of columns in picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // number of items in column
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // fills in picker with pickerData
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: String(pickerData[row]), attributes: [NSAttributedString.Key.foregroundColor:UIColor.white])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if currentGame == "breatheFocus"{
            UserDefaults.standard.set((pickerData[row]), forKey: "breatheFGoalTime")
            updateLabel(x: pickerData[row])
        }
        else if currentGame == "breatheInfinite"{
            UserDefaults.standard.set((pickerData[row]), forKey: "breatheIGoalTime")
            updateLabel(x: pickerData[row])
        }
        else if currentGame == "lotus"{
            UserDefaults.standard.set((pickerData[row]), forKey: "lotusGoalTime")
            updateLabel(x: pickerData[row])
        }
    }
    
    // fills in pickerData
    func fillPicker(x: Int){
        pickerData = []
        for i in x...30{
            pickerData.append(String(i))
        }
    }
    
    func updateTemp(){
        if currentGame == "breatheFocus"{
            tempString = "Breathe Focus Goal: "
            goalLabel.text = tempString + String(Int(breatheFGoalTime))
            
            //changes the selection to be current goal
            let r = Int(breatheFGoalTime) - 10
            goalPicker.selectRow(r, inComponent: 0, animated: true)
        }
        else if currentGame == "breatheInfinite"{
            tempString = "Breathe Infinite Goal: "
            goalLabel.text = tempString + String(Int(breatheIGoalTime))
            
            //changes the selection to be current goal
            let r = Int(breatheIGoalTime) - 10
            goalPicker.selectRow(r, inComponent: 0, animated: true)
        }
        else if currentGame == "lotus"{
            tempString = "Lotus Goal: "
            goalLabel.text = tempString + String(Int(lotusGoalTime))
            
            //changes the selection to be current goal
            let r = Int(lotusGoalTime) - 10
            goalPicker.selectRow(r, inComponent: 0, animated: true)
        }
    }
    
    func updateLabel(x: String){
        goalLabel.text = tempString + (x)
    }
    
    override func testUserDefaults() {
        // get goal times
        breatheFGoalTime = Double(UserDefaults.standard.integer(forKey: "breatheFGoalTime"))
        breatheIGoalTime = Double(UserDefaults.standard.integer(forKey: "breatheIGoalTime"))
        lotusGoalTime = Double(UserDefaults.standard.integer(forKey: "lotusGoalTime"))
    }
    
    
    
}
