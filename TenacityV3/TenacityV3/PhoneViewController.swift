//
//  PhoneViewController.swift
//  
//
//  Created by Richie on 8/14/19.
//

import UIKit
import Foundation
import RealmSwift
import WatchConnectivity



class PhoneViewController: UIViewController, WCSessionDelegate {
    
    var dailyQuest = Quest()
    var dailyQuestData : Dictionary<String, Any> = [:]
    var exp = 0
    
    override func viewDidLoad() { //opening app (only triggers when quitting and opening app again)
        super.viewDidLoad()
        
        if WCSession.isSupported(){
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        
        //testUserDefaults()
    }
    
    func saveEXP(addEXP : Int){
        exp += addEXP
        UserDefaults.standard.set(exp, forKey: "exp")
        //petArray[petEquipped].addExp(addExp)
    }
    
    func saveQuest(progress: Bool){
        if (progress){
            let report = dailyQuest.getProgress()
            for (counter, value) in report{
                dailyQuestData[counter] = value
            }
        }
        UserDefaults.standard.set(dailyQuestData, forKey: "dailyQuestData")
    }
    
    
    func saveToRealm(game : String = "phone", what : String, correct : String = "N/A"){
        let realm = try! Realm()
        let timestamp = NSDate().timeIntervalSince1970
        let date = Date()
        
        let gameDataModel = GameDataModel()
        gameDataModel.gameTitle = game
        gameDataModel.gameDataType = what
        gameDataModel.gameDataAccuracy = correct
        gameDataModel.sessionDate = date
        gameDataModel.sessionEpoch = timestamp
        
        do{
            try realm.write {
                realm.add(gameDataModel)
            }
        }catch{
            print("Error saving data to Realm \(error)")
        }
    }
        
    
//    func testUserDefaults(){
//        let defaults = UserDefaults.standard
//
//        let temp = defaults.dictionary(forKey: "allPetsData") ?? [:]
//        if !temp.isEmpty{
//            petArray.append(Pet(n: "Morgan", r: "common", ul: temp["Morgan"][2], xp: temp["Morgan"][1]))
//            petArray[0].changeForm(temp["Morgan"][0])
//            petArray.append(Pet(n: "Jade", r: "common", ul: temp["Jade"][2], xp: temp["Jade"][1]))
//            petArray[1].changeForm(temp["Jade"][0])
//        }
//        else{
//            petArray.append(Pet(n: "Morgan", r: "common", ul: true))
//            petArray.append(Pet(n: "Jade", r: "common", ul: true))
//        }
//    }
    
    
    // ----------------------------------- WATCH CONNECTIVITY -------------------------------
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        
        //Initialize Realm instance
        let realm = try! Realm()
        
        //Asks what value is in data
        if let game = userInfo["game"] as? String {
            let what = userInfo["what"] as! String
            let correct = userInfo["correct"] as! String
            let date = userInfo["date"] as! Date
            let time = userInfo["time"] as! Double
            
            //GameDataModel Realm Objects --> initialize new instances --> store data to save
            let gameDataModel = GameDataModel()
            gameDataModel.gameTitle = game
            gameDataModel.gameDataType = what
            gameDataModel.gameDataAccuracy = correct
            gameDataModel.sessionDate = date
            gameDataModel.sessionEpoch = time
            
            if (game == "lotus"){
                let lotusRoundsPlayed = userInfo["lotusRoundsPlayed"] as? Int ?? 0
                let lotusSettings = userInfo["roundSettings"] as? Int ?? 0 //new
                let lotusTimePlayed = userInfo["timePlayed"] as? Double ?? 0
                let lotusMissArray = userInfo["missArray"] as? [Int] ?? []
                
                
                gameDataModel.lotusRoundsPlayed = lotusRoundsPlayed
                gameDataModel.lotusRoundsSetting = lotusSettings //new
                gameDataModel.lotusTimePlayed = lotusTimePlayed
                
                gameDataModel.lotusCorrectList.append(objectsIn: lotusMissArray)
                
                saveEXP(addEXP: Int(5*lotusRoundsPlayed))
                
                let qdata = ["game": game, "timeEnd": date, "timePlayed": Int(lotusTimePlayed), "rounds": lotusRoundsPlayed, "correct": lotusMissArray[0]] as [String : Any]
                
                if !dailyQuestData.isEmpty && !(dailyQuestData["complete"] as! Bool){
                    if dailyQuest.checkQuest(data: qdata){
                        dailyQuestData["complete"] = true
                        saveEXP(addEXP: (dailyQuestData["exp"] as! Int))
                        //give reward
                        
                    }
                }
                saveQuest(progress: true)
                
            }
            else if (game == "breathe focus"){
                let breatheFTimePlayed = userInfo["breatheFTimePlayed"] as? Double ?? 0.0
                let breatheFBreathLength = userInfo["breatheFBreathLength"] as? Double ?? 0.0
                let breatheFCorrectSets = userInfo["breatheFCorrectSets"] as? Int ?? 0
                let breatheFTotalSets = userInfo["breatheFTotalSets"] as? Int ?? 0
                
                let breatheFCycleSettings = userInfo["breatheFCycleSettings"] as? Int ?? 0 //new
                let breatheFTimeSettings = userInfo["breatheFTimeSettings"] as? Int ?? 0 //new
                
                gameDataModel.breatheFTimePlayed = breatheFTimePlayed
                gameDataModel.breatheFBreathLength = breatheFBreathLength
                gameDataModel.breatheFCorrectSets = breatheFCorrectSets
                gameDataModel.breatheFTotalSets = breatheFTotalSets
                
                gameDataModel.breatheFCycleSettings = breatheFCycleSettings //new
                gameDataModel.breatheFTimeSettings = breatheFTimeSettings //new
                
                saveEXP(addEXP: Int(breatheFTimePlayed))
                
                let qdata = ["game": game, "timeEnd": date, "timePlayed": Int(breatheFTimePlayed), "correct": breatheFCorrectSets, "total": breatheFTotalSets, "cycle": breatheFCycleSettings] as [String : Any]
                
                if !dailyQuestData.isEmpty && !(dailyQuestData["complete"] as! Bool){
                    if dailyQuest.checkQuest(data: qdata){
                        dailyQuestData["complete"] = true
                        saveEXP(addEXP: (dailyQuestData["exp"] as! Int))
                        //give reward

                    }
                }
                saveQuest(progress: true)
                
            }
            else if (game == "breathe infinite"){
                let breatheITimePlayed = userInfo["breatheITimePlayed"] as? Double ?? 0.0
                let breatheIBreathLength = userInfo["breatheIBreathLength"] as? Double ?? 0.0
                let breatheITotalSets = userInfo["breatheITotalSets"] as? Int ?? 0
                let breatheICycleDict = userInfo["breatheICycleDict"] as? [String : Any] ?? [:]
                
                var templist = [0,0,0,0,0,0,0,0,0,0,0]
                if !(breatheICycleDict.count == 0){
                    for (key,value) in breatheICycleDict{
                        if (Int(key)! >= 10){
                            templist[10] += value as! Int
                        }
                        else{
                            templist[Int(key)!] = value as! Int
                        }
                    }
                }
                
                gameDataModel.breatheITimePlayed = breatheITimePlayed
                gameDataModel.breatheIBreathLength = breatheIBreathLength
                gameDataModel.breatheITotalSets = breatheITotalSets
                gameDataModel.breatheICycleList.append(objectsIn: templist)
                
                
                saveEXP(addEXP: Int(breatheITimePlayed))
                
                let qdata = ["game": game, "timeEnd": date, "timePlayed": Int(breatheITimePlayed), "cycle": breatheICycleDict] as [String : Any]
                
                if !dailyQuestData.isEmpty && !(dailyQuestData["complete"] as! Bool){
                    if dailyQuest.checkQuest(data: qdata){
                        dailyQuestData["complete"] = true
                        saveEXP(addEXP: (dailyQuestData["exp"] as! Int))
                        //give reward
                    }
                }
                saveQuest(progress: true)
            }
            
            //Write to Realm
            
            do{
                try realm.write {
                    realm.add(gameDataModel)
                }
            }catch{
                print("Error saving data to Realm \(error)")
            }
            
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        DispatchQueue.main.async{
            if activationState == .activated {
                if session.isWatchAppInstalled{
                }
            }
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        //WCSession.default().activate()   for multiple watches
    }
}
