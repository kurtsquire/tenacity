//
//  Companions.swift
//  TenacityV3
//
//  Created by Richie on 8/28/19.
//  Copyright © 2019 PLL. All rights reserved.
//

// This class handles generating pets to function as quest rewards

import Foundation

class Companions{
    
    // index of all pets
    let commons = [1,4,7,10,13,16,19,22,25,28,31,34,37,40,43]
    let rares = [2,5,8,11,14,17,20,23,26,29,32,35,38,41,44]
    let legendaries = [3,6,9,12,15,18,21,24,27,30,33,36,39,42,45]
    
    var commonObtainables : [Int] = []
    var rareObtainables : [Int] = []
    var legendaryObtainables : [Int] = []
    
    // -------------------------------------------------------------------------------
    
    //update owned pets
    func updateOwnedPets(){
        let defaults = UserDefaults.standard
        petOwned = defaults.array(forKey: "petOwned") as? [Int] ?? [1]
    }
    
    
    // creates a list of all pets that you can get from a quest
    func generateObtainablePets(){
        updateOwnedPets()
        
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
    
    
    //choosees a random pet form the list of obtainable pets
    func generateRandomPet() -> Int{
        generateObtainablePets()
        
        if (commonObtainables.isEmpty && rareObtainables.isEmpty && legendaryObtainables.isEmpty){
            return 0
        }
        let num = Int.random(in: 1 ... 20)
        if (num <= 16){ //give common
            if commonObtainables.isEmpty{
                if rareObtainables.isEmpty{
                    return legendaryObtainables.randomElement()!
                }
                return rareObtainables.randomElement()!
            }
            return commonObtainables.randomElement()!
            
        }
        else if (num <= 19){ //give rare
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
