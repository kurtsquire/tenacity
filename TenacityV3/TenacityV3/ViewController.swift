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

// not used anymore just debug screen
class ViewController: UIViewController, WCSessionDelegate {
    
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var addNameItem: UIBarButtonItem!
    
    @IBOutlet weak var addNameTextField: UITextField!
    @IBOutlet weak var textFieldLabel: UILabel!
    @IBOutlet weak var saveItem: UIBarButtonItem!
    
    
    var data = [String]()
    var name = "N/A"
    
    var exp = 0
    var dailyQuest = Quest()
    var rerolls = 0
    var dailyQuestData : Dictionary<String, Any> = [:]
    var savePath = ViewController.getDocumentsDirectory().appendingPathComponent("data").path
    
    var calendar = Calendar.autoupdatingCurrent
    
    var today = Date()
    var startTime = Date()
    var weekStartTime = Date()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // takes out top bar
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

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
    
    func saveQuest(){
        let report = dailyQuest.getProgress()
        for (counter, value) in report{
            dailyQuestData[counter] = value
        }
        UserDefaults.standard.set(dailyQuestData, forKey: "dailyQuestData")
    }
    
    func buildQuest(){
        if ((dailyQuestData["questType"] as! String) == "breathe focus"){
            dailyQuest = BreatheFocusQuest(qs: (dailyQuestData["questString"] as! String), ts: (dailyQuestData["timeStart"] as! Date), te: (dailyQuestData["timeEnd"] as! Date), exp: (dailyQuestData["exp"] as! Int), r: (dailyQuestData["reward"] as! Int), obj: (dailyQuestData["obj"] as! Int), gn: (dailyQuestData["goalNum"] as! Int), gt: (dailyQuestData["goalTime"] as! Int), ct: (dailyQuestData["count"] as! Int))
        }
        else if ((dailyQuestData["questType"] as! String) == "breathe infinite"){
            dailyQuest = BreatheInfiniteQuest(qs: (dailyQuestData["questString"] as! String), ts: (dailyQuestData["timeStart"] as! Date), te: (dailyQuestData["timeEnd"] as! Date), exp: (dailyQuestData["exp"] as! Int), r: (dailyQuestData["reward"] as! Int), gc: (dailyQuestData["goalCount"] as! Int), gn: (dailyQuestData["goalNum"] as! Int), gt: (dailyQuestData["goalTime"] as! Int))
        }
        else if ((dailyQuestData["questType"] as! String) == "lotus"){
            dailyQuest = LotusQuest(qs: (dailyQuestData["questString"] as! String), ts: (dailyQuestData["timeStart"] as! Date), te: (dailyQuestData["timeEnd"] as! Date), exp: (dailyQuestData["exp"] as! Int), r: (dailyQuestData["reward"] as! Int), obj: (dailyQuestData["obj"] as! Int), gn: (dailyQuestData["goalNum"] as! Int), ct: (dailyQuestData["count"] as! Int))
        }
        else if ((dailyQuestData["questType"] as! String) == "play all"){
            dailyQuest = PlayAllQuest(qs: (dailyQuestData["questString"] as! String), ts: (dailyQuestData["timeStart"] as! Date), te: (dailyQuestData["timeEnd"] as! Date), exp: (dailyQuestData["exp"] as! Int), r: (dailyQuestData["reward"] as! Int), g: (dailyQuestData["goalNum"] as! Int), bfp: (dailyQuestData["bfPlayed"] as! Int), bip: (dailyQuestData["biPlayed"] as! Int), lp: (dailyQuestData["lPlayed"] as! Int))
        }
    }
    
