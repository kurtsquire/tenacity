//
//  CompanionsViewController.swift
//  TenacityV3
//
//  Created by PLL on 7/30/19.
//  Copyright © 2019 PLL. All rights reserved.
//


import UIKit
import WatchConnectivity
import RealmSwift

let petArray = ["bay", "fjol", "cleo", "eldur", "halo", "sage", "raz", "koko", "rio", "aqua", "royal", "indigo", "mar", "phoenix", "bly", "dioon", "toor", "reese", "navy", "iris", "loch", "river", "bahn", "zbut", "sierra", "echo", "nova", "jade", "koda", "bayou", "kolbi", "liyah", "rye", "qut", "yoko", "trii", "tala", "kitchi", "opal", "paytah", "gou", "axel", "wol", "sigma", "pi"]
var petOwned = [1]
var petEquipped = 0
var petNumber = 1

class CompanionsViewController: PhoneViewController {
    
    @IBOutlet var equipLabels: [UILabel]!
    @IBOutlet var companionsButtons: [UIButton]!
    var companionTutorialCompleted = false
    
    var achievementsCompleted: [Int] = []
    
    let calendar = Calendar.autoupdatingCurrent
    var today = Date()
    var startTime = Date()
    
    var mtxOwnedBreathe = [0]
    var mtxOwnedBreatheC = [0]
    var mtxOwnedLotus = [0]
    var mtxOwnedLotusC = [0]
    
    var nudge1 = ""
    var nudge2 = ""
    var nudge3 = ""
    var nudge4 = ""
    var nudge5 = ""
    var nudge6 = ""
    
    var egg1Time = 0.0
    var egg2Time = 0.0
    var egg3Time = 0.0
    var egg4Time = 0.0
    var egg5Time = 0.0
    var egg6Time = 0.0
    
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
        
        today = Date()
        startTime = calendar.startOfDay(for: today)
        
        testUserDefaults()
        checkForAchievements()
        updatePetData()
        
