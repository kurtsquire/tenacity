//
//  Pet.swift
//  TenacityV3
//
//  Created by PLL on 7/29/19.
//  Copyright © 2019 PLL. All rights reserved.
//

import Foundation

class Pet{
    var name : String  //The pet's name
    var level : Int = 1  //The pet's level
    var form : Int = 1  //Which form the pet is in
    var exp : Int = 0  //How much experience the pet has
    var equipped : Bool = false  //Whether the pet is equipped
    var rarity : String  //How rare the pet is (Common, Uncommmon, Rare, Exotic, Mythical? Names and count may change)
    var ownerNick : String  //What the pet calls you (optional)
    var lv2Threshold : Int  //How much experience required to reach Lv 2
    var lv3Threshold : Int  //How much experience required to reach Lv 3
    
    init(n: String, o: String = "", r: String, lv2: Int, lv3: Int){
        self.name = n
        self.ownerNick = o
        self.rarity = r
        self.lv2Threshold = lv2
        self.lv3Threshold = lv3
    }
    
    func getName() -> String{
        return name
    }
    
    func getLevel() -> Int{
        return level
    }
    
    func getExp() -> Int{
        return exp
    }
    
    func getForm() -> Int{
        return form
    }
    
    func isEquipped() -> Bool{
        return equipped
    }
    
    func getRarity() -> String{
        return rarity
    }
    
    func getOwner() -> String{
        return ownerNick
    }
    func addExp(xp: Int){
        exp += xp
        if level == 1 && exp >= lv2Threshold{
            level = 2
        }
        if level == 2 && exp >= lv3Threshold{
            level = 3
        }
    }
    
    func changeForm(f: Int){
        form = f
    }
    
    func changeNick(nick: String){
        ownerNick = nick
    }
}