    func generateQuest(){
        let num = Int.random(in: 1 ... 100)
        if (num <= 60){//Breathe Focus Quests
            let num2 = Int.random(in: 1 ... 4)
            if (num2 == 1){//BF: Spend x minutes at rate y
                let x = Int.random(in: 5 ... 15)
                let y = Int.random(in: 3 ... 8)
                dailyQuestData["questType"] = "breathe focus"
                dailyQuestData["questString"] = "Play for " + String(x) + " minutes with rate set to " + String(y) + "."
                dailyQuestData["timeStart"] = startTime
                dailyQuestData["timeEnd"] = calendar.date(byAdding: .day, value: 1, to: startTime)
                dailyQuestData["reward"] = "Progress!"
                dailyQuestData["complete"] = false
                dailyQuestData["exp"] = 10*x*y
                dailyQuestData["obj"] = 0
                dailyQuestData["goalNum"] = y
                dailyQuestData["goalTime"] = x*60
                dailyQuestData["count"] = 0
                saveQuest()
                buildQuest()
            }
            else if (num2 == 2){//BF: Spend x time playing
                let x = Int.random(in: 10 ... 30)
                dailyQuestData["questType"] = "breathe focus"
                dailyQuestData["questString"] = "Play for " + String(x) + " minutes."
                dailyQuestData["timeStart"] = startTime
                dailyQuestData["timeEnd"] = calendar.date(byAdding: .day, value: 1, to: startTime)
                dailyQuestData["reward"] = "Progress!"
                dailyQuestData["complete"] = false
                dailyQuestData["exp"] = 10*x
                dailyQuestData["obj"] = 1
                dailyQuestData["goalTime"] = x*60
                dailyQuestData["count"] = 0
                saveQuest()
                buildQuest()
            }
            else if (num2 == 3){//BF: Play x games that last at least y minutes
                let x = Int.random(in: 2 ... 5)
                let y = Int.random(in: 3 ... 6)
                dailyQuestData["questType"] = "breathe focus"
                dailyQuestData["questString"] = "Play " + String(x) + " games that last at least " + String(y) + " minutes."
                dailyQuestData["timeStart"] = startTime
                dailyQuestData["timeEnd"] = calendar.date(byAdding: .day, value: 1, to: startTime)
                dailyQuestData["reward"] = "Progress!"
                dailyQuestData["complete"] = false
                dailyQuestData["exp"] = 10*x*y
                dailyQuestData["obj"] = 2
                dailyQuestData["goalNum"] = x
                dailyQuestData["goalTime"] = y*60
                dailyQuestData["count"] = 0
                saveQuest()
                buildQuest()
            }
            else if (num2 == 4){//BF: Play a game that lasts x minutes without failing a cycle
                let x = Int.random(in: 3 ... 8)
                dailyQuestData["questType"] = "breathe focus"
                dailyQuestData["questString"] = "Play a game that lasts " + String(x) + " minutes without failing a cycle."
                dailyQuestData["timeStart"] = startTime
                dailyQuestData["timeEnd"] = calendar.date(byAdding: .day, value: 1, to: startTime)
                dailyQuestData["reward"] = "Progress!"
                dailyQuestData["complete"] = false
                dailyQuestData["exp"] = 20*x
                dailyQuestData["obj"] = 3
                dailyQuestData["goalTime"] = x*60
                saveQuest()
                buildQuest()
            }
        }
        else if (num <= 75){//BI: Play for x minutes and complete y cycles of rate z
            let x = Int.random(in: 5 ... 15)
            let y = Int.random(in: 3 ... 10)
            let z = Int.random(in: 3 ... 8)
            dailyQuestData["questType"] = "breathe infinite"
            dailyQuestData["questString"] = "Play a " + String(x) + "-minute session and complete " + String(y) + " cycles at rate " + String(z) + "."
            dailyQuestData["timeStart"] = startTime
            dailyQuestData["timeEnd"] = calendar.date(byAdding: .day, value: 1, to: startTime)
            dailyQuestData["reward"] = "Progress!"
            dailyQuestData["complete"] = false
            dailyQuestData["exp"] = 10*x*y*z
            dailyQuestData["goalTime"] = x*60
            dailyQuestData["goalNum"] = y
            dailyQuestData["goalCycle"] = z
            saveQuest()
            buildQuest()
        }
        else if (num <= 90){
            let num2 = Int.random(in: 1 ... 3)
            if (num2 == 1){//L: Play x rounds
                var x = Int.random(in: 4 ... 8)
                x *= 5
                dailyQuestData["questType"] = "lotus"
                dailyQuestData["questString"] = "Play " + String(x) + " rounds."
                dailyQuestData["timeStart"] = startTime
                dailyQuestData["timeEnd"] = calendar.date(byAdding: .day, value: 1, to: startTime)
                dailyQuestData["reward"] = "Progress!"
                dailyQuestData["complete"] = false
                dailyQuestData["exp"] = 10*x
                dailyQuestData["obj"] = 0
                dailyQuestData["goalNum"] = x
                dailyQuestData["count"] = 0
                saveQuest()
                buildQuest()
            }
            else if (num2 == 2){//L: Play a game of x rounds without missing
                var x = Int.random(in: 2 ... 6)
                x *= 5
                dailyQuestData["questType"] = "lotus"
                dailyQuestData["questString"] = "Play a game with " + String(x) + " rounds without missing."
                dailyQuestData["timeStart"] = startTime
                dailyQuestData["timeEnd"] = calendar.date(byAdding: .day, value: 1, to: startTime)
                dailyQuestData["reward"] = "Progress!"
                dailyQuestData["complete"] = false
                dailyQuestData["exp"] = 15*x
                dailyQuestData["obj"] = 1
                dailyQuestData["goalNum"] = x
                dailyQuestData["count"] = 0
                saveQuest()
                buildQuest()
            }
            else if (num2 == 3){//L: Play x games
                let x = Int.random(in: 2 ... 5)
                dailyQuestData["questType"] = "lotus"
                dailyQuestData["questString"] = "Play " + String(x) + " games."
                dailyQuestData["timeStart"] = startTime
                dailyQuestData["timeEnd"] = calendar.date(byAdding: .day, value: 1, to: startTime)
                dailyQuestData["reward"] = "Progress!"
                dailyQuestData["complete"] = false
                dailyQuestData["exp"] = 20*x
                dailyQuestData["obj"] = 0
                dailyQuestData["goalNum"] = x
                dailyQuestData["count"] = 0
                saveQuest()
                buildQuest()
            }
        }
        else{//PA: Play each game for x minutes
            let x = Int.random(in: 2 ... 5)
            dailyQuestData["questType"] = "play all"
            dailyQuestData["questString"] = "Play each game for " + String(x) + " minutes."
            dailyQuestData["timeStart"] = startTime
            dailyQuestData["timeEnd"] = calendar.date(byAdding: .day, value: 1, to: startTime)
            dailyQuestData["reward"] = "Progress!"
            dailyQuestData["complete"] = false
            dailyQuestData["exp"] = 40*x
            dailyQuestData["goal"] = x
            dailyQuestData["bfPlayed"] = 0
            dailyQuestData["biPlayed"] = 0
            dailyQuestData["lPlayed"] = 0
            saveQuest()
            buildQuest()
        }
    }
    