        if !companionTutorialCompleted{
            let storyBoard: UIStoryboard = UIStoryboard(name: "Companions", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "Companions Popup")

            self.present(newViewController, animated: true, completion: nil)
        }
    }
    
    func updatePetData(){
        
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
        
        exp = defaults.integer(forKey: "exp")
        
        companionTutorialCompleted = defaults.bool(forKey: "companionTutorialCompleted")
        
        mtxOwnedBreathe = defaults.array(forKey: "mtxOwnedBreathe") as? [Int] ?? [0]
        mtxOwnedBreatheC = defaults.array(forKey: "mtxOwnedBreatheC") as? [Int] ?? [0]
        mtxOwnedLotus = defaults.array(forKey: "mtxOwnedLotus") as? [Int] ?? [0]
        mtxOwnedLotusC = defaults.array(forKey: "mtxOwnedLotusC") as? [Int] ?? [0]
        
        nudge1 =  defaults.string(forKey: "dateString0") ?? "No Current Nudge"
        nudge2 = defaults.string(forKey: "dateString1") ?? "No Current Nudge"
        nudge3 = defaults.string(forKey: "dateString2") ?? "No Current Nudge"
        nudge4 = defaults.string(forKey: "dateString3") ?? "No Current Nudge"
        nudge5 = defaults.string(forKey: "dateString4") ?? "No Current Nudge"
        nudge6 = defaults.string(forKey: "dateString5") ?? "No Current Nudge"
        
        egg1Time = defaults.double(forKey: "egg1")
        egg2Time = defaults.double(forKey: "egg2")
        egg3Time = defaults.double(forKey: "egg3")
        egg4Time = defaults.double(forKey: "egg4")
        egg5Time = defaults.double(forKey: "egg5")
        egg6Time = defaults.double(forKey: "egg6")
        
        print(egg1Time)
        print(egg2Time)
        print(egg3Time)
        print(egg4Time)
        print(egg5Time)
        print(egg6Time)
        
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
    
    func checkForAchievements(){
        //will check an achievements list for all completed achievements and make sure appropriate pets are unlocked
        let AList = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31]
        for i in AList{
            if !petOwned.contains(i+1){
                checkConditions(x: i)
            }
        }
    }
    
    func checkConditions(x: Int){
        //check check specific achievement
        let realm = try! Realm()
        let bfx = realm.objects(GameDataModel.self).filter("gameTitle = %@", "breathe focus")
        let bix = realm.objects(GameDataModel.self).filter("gameTitle = %@", "breathe infinite")
        let lsx = realm.objects(GameDataModel.self).filter("gameTitle = %@", "lotus")
        if x == 1{
            //played breatheF
            if bfx.count > 0{
                achievementComplete(x: 1)
            }
        }
        else if x == 2{
            //played all activities
            if bfx.count > 0 && bix.count > 0 && lsx.count > 0{
                achievementComplete(x: 2)
            }
        }
        else if x >= 3 && x <= 5{
            // total breatheFocus time
            var time = 0.0
            for item in bfx{
                time += item.breatheFTimePlayed
            }
            if x == 3{
                if time >= 20*60{
                    achievementComplete(x: 3)
                }
            }
            else if x == 4{
                if time >= 60*60{
                    achievementComplete(x: 4)
                }
            }
            else if x == 5{
                if time >= 180*60{
                    achievementComplete(x: 5)
                }
            }
        }
        else if x >= 6 && x <= 8{
            //total breaths
            var breaths = 0
            for item in bfx{
                if item.gameDataType == "stop hold"{
                    breaths += 1
                }
            }
            if x == 6{
                if breaths >= 100{
                    achievementComplete(x: 6)
                }
            }
            if x == 7{
                if breaths >= 500{
                    achievementComplete(x: 7)
                }
            }
            if x == 8{
                if breaths >= 2000{
                    achievementComplete(x: 8)
                }
            }
        }
        else if x >= 9 && x <= 11{
            //correct breathe sets
            var correct = 0
            for item in bfx{
                correct += item.breatheFCorrectSets
            }
            if x == 9{
                if correct >= 20{
                    achievementComplete(x: 9)
                }
            }
            if x == 10{
                if correct >= 100{
                    achievementComplete(x: 10)
                }
            }
            if x == 11{
                if correct >= 500{
                    achievementComplete(x: 11)
                }
            }
        }
            //set a nudge
        else if x == 12{
            //set
            if nudge1 != "No Current Nudge" ||
            nudge2 != "No Current Nudge" ||
            nudge3 != "No Current Nudge" ||
            nudge4 != "No Current Nudge" ||
            nudge5 != "No Current Nudge" ||
            nudge6 != "No Current Nudge" {
                achievementComplete(x: 12)
            }
        }
        else if x == 13{
            //use
        }
        else if x == 14{
            //use 5x
        }
        //reach rank x
        else if x == 15{
            if exp > 1000{
                achievementComplete(x: 15)
            }
        }
        else if x == 16{
            if exp > 5000{
                achievementComplete(x: 16)
            }
        }
        else if x == 17{
            if exp > 10000{
                achievementComplete(x: 17)
            }
        }
        //set a goal
        else if x == 18{
            //15 min
            let goal = Double(UserDefaults.standard.integer(forKey: "breatheFGoalTime"))
            if goal >= 15{
                achievementComplete(x: 18)
            }
        }
        else if x == 19{
            // reach
            let goal = Double(UserDefaults.standard.integer(forKey: "breatheFGoalTime"))
            let bfxtoday = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@", "breathe focus", startTime)
            var time = 0.0
            for i in bfxtoday{
                time += i.breatheFTimePlayed
            }
            if goal >= 15 && time/60 >= goal{
                achievementComplete(x: 19)
            }
        }
        else if x == 20{
            // reach 5
            let goal = Double(UserDefaults.standard.integer(forKey: "breatheFGoalTime"))
            let bfxtoday = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@", "breathe focus", startTime)
            var time = 0.0
            for i in bfxtoday{
                time += i.breatheFTimePlayed
            }
            if goal >= 30 && time/60 >= goal{
                achievementComplete(x: 20)
            }
        }
        //purchase upgrades
        else if x == 21{
            //1
            var total = 0
            total += mtxOwnedBreathe.count
            total += mtxOwnedBreatheC.count
            total += mtxOwnedLotus.count
            total += mtxOwnedLotusC.count
            if total >= 5{
                achievementComplete(x: 21)
            }
        }
        else if x == 22{
            //5
            var total = 0
            total += mtxOwnedBreathe.count
            total += mtxOwnedBreatheC.count
            total += mtxOwnedLotus.count
            total += mtxOwnedLotusC.count
            if total >= 9{
                achievementComplete(x: 22)
            }
        }
        else if x == 23{
            //all
            var total = 0
            total += mtxOwnedBreathe.count
            total += mtxOwnedBreatheC.count
            total += mtxOwnedLotus.count
            total += mtxOwnedLotusC.count
            if total >= 16{
                achievementComplete(x: 23)
            }
        }
            //hatch eggs
        else if x == 24{
            
        }
        else if x == 25{
            
        }
        else if x == 26{
            
        }
        //egg 1
        else if x == 27{
            if egg1Time >= 3.0{
                achievementComplete(x: 27)
            }
        }
        else if x == 28{
            
        }
        else if x == 29{
            
        }
        
        //egg 2
        else if x == 30{}
        else if x == 31{}
        else if x == 32{}
        
        //egg 3
        else if x == 33{}
        else if x == 34{}
        else if x == 35{}
        
        //egg 4
        else if x == 36{}
        else if x == 37{}
        else if x == 38{}
        
        //egg 5
        else if x == 39{}
        else if x == 40{}
        else if x == 41{}
        
        //egg 6
        else if x == 42{}
        else if x == 43{}
        else if x == 44{}

    }
    
    func achievementComplete(x: Int){
        petOwned.append(x + 1)
        UserDefaults.standard.set(petOwned, forKey: "petOwned")
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
            achievementLabel.text = "Breathe 100 times in Breathe Focus"
        }
        else if (x == 7){
            achievementLabel.text = "Breathe 500 times in Breathe Focus"
        }
        else if (x == 8){
            achievementLabel.text = "Breathe 2000 times in Breathe Focus"
        }
        //
        else if (x == 9){
            achievementLabel.text = "Do 25 correct sets in Breathe Focus"
        }
        else if (x == 10){
            achievementLabel.text = "Do 100 sets in Breathe Focus"
        }
        else if (x == 11){
            achievementLabel.text = "Do 500 sets in Breathe Focus"
        }
        //
        else if (x == 12){
            achievementLabel.text = "set a nudge"
        }
        else if (x == 13){
            achievementLabel.text = "Use Breathe Focus within 5 minutes of a set nudge"
        }
        else if (x == 14){
            achievementLabel.text = "Use Breathe Focus within 5 minutes of a set nudge 5 times total"
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
            achievementLabel.text = "Set a goal of at least 15 minutes for Breathe Focus"
        }
        else if (x == 19){
            achievementLabel.text = "Reach your goal for Breathe Focus (while set to at least 15 minutes)"
        }
        else if (x == 20){
            achievementLabel.text = "Reach your goal for Breathe Focus (while set to at least 30 minutes)"
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
            achievementLabel.text = "Hatch an egg"
        }
        else if (x == 25){
            achievementLabel.text = "Hatch 3 eggs"
        }
        else if (x == 26){
            achievementLabel.text = "Hatch all 6 eggs"
        }
        else if (x == 27){
            achievementLabel.text = "Purchase Egg 1 and breathe with it in Breathe Focus for 30 minutes to hatch it"
        }
        else if (x == 28){
            achievementLabel.text = "Purchase Egg 1 and breathe with it in Breathe Focus for 1 hour to hatch it"
        }
        else if (x == 29){
            achievementLabel.text = "Purchase Egg 1 and breathe with it in Breathe Focus for 2 hours to hatch it"
        }
        else if (x == 30){
            achievementLabel.text = "Purchase Egg 2 and breathe with it in Breathe Focus for 30 minutes to hatch it"
        }
        else if (x == 31){
            achievementLabel.text = "Purchase Egg 2 and breathe with it in Breathe Focus for 1 hour to hatch it"
        }
        else if (x == 32){
            achievementLabel.text = "Purchase Egg 2 and breathe with it in Breathe Focus for 2 hours to hatch it"
        }
        else if (x == 33){
            achievementLabel.text = "Purchase Egg 3 and breathe with it in Breathe Focus for 30 minutes to hatch it"
        }
        else if (x == 34){
            achievementLabel.text = "Purchase Egg 3 and breathe with it in Breathe Focus for 1 hour to hatch it"
        }
        else if (x == 35){
            achievementLabel.text = "Purchase Egg 3 and breathe with it in Breathe Focus for 2 hours to hatch it"
        }
        else if (x == 36){
            achievementLabel.text = "Purchase Egg 4 and breathe with it in Breathe Focus for 30 minutes to hatch it"
        }
        else if (x == 37){
            achievementLabel.text = "Purchase Egg 4 and breathe with it in Breathe Focus for 1 hour to hatch it"
        }
        else if (x == 38){
            achievementLabel.text = "Purchase Egg 4 and breathe with it in Breathe Focus for 2 hours to hatch it"
        }
        else if (x == 39){
            achievementLabel.text = "Purchase Egg 5 and breathe with it in Breathe Focus for 30 minutes to hatch it"
        }
        else if (x == 40){
            achievementLabel.text = "Purchase Egg 5 and breathe with it in Breathe Focus for 1 hour to hatch it"
        }
        else if (x == 41){
            achievementLabel.text = "Purchase Egg 5 and breathe with it in Breathe Focus for 2 hours to hatch it"
        }
        else if (x == 42){
            achievementLabel.text = "Purchase Egg 6 and breathe with it in Breathe Focus for 30 minutes to hatch it"
        }
        else if (x == 43){
            achievementLabel.text = "Purchase Egg 6 and breathe with it in Breathe Focus for 1 hour to hatch it"
        }
        else if (x == 44){
            achievementLabel.text = "Purchase Egg 6 and breathe with it in Breathe Focus for 2 hours to hatch it"
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
