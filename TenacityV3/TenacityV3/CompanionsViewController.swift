//
//  CompanionsViewController.swift
//  TenacityV3
//
//  Created by PLL on 7/30/19.
//  Copyright © 2019 PLL. All rights reserved.
//


import UIKit



class CompanionsViewController: PhoneViewController {
    
    @IBAction func jadeLeft(_ sender: Any) {
    }
    @IBAction func jadeRight(_ sender: Any) {
    }
    @IBOutlet weak var jadeExp: UILabel!
    @IBOutlet weak var jadePic: UIImageView!
    @IBOutlet weak var morgPic: UIImageView!
    @IBOutlet weak var morgExp: UILabel!
    
    
    // petname: [form 1->3, exp, unlocked]
    var allPets = ["Morgan": [petArray[0].getForm(), petArray[0].getExp(), petArray[0].isUnlocked()], "Jade": [petArray[1].getForm(), petArray[1].getExp(), petArray[1].isUnlocked()]]
    
    // changes the top font to white (time and battery life wifi etc)
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
        morgExp.text = String(petArray[0].getExp())
        jadeExp.text = String(petArray[1].getExp())
    }
    
    func testUserDefaults(){
        let defaults = UserDefaults.standard
        
        let temp = defaults.dictionary(forKey: "allPetsData") ?? [:]
        if !temp.isEmpty{
            allPets = temp
        }
        else{
            UserDefaults.standard.set(allPets, forKey: "allPetsData")
        }
    }
    
    
}