    //    //handles data we get from watch

    //function to recieve user info --> also used to store received data into realm
    //NOTE TO SELF: edit code--> function has to many things going on here edit code to make it simple and modular
//    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
//
//        //Initialize Realm instance
//        let realm = try! Realm()
//
//        //Asks what value is in data
//        if let game = userInfo["game"] as? String {
//            let what = userInfo["what"] as! String
//            let correct = userInfo["correct"] as! String
//            let date = userInfo["date"] as! Date
//            let time = userInfo["time"] as! Double
//            //let settings = userInfo["settings"] as! String
//
//            //GameDataModel Realm Objects --> initialize new instances --> store data to save
//            let gameDataModel = GameDataModel()
//            gameDataModel.gameTitle = game
//            gameDataModel.gameDataType = what
//            gameDataModel.gameDataAccuracy = correct
//            gameDataModel.sessionDate = date
//            gameDataModel.sessionEpoch = time
//
//            if (game == "lotus"){
//                let lotusRoundsPlayed = userInfo["lotusRoundsPlayed"] as? Int ?? 0
//                let lotusSettings = userInfo["roundSettings"] as? Int ?? 0 //new
//                let lotusTimePlayed = userInfo["timePlayed"] as? Double ?? 0
//                let lotusMissArray = userInfo["missArray"] as? [Int] ?? []
//
//                print(lotusRoundsPlayed)
//                print(lotusSettings)
//                print(lotusTimePlayed)
//                print(lotusMissArray[0])
//
//                gameDataModel.lotusRoundsPlayed = lotusRoundsPlayed
//                gameDataModel.lotusRoundsSetting = lotusSettings //new
//                gameDataModel.lotusTimePlayed = lotusTimePlayed
//
//                gameDataModel.lotusCorrectList.append(objectsIn: lotusMissArray)
//                print(gameDataModel.lotusRoundsPlayed)
//                print(gameDataModel.lotusRoundsSetting)
//                print(gameDataModel.lotusTimePlayed)
//                print(gameDataModel.lotusCorrectList)
//
//                saveEXP(addEXP: Int(5*lotusRoundsPlayed))
//
//                // dictionary needs: game(String), timeEnd(Date), rounds(Int), accuracy(Double)
//                // if dailyDone (new var not made yet) != true then checkquest
//                // if check quest returns true
//                // give rewards, set dailyDone true, etc
//
//                //if !(dailyQuestData["complete"] as! Bool){
//                //    dailyQuestData["complete"] = dailyQuest.checkQuest(data: qdata)
//                //}
//                saveQuest()
//
//            }
//            else if (game == "breathe focus"){
//                let breatheFTimePlayed = userInfo["breatheFTimePlayed"] as? Double ?? 0.0
//                let breatheFBreathLength = userInfo["breatheFBreathLength"] as? Double ?? 0.0
//                let breatheFCorrectSets = userInfo["breatheFCorrectSets"] as? Int ?? 0
//                let breatheFTotalSets = userInfo["breatheFTotalSets"] as? Int ?? 0
//
//                let breatheFCycleSettings = userInfo["breatheFCycleSettings"] as? Int ?? 0 //new
//                let breatheFTimeSettings = userInfo["breatheFTimeSettings"] as? Int ?? 0 //new
//
//                gameDataModel.breatheFTimePlayed = breatheFTimePlayed
//                gameDataModel.breatheFBreathLength = breatheFBreathLength
//                gameDataModel.breatheFCorrectSets = breatheFCorrectSets
//                gameDataModel.breatheFTotalSets = breatheFTotalSets
//
//                gameDataModel.breatheFCycleSettings = breatheFCycleSettings //new
//                gameDataModel.breatheFTimeSettings = breatheFTimeSettings //new
//
//                saveEXP(addEXP: Int(breatheFTimePlayed))
//
//                // dictionary needs: game(String), timeEnd(Date), cycle(Int), timePlayed(Int), correct(Int), total(Int)
//                // if dailyDone (new var not made yet) != true then checkquest
//                // if check quest returns true
//                // give rewards, set dailyDone true, etc
//
//                let qdata = ["game": game, "timeEnd": date, "timePlayed": Int(breatheFTimePlayed), "correct": breatheFCorrectSets, "total": breatheFTotalSets, "cycle": breatheFCycleSettings] as [String : Any]
//
//                if !dailyQuestData.isEmpty && !(dailyQuestData["complete"] as! Bool){
//                    if dailyQuest.checkQuest(data: qdata){
//                        dailyQuestData["complete"] = true
//                        saveEXP(addEXP: (dailyQuestData["exp"] as! Int))
//                        //give reward
//                    }
//                }
//                saveQuest()
//
//            }
//            else if (game == "breathe infinite"){
//                let breatheITimePlayed = userInfo["breatheITimePlayed"] as? Double ?? 0.0
//                let breatheIBreathLength = userInfo["breatheIBreathLength"] as? Double ?? 0.0
//                let breatheITotalSets = userInfo["breatheITotalSets"] as? Int ?? 0
//                let breatheICycleDict = userInfo["breatheICycleDict"] as? [String : Any] ?? [:]
//
//                var templist = [0,0,0,0,0,0,0,0,0,0,0]
//                if !(breatheICycleDict.count == 0){
//                    for (key,value) in breatheICycleDict{
//                        if (Int(key)! >= 10){
//                            templist[10] += value as! Int
//                        }
//                        else{
//                            templist[Int(key)!] = value as! Int
//                        }
//                    }
//                }
//                print(templist)
//
//                gameDataModel.breatheITimePlayed = breatheITimePlayed
//                gameDataModel.breatheIBreathLength = breatheIBreathLength
//                gameDataModel.breatheITotalSets = breatheITotalSets
//                gameDataModel.breatheICycleList.append(objectsIn: templist)
//                //print(gameDataModel.breatheICycleList)
//
//                saveEXP(addEXP: Int(breatheITimePlayed))
//
//                // dictionary needs: game(String), timeEnd(Date), timePlayed(Int), cycle(Dictionary<String,Int>)
//                // if dailyDone (new var not made yet) != true then checkquest
//                // if check quest returns true
//                // give rewards, set dailyDone true, etc
//                saveQuest()
//
//            }
//
//            //Write to Realm
//
//            //RealmManager.writeObject(gameDataModel)
//
//            do{
//                try realm.write {
//                    realm.add(gameDataModel)
//                }
//            }catch{
//                print("Error saving data to Realm \(error)")
//            }
//
//        }
//
////        // firebase connection
////        let db = Database.database().reference()
////
////        db.setValue(what)
//
//
//    }
    
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
        var lotusTimePlayedToday = 0.0
        var lotusCorrectToday = [0,0,0,0]
        var lotusRoundsWeek = 0
        var lotusTimePlayedWeek = 0.0
        var lotusCorrectWeek = [0,0,0,0]
        
