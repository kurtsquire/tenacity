//
//  PetInteractionController.swift
//  TenacityV3 WatchKit Extension
//
//  Created by Richie on 10/7/19.
//  Copyright © 2019 PLL. All rights reserved.
//

import WatchKit
import WatchConnectivity

class PetInteractionController: WatchViewController{
    
    var calendar = Calendar.autoupdatingCurrent
    @IBOutlet weak var numLabel: WKInterfaceLabel!
    var happiness : Int = 0
    var lastPlayedTime : Date = Date()
    @IBOutlet weak var barImage: WKInterfaceImage!
    @IBOutlet weak var petImage: WKInterfaceImage!
    @IBAction func foodButtonAction() {
        if (happiness < 10){
            happiness += 1
        }
        numLabel.setText(String(happiness))
        UserDefaults.standard.set(happiness, forKey: "petHappiness")
        UserDefaults.standard.set(Date(), forKey: "lastPlayedTime")
    }
    @IBAction func waterButtonAction() {
        if (happiness < 10){
            happiness += 1
        }
        numLabel.setText(String(happiness))
        UserDefaults.standard.set(happiness, forKey: "petHappiness")
        UserDefaults.standard.set(Date(), forKey: "lastPlayedTime")
    }
    
    func testUserDefaults(){
        let defaults = UserDefaults.standard
        happiness = defaults.integer(forKey: "petHappiness")
        lastPlayedTime = defaults.object(forKey: "lastPlayedTime") as? Date ?? Date()
    }
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        
    }
    
    override func willActivate() {
        super.willActivate()
        let pet = UserDefaults.standard.string(forKey: "equippedPet") ?? "bay"
        petImage.setImageNamed(pet)
        
        testUserDefaults()
        decreaseHappiness()
    }

    func decreaseHappiness(){
        let differenceSeconds = Int(lastPlayedTime.timeIntervalSinceNow)
        let difference = (differenceSeconds/(1800))
        happiness += difference
        if happiness < 0{
            happiness = 0
        }
        UserDefaults.standard.set(happiness, forKey: "petHappiness")
        numLabel.setText(String(happiness))
        
    }
}
