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
    //var equipped : Bool = false  //Whether the pet is equipped
    var rarity : String  //How rare the pet is (Common, Uncommmon, Rare, Exotic, Mythical? Names and count may change)
    var ownerNick : String  //What the pet calls you (optional)
    var lv2Threshold : Int = 1 //How much experience required to reach Lv 2
    var lv3Threshold : Int = 1 //How much experience required to reach Lv 3
    var unlocked : Bool // pet locked or unlocked yet
    
    init(n: String, o: String = "", r: String, ul: Bool, xp: Int = 0){
        self.name = n
        self.ownerNick = o
        self.rarity = r
        if (self.rarity == "common"){
            self.lv2Threshold = 1
            self.lv3Threshold = 1
        }
        else if (self.rarity == "uncommon"){
            self.lv2Threshold = 1
            self.lv3Threshold = 1
        }
        else if (self.rarity == "rare"){
            self.lv2Threshold = 1
            self.lv3Threshold = 1
        }
        else if (self.rarity == "epic"){
            self.lv2Threshold = 1
            self.lv3Threshold = 1
        }
        else if (self.rarity == "legendary"){
            self.lv2Threshold = 1
            self.lv3Threshold = 1
        }
        self.unlocked = ul
        
        //addExp(xp: xp)
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
    
    //func isEquipped() -> Bool{
    //    return equipped
    //}
    
    func getRarity() -> String{
        return rarity
    }
    
    func getOwner() -> String{
        return ownerNick
    }
    
    func isUnlocked() -> Bool{
        return unlocked
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
    
    //func equip(){
    //    equipped = true;
    //}
    
    //func dequip(){
    //    equipped = false;
    //}
    
    func unlock(){
        unlocked = true
    }
}