        //calculating lotus rounds today
        for item in lx{
            lotusRoundsToday += item.lotusRoundsPlayed
            lotusTimePlayedToday += item.lotusTimePlayed
            for i in 0..<item.lotusCorrectList.count{
                lotusCorrectToday[i] += item.lotusCorrectList[i]
            }
        }
        //calculating lotus rounds this week
        for item in lw{
            lotusRoundsWeek += item.lotusRoundsPlayed
            lotusTimePlayedWeek += item.lotusTimePlayed
            for i in 0..<item.lotusCorrectList.count{
                lotusCorrectWeek[i] += item.lotusCorrectList[i]
            }
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
        let lstring = "\nLotus: " + String(la.count) + "\nWeek:\nRounds: " + String(lotusRoundsWeek) + "\nToday: \nRounds: " + String(lotusRoundsToday) + "\nTime PlayedToday: " + String(lotusTimePlayedToday) + "\nWeek: " + String(lotusTimePlayedWeek) + "\nMiss Today: " + String(lotusCorrectToday[0]) + String(lotusCorrectToday[1]) + String(lotusCorrectToday[2]) + String(lotusCorrectToday[3])
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
        rerolls = defaults.integer(forKey: "rerolls")
        dailyQuestData = defaults.dictionary(forKey: "dailyQuestData") ?? [:]
        if dailyQuestData.isEmpty{

        }
        else if (dailyQuestData["timeEnd"] as! Date) < today{

        }
        else {
        }
    }
    
    @IBAction func trashPressed(_ sender: Any) {
        data = [String]()
        name = "N/A"
        exp = 0
        dailyQuest = Quest()
        dailyQuestData = [:]
        UserDefaults.standard.set(exp, forKey: "exp")
        UserDefaults.standard.set(name, forKey: "shared_default")
        UserDefaults.standard.set(dailyQuestData, forKey: "dailyQuestData")
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

