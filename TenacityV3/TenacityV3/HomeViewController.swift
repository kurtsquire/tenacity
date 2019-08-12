//
//  HomeViewController.swift
//  TenacityV3
//
//  Created by PLL on 7/26/19.
//  Copyright © 2019 PLL. All rights reserved.
//


import UIKit
import RealmSwift
import WatchConnectivity

var screenWidth = CGFloat(300.0)

var circleGraphRadius = CGFloat(75)
var circleGraphWidth = CGFloat(14)

var breatheFGraphEndAngle = CGFloat(0)
let breatheFGraphOutColor = UIColor(red: 0.21, green: 0.84, blue: 0.44, alpha: 0.1).cgColor
let breatheFGraphProgColor = UIColor(red: 0.21, green: 0.84, blue: 0.44, alpha: 1.0).cgColor

var breatheIGraphEndAngle = CGFloat(0)
let breatheIGraphOutColor = UIColor(red: 0.96, green: 0.95, blue: 0.35, alpha: 0.1).cgColor
let breatheIGraphProgColor = UIColor(red: 0.96, green: 0.95, blue: 0.35, alpha: 1.0).cgColor

var lotusGraphEndAngle = CGFloat(0)
let lotusGraphOutColor = UIColor(red: 0.84, green: 0.22, blue: 0.53, alpha: 0.1).cgColor
let lotusGraphProgColor = UIColor(red: 0.84, green: 0.22, blue: 0.53, alpha: 1.0).cgColor

var breatheFGoalTime = 30.0
var breatheIGoalTime = 30.0
var lotusGoalTime = 30.0

class HomeViewController: UIViewController, WCSessionDelegate {
    
    
    @IBOutlet weak var mainView: UIView!
    
    
    // --------------------------- EXPERIENCE -----------------------------
    @IBOutlet weak var expBar1: UIImageView!
    @IBOutlet weak var expBar2: UIImageView!
    @IBOutlet weak var expBar3: UIImageView!
    @IBOutlet weak var expBar4: UIImageView!
    
    @IBOutlet weak var expLabel: UILabel!
    @IBOutlet weak var lvlLabel: UILabel!
    
    
    // --------------------------- PROGRESS -----------------------------
    @IBAction func progressHelpButton(_ sender: Any) {
    }
    @IBAction func settingsButton(_ sender: Any) {
    }
    
    // --------------------------- PETS -----------------------------
   
    @IBOutlet weak var homePet: UIButton!
    @IBOutlet weak var petQuoteLabel: UILabel!
    
    
    // --------------------------- GOALS -----------------------------
    @IBAction func goalsHelpButton(_ sender: Any) {
    }
    @IBOutlet weak var breatheFMinuteGoalLabel: UILabel!
    @IBOutlet weak var breatheIMinuteGoalLabel: UILabel!
    @IBOutlet weak var lotusMinuteGoalLabel: UILabel!
    @IBOutlet weak var breatheFocusLabel: UILabel!
    @IBOutlet weak var breatheInfiniteLabel: UILabel!
    @IBOutlet weak var lotusSwipeLabel: UILabel!
    
    @IBOutlet weak var badge1: UIButton!
    @IBOutlet weak var badge2: UIButton!
    @IBOutlet weak var badge3: UIButton!
    @IBAction func achievementButton(_ sender: Any) {
    }
    
    //-------------------------- CIRCLE GRAPHS ----------------------------
    
    
    // --------------------------- QUESTS -----------------------------
    @IBAction func questRerollButton(_ sender: Any) {
        generateQuest()
        questDetailsLabel.text = dailyQuest.questString
    }
    @IBAction func questHelpButton(_ sender: Any) {
    }
    @IBOutlet weak var questDetailsLabel: UILabel!
    @IBOutlet weak var rewardImage: UIImageView!
    
    
    // --------------------------- NUDGES -----------------------------
    @IBAction func nudgeHelpButton(_ sender: Any) {
    }
    @IBOutlet weak var nudge1: UILabel!
    @IBOutlet weak var nudge2: UILabel!
    @IBOutlet weak var nudge3: UILabel!
    @IBOutlet weak var nudge4: UILabel!
    
    
    // ------------------------- VARIABLES TIME ----------------------------------
    var calendar = Calendar.autoupdatingCurrent
    var today = Date()
    var startTime = Date()
    var weekStartTime = Date()
    
    
    // ------------------------- VARIABLES QUESTS ------------------------
    var dailyQuest = Quest()
    var dailyQuestData : Dictionary<String, Any> = [:]
    
    
    // ------------------------- VARIABLES USER DEFAULTS ---------------
    var exp = 0
    var dateString = ""
    
    
    // -----------------------------------------------------------------
    
