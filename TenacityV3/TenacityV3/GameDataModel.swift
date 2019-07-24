//
//  GameDataModel.swift
//  TenacityV3
//
//  Created by Richard Michael on 6/20/19.
//  Copyright © 2019 PLL. All rights reserved.
//

import Foundation
import RealmSwift

// test data to demonstrate realm objects
class GameDataModel: Object{
    @objc dynamic var gameTitle: String = ""
    //labled as "what"
    @objc dynamic var gameDataType: String = ""
    @objc dynamic var gameDataAccuracy: String = ""
    @objc dynamic var sessionDate: Date = Date()
    @objc dynamic var sessionEpoch: Double = 0.0
    //@objc dynamic var gameSettings: String = ""
    
    //lotus
    @objc dynamic var lotusRoundsPlayed: Int = 0
    @objc dynamic var lotusRoundsSetting: Int = 0
    
    //breathe focus
    @objc dynamic var breatheFTimePlayed: Double = 0.0
    @objc dynamic var breatheFBreathLength: Double = 0.0
    @objc dynamic var breatheFCorrectSets: Int = 0
    @objc dynamic var breatheFTotalSets: Int = 0
    @objc dynamic var breatheFTimeSettings: Int = 0
    @objc dynamic var breatheFCycleSettings: Int = 0
    
    //breathe infinite
    @objc dynamic var breatheITimePlayed: Double = 0.0
    @objc dynamic var breatheIBreathLength: Double = 0.0
    @objc dynamic var breatheITotalSets: Int = 0
    //@objc dynamic var breatheICycleDict: [String: Int] = [:]
    
     
    //@objc dynamic var id: Int = 0
    
    //    override static func primaryKey() -> String? {
    //        return "sessionTimestamp"
}

