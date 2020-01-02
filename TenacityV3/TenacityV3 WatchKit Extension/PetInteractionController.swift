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
    
    //var calendar = Calendar.autoupdatingCurrent
    
    @IBOutlet weak var heart1: WKInterfaceImage!
    @IBOutlet weak var heart2: WKInterfaceImage!
    @IBOutlet weak var heart3: WKInterfaceImage!
    @IBOutlet weak var heart4: WKInterfaceImage!
    @IBOutlet weak var heart5: WKInterfaceImage!
    @IBOutlet weak var heart6: WKInterfaceImage!
    @IBOutlet weak var heart7: WKInterfaceImage!
    @IBOutlet weak var heart8: WKInterfaceImage!
    @IBOutlet weak var heart9: WKInterfaceImage!
    @IBOutlet weak var heart10: WKInterfaceImage!
    
    var happiness : Int = 0
    var lastPlayedTime : Date = Date()
    
    @IBOutlet weak var petImage: WKInterfaceImage!
    @IBAction func foodButtonAction() {
        if (happiness < 10){
            happiness += 1
        }
        UserDefaults.standard.set(happiness, forKey: "petHappiness")
        UserDefaults.standard.set(Date(), forKey: "lastPlayedTime")
        updateHearts()
    }
    
    @IBAction func waterButtonAction() {
        if (happiness < 10){
            happiness += 1
        }
        UserDefaults.standard.set(happiness, forKey: "petHappiness")
        UserDefaults.standard.set(Date(), forKey: "lastPlayedTime")
        updateHearts()
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
        updateHearts()
        
//        if #available(watchOSApplicationExtension 6.0, *) {
//            let heart = UIImage(systemName: "heart")
//            heart1.setImage(heart)
//        } else {
//            // Fallback on earlier versions
//            print("not 6.0")
//        }
    }

    func decreaseHappiness(){
        let differenceSeconds = Int(lastPlayedTime.timeIntervalSinceNow)
        let difference = (differenceSeconds/(1800))
        happiness += difference
        if happiness < 0{
            happiness = 0
        }
        UserDefaults.standard.set(happiness, forKey: "petHappiness")
    }
    
    func updateHearts(){
        let hlist = [heart1, heart2, heart3, heart4, heart5, heart6, heart7, heart8, heart9, heart10]
        for h in hlist{
            h?.setImageNamed("heart1")
        }
        for x in 0..<(happiness){
            hlist[x]?.setImageNamed("heart")
        }
    }
    
}
