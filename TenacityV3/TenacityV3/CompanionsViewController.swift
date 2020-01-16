//
//  CompanionsViewController.swift
//  TenacityV3
//
//  Created by PLL on 7/30/19.
//  Copyright © 2019 PLL. All rights reserved.
//


import UIKit
import WatchConnectivity

let petArray = ["bay", "fjol", "cleo", "eldur", "halo", "sage", "raz", "koko", "rio", "aqua", "royal", "indigo", "mar", "phoenix", "bly", "dioon", "toor", "reese", "navy", "iris", "loch", "river", "bahn", "zbut", "sierra", "echo", "nova", "jade", "koda", "bayou", "kolbi", "liyah", "rye", "qut", "yoko", "trii", "tala", "kitchi", "opal", "paytah", "gou", "axel", "wol", "sigma", "pi"]
var petOwned = [1]
var petEquipped = 0
var petNumber = 1

class CompanionsViewController: PhoneViewController {
    
    @IBOutlet var equipLabels: [UILabel]!
    @IBOutlet var companionsButtons: [UIButton]!
    var companionTutorialCompleted = false
    
    @IBAction func companionsButtonPressed(_ sender: UIButton) {

        if (petOwned.contains(sender.tag)){
            
            equipPet(pet: sender.tag - 1)
            
            for equip in equipLabels {
                if equip.tag != sender.tag {
                    equip.isHidden = true
                }
                else {
                    equip.isHidden = false
                }
            }
        }
        else{
            petNumber = (sender.tag - 1)
            showPopup()
            
            //pop screen plus change label to achievement status
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // takes out top bar
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) { //opening back up the tab (works from other tabs)
        super.viewDidAppear(animated)
        
        updatePetData()
        
        if !companionTutorialCompleted{
            let storyBoard: UIStoryboard = UIStoryboard(name: "Companions", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "Companions Popup")

            self.present(newViewController, animated: true, completion: nil)
        }
    }
    
    func updatePetData(){
        testUserDefaults()
        
        for equip in equipLabels {
            if (equip.tag == petEquipped + 1) {
                equip.isHidden = false
            }
        }
        
        for button in companionsButtons{
            if (petOwned.contains(button.tag)){
                button.setImage(UIImage.init(named: petArray[button.tag - 1]), for: .normal)
            }
            else{
                button.setImage(UIImage.init(named: petArray[button.tag - 1] + " shadow"), for: .normal)
            }
        }

    }
    
    func showPopup(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Companions", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "Achievements Popup")

        self.present(newViewController, animated: true, completion: nil)
    }
    
    
    
    func equipPet(pet : Int){
        petEquipped = pet
        UserDefaults.standard.set(petEquipped, forKey: "petEquipped")
        saveToRealm(what: "equip pet: " + petArray[petEquipped])
        sendAppContext()
    }
    
    override func testUserDefaults(){
        let defaults = UserDefaults.standard

        petOwned = defaults.array(forKey: "petOwned") as? [Int] ?? [1]
        petEquipped = defaults.integer(forKey: "petEquipped")
        
        companionTutorialCompleted = defaults.bool(forKey: "companionTutorialCompleted")
    }
    
    func sendAppContext(){
        let session = WCSession.default
        
        if session.activationState == .activated {
            
            let data = ["pet": petArray[petEquipped]]
            do {
                try session.updateApplicationContext(data)
            } catch {
                print("Alert! Updating app context failed")
            }
        }
    }
    
    func checkForAchievement(){
        //will check an achievements list for all completed achievements and make sure appropriate pets are unlocked
    }
    
    func checkConditions(){
    }
}

class CompanionsPopupController: PhoneViewController {
    
    @IBOutlet weak var achievementLabel: UILabel!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        changePopupLabel(x: petNumber)
    }
    
    func changePopupLabel(x: Int){
        // change label based on int
        if (x == 1){
            achievementLabel.text = "Try out Breathe Focus"
        }
        else if (x == 2){
            achievementLabel.text = "Try out all activities on the watch"
        }
        //
        else if (x == 3){
            achievementLabel.text = "Use Breathe Focus for 20 minutes total"
        }
        else if (x == 4){
            achievementLabel.text = "Use Breathe Focus for 1 hours"
        }
        else if (x == 5){
            achievementLabel.text = "Use Breathe Focus for 3 hours"
        }
        //
        else if (x == 6){
            achievementLabel.text = "set a nudge"
        }
        else if (x == 7){
            achievementLabel.text = "Use Breathe Focus within 5 minutes of a set nudge"
        }
        else if (x == 8){
            achievementLabel.text = "Use Breathe Focus within 5 minutes of a set nudge 5 times total"
        }
        //
        else if (x == 9){
            achievementLabel.text = "Breathe 20 times in Breathe Focus"
        }
        else if (x == 10){
            achievementLabel.text = "Breathe 100 times in Breathe Focus"
        }
        else if (x == 11){
            achievementLabel.text = "Breathe 500 times in Breathe Focus"
        }
        //
        else if (x == 12){
            achievementLabel.text = "Do 10 sets in Breathe Focus"
        }
        else if (x == 13){
            achievementLabel.text = "Do 50 sets in Breathe Focus"
        }
        else if (x == 14){
            achievementLabel.text = "Do 250 sets in Breathe Focus"
        }
        //
        else if (x == 15){
            achievementLabel.text = "Reach Rank 2"
        }
        else if (x == 16){
            achievementLabel.text = "Reach Rank 5"
        }
        else if (x == 17){
            achievementLabel.text = "Reach Rank 10"
        }
        //
        else if (x == 18){
            achievementLabel.text = "Set a goal for Breathe Focus"
        }
        else if (x == 19){
            achievementLabel.text = "Reach your goal for Breathe Focus"
        }
        else if (x == 20){
            achievementLabel.text = "Reach your goal for Breathe Focus 5 times"
        }
        //
        else if (x == 21){
            achievementLabel.text = "Purchase an upgrade from the shop"
        }
        else if (x == 22){
            achievementLabel.text = "Purchase 5 upgrades from the shop"
        }
        else if (x == 23){
            achievementLabel.text = "Purchase all upgrades from the shop"
        }
        //
        else if (x == 24){
            achievementLabel.text = "Hatch a pet"
        }
        else if (x == 25){
            achievementLabel.text = "Hatch 3 pets"
        }
        else if (x == 26){
            achievementLabel.text = "Hatch all 6 pets"
        }
        //
        else{
            // shldnt be 0 (1st pet alrdy unlocked)
        }
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        dismiss(animated: true)
    }
}
