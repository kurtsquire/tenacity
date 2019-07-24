//
//  ViewController.swift
//  TenacityV3
//
//  Created by PLL on 5/20/19.
//  Copyright © 2019 PLL. All rights reserved.
//

import UIKit
import WatchConnectivity
import RealmSwift
import Firebase

class ViewController: UIViewController, WCSessionDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var addNameButton: UIButton!
    @IBOutlet weak var addNameItem: UIBarButtonItem!
    
    @IBOutlet weak var addNameTextField: UITextField!
    @IBOutlet weak var textFieldLabel: UILabel!
    @IBOutlet weak var saveItem: UIBarButtonItem!
    
    
    var data = [String]()
    var name = "N/A"
    
    var exp = 0
    var savePath = ViewController.getDocumentsDirectory().appendingPathComponent("data").path
    
    var calendar = Calendar.autoupdatingCurrent
    
    var today = Date()
    var startTime = Date()
    var weekStartTime = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //connecting to wc
        if WCSession.isSupported(){
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        
        // loads data from file
        data = NSKeyedUnarchiver.unarchiveObject(withFile: savePath) as? [String] ?? [String]()
        
        // loads "Name" from UserDefaults
        testUserDefaults()
        
        
        // sets label for name
        updateName()
        // changes Add Name Item to unpressable
        if (name != "N/A"){
            addNameItem.isEnabled = false
        }
        else{
            addNameItem.isEnabled = true
        }
        showRecent()
        
        // updates date for today
        today = Date()
        print(today.timeIntervalSince1970)
        startTime = calendar.startOfDay(for: today)
        
        //creates a date at the beginning of the week to compare
        let weekComponents = calendar.dateComponents([.month, .yearForWeekOfYear, .weekOfYear], from: today)
        weekStartTime = calendar.date(from: weekComponents)!

        //var quests = BreatheFocusQuest(qs: "im quest", ts: Date(), te: Date(), exp: 5, r: "reward", obj: 5, gn: 1, gt: 2)
        //print(quests.check())
        
        // testing stuff delete this crap after
        
        //let calendar = Calendar.autoupdatingCurrent
        //let today = Date()

        //let c = Date(timeIntervalSince1970: 30.0)
        //let nextMonth = calendar.date(byAdding: .month, value: 1, to: today)
        //let tomorrow = calendar.date(byAdding: .day, value: -5, to: today)
        //print("++++++    TESTING DATES    +++++++++++++++++++++")
        //print(calendar.isDateInToday(c))
        //print(calendar.isDateInToday(today))
        //print(calendar.isDateInToday(tomorrow!))
        //print(calendar.isDateInToday(nextMonth!))
        //print(calendar.isDateInTomorrow(tomorrow!))
        //print(calendar.isDate(today, inSameDayAs: tomorrow!))
        //print(calendar.isDate(today, equalTo: tomorrow!, toGranularity: .weekOfYear))
        //print(calendar.isDate(today, equalTo: c, toGranularity: .weekOfYear))

        
        

    }
    
    func showRecent(){
        self.textView.text = ""
        
        if (self.data.count > 10){
            let arraySlice = data.suffix(10)
            let newArray = Array(arraySlice)
            for element in newArray{
                self.textView.text += element
            }
        }
        else{
            for element in self.data{
                self.textView.text += element
            }
        }
    }
    
    func updateName(){
        nameLabel.text = "Name: " + name
    }
    
    // refresh button action
    @IBAction func refreshButton(_ sender: Any) {
        //showRecent()
        refreshRealmData()
    }
    
    @IBAction func addNameButtonPressed(_ sender: Any) {
        addNameTextField.isHidden = false
        textFieldLabel.isHidden = false
        
        saveItem.isEnabled = true
        addNameItem.isEnabled = false
    }
    
    @IBAction func savePressed(_ sender: Any) {
        if self.addNameTextField.text == ""{
            return
        }
        
        self.name = self.addNameTextField.text ?? "N/A"
        UserDefaults.standard.set(name, forKey: "shared_default")
        
        addNameTextField.isHidden = true
        textFieldLabel.isHidden = true
        saveItem.isEnabled = false
        
        //nameLabel.text = "Name: " + name
        updateName()
        
        
        self.view.endEditing(true)
        // saves name to data
        self.data.append((self.name + ":::\n"))
        NSKeyedArchiver.archiveRootObject(self.data, toFile: self.savePath)
    }
    
    func saveEXP(addEXP : Int){
        exp += addEXP
        UserDefaults.standard.set(exp, forKey: "exp")
    }
    
    //    //handles data we get from watch
    //    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
    //        DispatchQueue.main.async{
    //
    //            var displayText = ""
    //            var time = ""
    //            var what = ""
    //            var correct = ""
    //            var settings = ""
    //            //asks what value is in data
    //            if let game = userInfo["game"] as? String {
    //                if let text1 = userInfo["what"] as? String {
    //                    what = text1
    //                }
    //                if let text2 = userInfo["correct"] as? String {
    //                    correct = text2
    //                }
    //                if let text3 = userInfo["time"] as? String {
    //                    time = text3
    //                }
    //                if let text4 = userInfo["settings"] as? String {
    //                    settings = text4
    //                }
    //                displayText = (game + "\n" + what + "\n" + correct + "\n" + time + "\n" + settings + ";;;\n")
    //
    //                self.data.append(displayText)
    //
    //                NSKeyedArchiver.archiveRootObject(self.data, toFile: self.savePath)
    //            }
    //
    //            else{
    //                self.textView.text += "got something but cant read it"
    //            }
    //
    //        }
    //    }
    
    
    //function to recieve user info --> also used to store received data into realm
    //NOTE TO SELF: edit code--> function has to many things going on here edit code to make it simple and modular
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        
        //Initialize Realm instance
        let realm = try! Realm()
        
        //recieve user info
        //Unpack dictionary data into temp variables
        //var time: Double
        //var date: Date
        //var what = ""
        //var correct = ""
        //var settings = ""
        
        //Asks what value is in data
        if let game = userInfo["game"] as? String {
            let what = userInfo["what"] as! String
            let correct = userInfo["correct"] as! String
            let date = userInfo["date"] as! Date
            let time = userInfo["time"] as! Double
            //let settings = userInfo["settings"] as! String
            
            //GameDataModel Realm Objects --> initialize new instances --> store data to save
            let gameDataModel = GameDataModel()
            gameDataModel.gameTitle = game
            gameDataModel.gameDataType = what
            gameDataModel.gameDataAccuracy = correct
            gameDataModel.sessionDate = date
            gameDataModel.sessionEpoch = time
            //gameDataModel.gameSettings = settings
            
            
            if (game == "lotus"){
                let lotusRoundsPlayed = userInfo["lotusRoundsPlayed"] as? Int ?? 0
                let lotusSettings = userInfo["roundSettings"] as? Int ?? 0 //new
                
                gameDataModel.lotusRoundsPlayed = lotusRoundsPlayed
                gameDataModel.lotusRoundsSetting = lotusSettings //new
                
                saveEXP(addEXP: Int(5*lotusRoundsPlayed))
                
                // check that game played matches quest type (if lotus elif playall else)
                // if dailyDone (new var not made yet) != true then checkquest
                // if check quest returns true
                // give rewards, set dailyDone true, etc

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
                
                // check that game played matches quest type (if breathe elif playall else)
                // if dailyDone (new var not made yet) != true then checkquest
                // if check quest returns true
                // give rewards, set dailyDone true, etc
                
            }
            else if (game == "breathe infinite"){
                let breatheITimePlayed = userInfo["breatheITimePlayed"] as? Double ?? 0.0
                let breatheIBreathLength = userInfo["breatheIBreathLength"] as? Double ?? 0.0
                let breatheITotalSets = userInfo["breatheITotalSets"] as? Int ?? 0
                
                gameDataModel.breatheITimePlayed = breatheITimePlayed
                gameDataModel.breatheIBreathLength = breatheIBreathLength
                gameDataModel.breatheITotalSets = breatheITotalSets
                
                saveEXP(addEXP: Int(breatheITimePlayed))
                
                // check that game played matches quest type (if free breathe elif playall else)
                // if dailyDone (new var not made yet) != true then checkquest
                // if check quest returns true
                // give rewards, set dailyDone true, etc
                
            }
            
            //Write to Realm
            
            //RealmManager.writeObject(gameDataModel)
            
            do{
                try realm.write {
                    realm.add(gameDataModel)
                }
            }catch{
                print("Error saving data to Realm \(error)")
            }
            
        }
        