    lazy var breatheFGraphCenter = breatheFocusLabel.center
    lazy var breatheIGraphCenter = breatheInfiniteLabel.center
    lazy var lotusGraphCenter = lotusSwipeLabel.center
    
    
    // -----------------------------------------------------------------
    
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
        // take out the graph
    }
    
    override func viewDidLoad() { //opening app (only triggers when quitting and opening app again)
        super.viewDidLoad()
        
        if WCSession.isSupported(){
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        // finds screen width for graph adaptation
        screenWidth = mainView.frame.size.width
        
        // updates date for today
        today = Date()
        startTime = calendar.startOfDay(for: today)
        
        //creates a date at the beginning of the week to compare
        let weekComponents = calendar.dateComponents([.month, .yearForWeekOfYear, .weekOfYear], from: today)
        weekStartTime = calendar.date(from: weekComponents)!
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) { //openign back up the tab (works from other tabs)
        super.viewDidAppear(animated)
        
        testUserDefaults()
        refreshRealmData()
        
        
        // update labels -------------
        let lvl = (exp/1000)
        let baseEXP = (exp - (lvl*1000))
        lvlLabel.text = "Lvl " + String(lvl + 1) // +1 so that you start lvl 1 not 0
        expLabel.text = String(baseEXP) + "/1000" //this allows an exp value of 7856 -> lvl 7 with 856 exp
        nudge1.text = dateString
        
        
        if (baseEXP >= 900){
            expBar1.image = UIImage(named: "expFill")
            expBar2.image = UIImage(named: "expFill")
            expBar3.image = UIImage(named: "expFill")
            expBar4.image = UIImage(named: "expFill")
        }
        else if (baseEXP >= 750){
            expBar1.image = UIImage(named: "expFill")
            expBar2.image = UIImage(named: "expFill")
            expBar3.image = UIImage(named: "expFill")
            expBar4.image = UIImage(named: "expUnfill")
        }
        else if (baseEXP >= 500){
            expBar1.image = UIImage(named: "expFill")
            expBar2.image = UIImage(named: "expFill")
            expBar3.image = UIImage(named: "expUnfill")
            expBar4.image = UIImage(named: "expUnfill")
        }
        else if (baseEXP >= 250){
            expBar1.image = UIImage(named: "expFill")
            expBar2.image = UIImage(named: "expUnfill")
            expBar3.image = UIImage(named: "expUnfill")
            expBar4.image = UIImage(named: "expUnfill")
        }
        else{}
        
        if !dailyQuestData.isEmpty{
            if dailyQuest.complete{
                questDetailsLabel.text = "Quest Complete!!!! Good Job"
            }
            else {
                questDetailsLabel.text = dailyQuest.questString
            }
        }
        else{
            questDetailsLabel.text = "No Current Quest"
        }
        
    }
    
    // ----------------------- UTILITY -------------------------------
    
    func saveEXP(addEXP : Int){
        exp += addEXP
        UserDefaults.standard.set(exp, forKey: "exp")
    }
    
    // ---------------------- REALM -----------------------------------
    func refreshRealmData(){
        let realm = try! Realm()
    
        let bfx = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@", "breathe focus", startTime)
        let bix = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@", "breathe infinite", startTime)
        let lx = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@", "lotus", startTime)
    
        var breatheFTimeToday = 0.0
        var breatheITimeToday = 0.0
        var lotusTimeToday = 0.0
        
        for item in bfx{
            breatheFTimeToday += item.breatheFTimePlayed
        }
        for item in bix{
            breatheITimeToday += item.breatheITimePlayed
        }
        for item in lx{
            lotusTimeToday += item.lotusTimePlayed
        }
        
        DispatchQueue.main.async {
            self.breatheFMinuteGoalLabel.text = String(Int(breatheFTimeToday/60)) + "/" + String(Int(breatheFGoalTime)) + "mins"
            self.breatheIMinuteGoalLabel.text = String(Int(breatheITimeToday/60)) + "/" + String(Int(breatheIGoalTime)) + "mins"
            self.lotusMinuteGoalLabel.text = String(Int(lotusTimeToday/60)) + "/" + String(Int(lotusGoalTime)) + "mins"
            
            breatheFGraphEndAngle = CGFloat((breatheFTimeToday/60)/breatheFGoalTime)
            if (breatheFGraphEndAngle == 0){
                breatheFGraphEndAngle = 0.01
            }
            
            breatheIGraphEndAngle = CGFloat((breatheITimeToday/60)/breatheIGoalTime)
            if (breatheIGraphEndAngle == 0){
                breatheIGraphEndAngle = 0.01
            }
            
            lotusGraphEndAngle = CGFloat((lotusTimeToday/60)/lotusGoalTime)
            if (lotusGraphEndAngle == 0){
                lotusGraphEndAngle = 0.01
            }
            
            let breatheFCircleGraph = CircleChart(radius: circleGraphRadius, progressEndAngle: breatheFGraphEndAngle, center: self.breatheFGraphCenter, lineWidth: circleGraphWidth, outlineColor: breatheFGraphOutColor, progressColor: breatheFGraphProgColor)
            self.mainView.layer.addSublayer(breatheFCircleGraph.outlineLayer)
            self.mainView.layer.addSublayer(breatheFCircleGraph.progressLayer)
            
            let breatheICircleGraph = CircleChart(radius: circleGraphRadius, progressEndAngle: breatheIGraphEndAngle, center: self.breatheIGraphCenter, lineWidth: circleGraphWidth, outlineColor: breatheIGraphOutColor, progressColor: breatheIGraphProgColor)
            self.mainView.layer.addSublayer(breatheICircleGraph.outlineLayer)
            self.mainView.layer.addSublayer(breatheICircleGraph.progressLayer)
            
            let lotusCircleGraph = CircleChart(radius: circleGraphRadius, progressEndAngle: lotusGraphEndAngle, center: self.lotusGraphCenter, lineWidth: circleGraphWidth, outlineColor: lotusGraphOutColor, progressColor: lotusGraphProgColor)
            self.mainView.layer.addSublayer(lotusCircleGraph.outlineLayer)
            self.mainView.layer.addSublayer(lotusCircleGraph.progressLayer)
            
        }
    }
    
    // ------------------------ USER DEFAULTS ---------------------------
    func testUserDefaults(){
        let defaults = UserDefaults.standard
        
        // get exp
        exp = defaults.integer(forKey: "exp")
        
        // get nudge
        dateString = defaults.string(forKey: "dateString") ?? "No Nudge Set"
        
        // get quest
        dailyQuestData = defaults.dictionary(forKey: "dailyQuestData") ?? [:]
        if !dailyQuestData.isEmpty{
            buildQuest()
        }
        
    }
    
    // -------------------------- QUESTS -------------------------------------
    func saveQuest(){
        let report = dailyQuest.getProgress()
        for (counter, value) in report{
            dailyQuestData[counter] = value
        }
        UserDefaults.standard.set(dailyQuestData, forKey: "dailyQuestData")
    }
    
    func buildQuest(){
        if ((dailyQuestData["questType"] as! String) == "breathe focus"){
            dailyQuest = BreatheFocusQuest(qs: (dailyQuestData["questString"] as! String), ts: (dailyQuestData["timeStart"] as! Date), te: (dailyQuestData["timeEnd"] as! Date), exp: (dailyQuestData["exp"] as! Int), r: (dailyQuestData["reward"] as! String), obj: (dailyQuestData["obj"] as! Int), gn: (dailyQuestData["goalNum"] as! Int), gt: (dailyQuestData["goalTime"] as! Int), ct: (dailyQuestData["count"] as! Int), c: (dailyQuestData["complete"] as! Bool))
        }
        else if ((dailyQuestData["questType"] as! String) == "breathe infinite"){
            dailyQuest = BreatheInfiniteQuest(qs: (dailyQuestData["questString"] as! String), ts: (dailyQuestData["timeStart"] as! Date), te: (dailyQuestData["timeEnd"] as! Date), exp: (dailyQuestData["exp"] as! Int), r: (dailyQuestData["reward"] as! String), gc: (dailyQuestData["goalCount"] as! Int), gn: (dailyQuestData["goalNum"] as! Int), gt: (dailyQuestData["goalTime"] as! Int), c: (dailyQuestData["complete"] as! Bool))
        }
        else if ((dailyQuestData["questType"] as! String) == "lotus"){
            dailyQuest = LotusQuest(qs: (dailyQuestData["questString"] as! String), ts: (dailyQuestData["timeStart"] as! Date), te: (dailyQuestData["timeEnd"] as! Date), exp: (dailyQuestData["exp"] as! Int), r: (dailyQuestData["reward"] as! String), obj: (dailyQuestData["obj"] as! Int), gn: (dailyQuestData["goalNum"] as! Int), ct: (dailyQuestData["count"] as! Int), c: (dailyQuestData["complete"] as! Bool))
        }
        else if ((dailyQuestData["questType"] as! String) == "play all"){
            dailyQuest = PlayAllQuest(qs: (dailyQuestData["questString"] as! String), ts: (dailyQuestData["timeStart"] as! Date), te: (dailyQuestData["timeEnd"] as! Date), exp: (dailyQuestData["exp"] as! Int), r: (dailyQuestData["reward"] as! String), g: (dailyQuestData["goalNum"] as! Int), bfp: (dailyQuestData["bfPlayed"] as! Int), bip: (dailyQuestData["biPlayed"] as! Int), lp: (dailyQuestData["lPlayed"] as! Int), c: (dailyQuestData["complete"] as! Bool))
        }
    }
    
    func generateQuest(){
        let num = Int.random(in: 1 ... 60) // --------------------------------------------------- SET THIS TO 100 LATER ---------  TEMP 60 FOR NOW  --------------------------------------------------------------------------------------------------------------------------------------
        if (num <= 60){//Breathe Focus Quests
            let num2 = Int.random(in: 1 ... 3) // no longer want quest 4
            if (num2 == 1){//BF: Spend x minutes at rate y
                let x = Int.random(in: 5 ... 15) // 5-15
                let y = Int.random(in: 3 ... 8) // 3-8
                dailyQuestData["questType"] = "breathe focus"
                dailyQuestData["questString"] = "Breathe Focus\nPlay for " + String(x) + " minutes with rate set to " + String(y) + "."
                dailyQuestData["timeStart"] = today
                dailyQuestData["timeEnd"] = calendar.date(byAdding: .day, value: 1, to: today)
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
                dailyQuestData["questString"] = "Breathe Focus\nPlay for " + String(x) + " minutes."
                dailyQuestData["timeStart"] = today
                dailyQuestData["timeEnd"] = calendar.date(byAdding: .day, value: 1, to: today)
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
                dailyQuestData["questString"] = "Breathe Focus\nPlay " + String(x) + " games that last at least " + String(y) + " minutes."
                dailyQuestData["timeStart"] = today
                dailyQuestData["timeEnd"] = calendar.date(byAdding: .day, value: 1, to: today)
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
//            else if (num2 == 4){//BF: Play a game that lasts x minutes without failing a cycle
//                let x = Int.random(in: 3 ... 8)
//                dailyQuestData["questType"] = "breathe focus"
//                dailyQuestData["questString"] = "Play a game that lasts " + String(x) + " minutes without failing a cycle."
//                dailyQuestData["timeStart"] = today
//                dailyQuestData["timeEnd"] = calendar.date(byAdding: .day, value: 1, to: today)
//                dailyQuestData["reward"] = "Progress!"
//                dailyQuestData["complete"] = false
//                dailyQuestData["exp"] = 20*x
//                dailyQuestData["obj"] = 3
//                dailyQuestData["goalTime"] = x*60
//                saveQuest()
//                buildQuest()
//            }
        }
        else if (num <= 75){//BI: Play for x minutes and complete y cycles of rate z
            let x = Int.random(in: 5 ... 15)
            let y = Int.random(in: 3 ... 10)
            let z = Int.random(in: 3 ... 8)
            dailyQuestData["questType"] = "breathe infinite"
            dailyQuestData["questString"] = "Play a " + String(x) + "-minute session and complete " + String(y) + " cycles at rate " + String(z) + "."
            dailyQuestData["timeStart"] = today
            dailyQuestData["timeEnd"] = calendar.date(byAdding: .day, value: 1, to: today)
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
                dailyQuestData["timeStart"] = today
                dailyQuestData["timeEnd"] = calendar.date(byAdding: .day, value: 1, to: today)
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
                dailyQuestData["timeStart"] = today
                dailyQuestData["timeEnd"] = calendar.date(byAdding: .day, value: 1, to: today)
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
                dailyQuestData["timeStart"] = today
                dailyQuestData["timeEnd"] = calendar.date(byAdding: .day, value: 1, to: today)
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
            dailyQuestData["timeStart"] = today
            dailyQuestData["timeEnd"] = calendar.date(byAdding: .day, value: 1, to: today)
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
            //let settings = userInfo["settings"] as! String
            
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
                
                print(lotusRoundsPlayed)
                print(lotusSettings)
                print(lotusTimePlayed)
                print(lotusMissArray[0])
                
                gameDataModel.lotusRoundsPlayed = lotusRoundsPlayed
                gameDataModel.lotusRoundsSetting = lotusSettings //new
                gameDataModel.lotusTimePlayed = lotusTimePlayed
                
                gameDataModel.lotusCorrectList.append(objectsIn: lotusMissArray)
                print(gameDataModel.lotusRoundsPlayed)
                print(gameDataModel.lotusRoundsSetting)
                print(gameDataModel.lotusTimePlayed)
                print(gameDataModel.lotusCorrectList)
                
                saveEXP(addEXP: Int(5*lotusRoundsPlayed))
                
                // dictionary needs: game(String), timeEnd(Date), rounds(Int), accuracy(Double)
                // if dailyDone (new var not made yet) != true then checkquest
                // if check quest returns true
                // give rewards, set dailyDone true, etc
                
                //if !(dailyQuestData["complete"] as! Bool){
                //    dailyQuestData["complete"] = dailyQuest.checkQuest(data: qdata)
                //}
                saveQuest()
                
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
                
                // dictionary needs: game(String), timeEnd(Date), cycle(Int), timePlayed(Int), correct(Int), total(Int)
                // if dailyDone (new var not made yet) != true then checkquest
                // if check quest returns true
                // give rewards, set dailyDone true, etc
                
                let qdata = ["game": game, "timeEnd": date, "timePlayed": Int(breatheFTimePlayed), "correct": breatheFCorrectSets, "total": breatheFTotalSets, "cycle": breatheFCycleSettings] as [String : Any]
                
                if !dailyQuestData.isEmpty && !(dailyQuestData["complete"] as! Bool){
                    if dailyQuest.checkQuest(data: qdata){
                        dailyQuestData["complete"] = true
                        saveEXP(addEXP: (dailyQuestData["exp"] as! Int))
                        //give reward
                    }
                }
                saveQuest()
                
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
                print(templist)
                
                gameDataModel.breatheITimePlayed = breatheITimePlayed
                gameDataModel.breatheIBreathLength = breatheIBreathLength
                gameDataModel.breatheITotalSets = breatheITotalSets
                gameDataModel.breatheICycleList.append(objectsIn: templist)
                //print(gameDataModel.breatheICycleList)
                
                saveEXP(addEXP: Int(breatheITimePlayed))
                
                // dictionary needs: game(String), timeEnd(Date), timePlayed(Int), cycle(Dictionary<String,Int>)
                // if dailyDone (new var not made yet) != true then checkquest
                // if check quest returns true
                // give rewards, set dailyDone true, etc
                saveQuest()
                
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
