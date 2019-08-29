//
//  Companions.swift
//  TenacityV3
//
//  Created by Richie on 8/28/19.
//  Copyright © 2019 PLL. All rights reserved.
//

import Foundation

class Companions{
    let commons = [1,4,7,10,13,16,19,22,25,28]
    let rares = [2,5,8,11,14,17,20,23,26,29]
    let legendaries = [3,6,9,12,15,18,21,24,27,30]
    
    //var obtainablePets : [Int] = []
    var commonObtainables : [Int] = []
    var rareObtainables : [Int] = []
    var legendaryObtainables : [Int] = []
    
    func generateObtainablePets(){
        for pet in petOwned{
            //if you own a common
            if commons.contains(pet){
                //if you own the rare version
                if (petOwned.contains(pet + 1)){
                    //if you do not own legendary version add it
                    if !(petOwned.contains(pet + 2)){
                        legendaryObtainables.append(pet + 2)
                    }
                }
                else{ // do not own rare so you add it
                    rareObtainables.append(pet + 1)
                }
            }
        }
        //add all the commons you do not have
        for common in commons{
            if !petOwned.contains(common){
                commonObtainables.append(common)
            }
        }
    }
    
    func generateRandomPet() -> Int{
        generateObtainablePets()
        
        
        if (commonObtainables.isEmpty && rareObtainables.isEmpty && legendaryObtainables.isEmpty){
            return 0
        }
        let num = Int.random(in: 1 ... 10)
        if (num <= 6){ //give common
            if commonObtainables.isEmpty{
                if rareObtainables.isEmpty{
                    return legendaryObtainables.randomElement()!
                }
                return rareObtainables.randomElement()!
            }
            return commonObtainables.randomElement()!
            
        }
        else if (num <= 9){ //give rare
            if rareObtainables.isEmpty{
                if commonObtainables.isEmpty{
                    return legendaryObtainables.randomElement()!
                }
                else{
                    return commonObtainables.randomElement()!
                }
            }
            return rareObtainables.randomElement()!
        }
        else{ //give legendary
            if legendaryObtainables.isEmpty{
                if rareObtainables.isEmpty{
                    return commonObtainables.randomElement()!
                }
                return rareObtainables.randomElement()!
            }
            return legendaryObtainables.randomElement()!
        }
    }
}
