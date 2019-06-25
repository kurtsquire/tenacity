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
    @objc dynamic var sessionTimeStamp: String = ""
    @objc dynamic var gameSettings: String = ""
    
    //@objc dynamic var id: Int = 0
    
    //    override static func primaryKey() -> String? {
    //        return "sessionTimestamp"
}
