//
//  CompanionsViewController.swift
//  TenacityV3
//
//  Created by PLL on 7/30/19.
//  Copyright © 2019 PLL. All rights reserved.
//


import UIKit

let petArray = ["bay", "fjol", "cleo", "eldur", "halo", "sage", "raz", "koko", "rio", "aqua", "royal", "indigo", "mar", "phoenix", "bly", "dioon", "toor", "reese", "navy", "iris", "loch", "river", "bahn", "zbut", "sierra", "echo", "nova", "jade", "koda", "bayou", "kolbi", "liyah", "rye", "qut", "yoko", "trii", "tala", "kitchi", "opal", "paytah", "gou", "axel", "wol", "sigma", "pi"]
var petOwned = [1]
var petEquipped = 0

class CompanionsViewController: PhoneViewController {
    
    @IBOutlet var equipLabels: [UILabel]!
    @IBOutlet var companionsButtons: [UIButton]!
    
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
    
    override func viewDidAppear(_ animated: Bool) { //openign back up the tab (works from other tabs)
        super.viewDidAppear(animated)
        
        updatePetData()
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
    
    func equipPet(pet : Int){
        petEquipped = pet
        UserDefaults.standard.set(petEquipped, forKey: "petEquipped")
        saveToRealm(what: "equip pet: " + petArray[petEquipped])
    }
    
    override func testUserDefaults(){
        let defaults = UserDefaults.standard


        petOwned = defaults.array(forKey: "petOwned") as? [Int] ?? [1]
        petEquipped = defaults.integer(forKey: "petEquipped")
    }
    
    
}