//        // firebase connection
//        let db = Database.database().reference()
//
//        db.setValue(what)
        
        
    }
    
    //shows UI inforation we want to show (daily & weekly stats)
    func refreshRealmData(){
        let realm = try! Realm()
        
        let gamename1 = "breathe focus"
        let gamename2 = "breathe infinite"
        let gamename3 = "lotus"
        
        
        let all = realm.objects(GameDataModel.self)
        
        //breathe
        let ba = realm.objects(GameDataModel.self).filter("gameTitle = %@", gamename1)
        //let bw = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@ AND gameDataType == %@", gamename1, weekStartTime, "end game")
        let bw = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@", gamename1, weekStartTime)
        let bx = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@", gamename1, startTime)
        
        //free breathe
        let fba = realm.objects(GameDataModel.self).filter("gameTitle = %@", gamename2)
        let fbw = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@", gamename2, weekStartTime)
        let fbx = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@", gamename2, startTime)
        
        //lotus
        let la = realm.objects(GameDataModel.self).filter("gameTitle = %@", gamename3)
        let lw = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@", gamename3, weekStartTime)
        let lx = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@", gamename3, startTime)
        
        
        var lotusRoundsToday = 0
        var lotusRoundsWeek = 0
        
        //calculating lotus rounds today
        for item in lx{
            lotusRoundsToday += item.lotusRoundsPlayed
        }
        //calculating lotus rounds this week
        for item in lw{
            lotusRoundsWeek += item.lotusRoundsPlayed
        }
        
        
        //breathe stats today
        var breatheFBreathsToday = 0
        var breatheFTimeToday = 0.0
        var breatheFCorrectToday = 0
        var breatheFTotalToday = 0
        
        var flengthtotalt = 0.0
        var fsessionst = 0
        for item in bx{
            breatheFTimeToday += item.breatheFTimePlayed
            
            flengthtotalt += item.breatheFBreathLength
            if item.breatheFBreathLength > 0{
                fsessionst += 1
            }
            if item.gameDataType == "stop hold"{
                breatheFBreathsToday += 1
            }
            breatheFCorrectToday += item.breatheFCorrectSets
            breatheFTotalToday += item.breatheFTotalSets
        }
        let breatheFAvgToday = flengthtotalt/Double(fsessionst)
        
        
        //breathe stats week
        var breatheFBreathsWeek = 0
        var breatheFTimeWeek = 0.0
        var breatheFCorrectWeek = 0
        var breatheFTotalWeek = 0
        
        var flengthtotalw = 0.0
        var fsessionsw = 0
        
        for item in bw{
            breatheFTimeWeek += item.breatheFTimePlayed
            flengthtotalw += item.breatheFBreathLength
            if item.breatheFBreathLength > 0{
                fsessionsw += 1
            }
            if item.gameDataType == "stop hold"{
                breatheFBreathsWeek += 1
            }
            breatheFCorrectWeek += item.breatheFCorrectSets
            breatheFTotalWeek += item.breatheFTotalSets
        }
        let breatheFAvgWeek = flengthtotalw/Double(fsessionsw)
        
        
        
        //breathe Infinite stats today
        var breatheIBreathsToday = 0
        var breatheITimeToday = 0.0
        var breatheITotalToday = 0
        
        var ilengthtotalt = 0.0
        var isessionst = 0
        
        for item in fbx{
            breatheITimeToday += item.breatheITimePlayed
            ilengthtotalt += item.breatheIBreathLength
            if item.breatheIBreathLength > 0{
                isessionst += 1
            }
            if item.gameDataType == "stop hold"{
                breatheIBreathsToday += 1
            }
            breatheITotalToday += item.breatheITotalSets
        }
        let breatheIAvgToday = ilengthtotalt/Double(isessionst)
        
        
        //breathe Infinite stats week
        var breatheIBreathsWeek = 0
        var breatheITimeWeek = 0.0
        var breatheITotalWeek = 0
        
        var ilengthtotalw = 0.0
        var isessionsw = 0
        for item in fbw{
            breatheITimeWeek += item.breatheITimePlayed
            
            ilengthtotalw += item.breatheIBreathLength
            if item.breatheIBreathLength > 0{
                isessionsw += 1
            }
            if item.gameDataType == "stop hold"{
                breatheIBreathsWeek += 1
            }
            breatheITotalWeek += item.breatheITotalSets
        }
        let breatheIAvgWeek = ilengthtotalw/Double(isessionsw)
        
        
        // Temporarily display everything in 1 big textview
        var y = "everything: " + String(all.count) + "\n"
        let lstring = "\nLotus: " + String(la.count) + "\nWeek:\nRounds: " + String(lotusRoundsWeek) + "\nToday: \nRounds: " + String(lotusRoundsToday)
        let bfstring = "\nBreathe Focus: " + String(ba.count) + "\nWeek:\nTime Played: " + String(breatheFTimeWeek) + "\nTotal Breaths Taken: " + String(breatheFBreathsWeek) + "\nAvg Breath Length: " + String(breatheFAvgWeek) + "\nCorrect Sets: " + String(breatheFCorrectWeek) + "\nTotal Sets: " + String(breatheFTotalWeek) + "\nToday: \nTime Played: " + String(breatheFTimeToday) + "\nTotal Breaths Taken: " + String(breatheFBreathsToday) +  "\nAvg Breath Length: " + String(breatheFAvgToday) + "\nCorrect Sets: " + String(breatheFCorrectToday) + "\nTotal Sets: " + String(breatheFTotalToday)
        let bistring = "\nBreathe Infinite: " + String(fba.count) + "\nWeek:\nTime Played: " + String(breatheITimeWeek) + "\nTotal Breaths Taken: " + String(breatheIBreathsWeek) +  "\nAvg Breath Length: " + String(breatheIAvgWeek) + "\nTotal Sets: " + String(breatheITotalWeek) + "\nToday: \nTime Played: " + String(breatheITimeToday) + "\nTotal Breaths Taken: " + String(breatheIBreathsToday) +  "\nAvg Breath Length: " + String(breatheIAvgToday) + "\nTotal Sets: " + String(breatheITotalToday)
        y += lstring + "\n" + bfstring + "\n" + bistring
        
        
        
        
//        for i in lx{
//            y += i.gameTitle + ", " + i.gameDataType + ", " + i.gameDataAccuracy + ", "
//            y += String(i.sessionEpoch) + ", " + i.gameSettings + ", " + String(i.lotusRoundsPlayed) + "\n"
//        }
        
        
        
        DispatchQueue.main.async {
            self.textView.text = y
        }
    }
    
    
 //////////////////////////////////////////////////////////
    
    func testUserDefaults(){
        let defaults = UserDefaults.standard
        
        if let contents = defaults.string(forKey: "shared_default"){
            if contents != "N/A"{
                name = contents
            }
        }
        exp = defaults.integer(forKey: "exp")
        print(exp)
    }
    
    @IBAction func trashPressed(_ sender: Any) {
        data = [String]()
        name = "N/A"
        exp = 0
        UserDefaults.standard.set(exp, forKey: "exp")
        UserDefaults.standard.set(name, forKey: "shared_default")
        NSKeyedArchiver.archiveRootObject(self.data, toFile: self.savePath)
        
        updateName()
        showRecent()
        
        // deletes realm
        deleteRealm()
    }
    
    
    func deleteRealm(){
        let realm = try! Realm()
        //RealmManager.deleteDatabase()
        let x = realm.objects(GameDataModel.self)
        try! realm.write {
            realm.delete(x)
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    /// Save to File //////////////
    
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
    //// WatchConnectivity Stuff  ////////////////////////////
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        DispatchQueue.main.async{
            if activationState == .activated {
                
                if session.isWatchAppInstalled{
                    //self.receivedDataTextView.text = "watch app is installed and is connected!"
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

