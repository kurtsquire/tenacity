//
//  HomeViewController.swift
//  TenacityV3
//
//  Created by PLL on 7/26/19.
//  Copyright © 2019 PLL. All rights reserved.
//



import RealmSwift

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

class HomeViewController: PhoneViewController {
    
    
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
    
    
    
    // ------------------------- VARIABLES USER DEFAULTS ---------------
    var dateString = ""
    
    
    // -----------------------------------------------------------------
    
    lazy var breatheFGraphCenter = breatheFocusLabel.center
    lazy var breatheIGraphCenter = breatheInfiniteLabel.center
    lazy var lotusGraphCenter = lotusSwipeLabel.center
    
    
    // -------------------------- ViewDidAppear ----------------------------
    
    // changes the top font to white (time and battery life wifi etc)
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // takes out top bar
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // quotes
        let quotes = Quotes()
        petQuoteLabel.text = quotes.randomQuote()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // take out the graph
    }
    
    override func viewDidLoad() { //opening app (only triggers when quitting and opening app again)
        super.viewDidLoad()
        
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
        petEquipped = defaults.integer(forKey: "petEquipped")
        
    }
    
    // -------------------------- QUESTS -------------------------------------

    
    func buildQuest(){
        if ((dailyQuestData["questType"] as! String) == "breathe focus"){
            dailyQuest = BreatheFocusQuest(qs: (dailyQuestData["questString"] as! String), ts: (dailyQuestData["timeStart"] as! Date), te: (dailyQuestData["timeEnd"] as! Date), exp: (dailyQuestData["exp"] as! Int), r: (dailyQuestData["reward"] as! String), obj: (dailyQuestData["obj"] as! Int), gn: (dailyQuestData["goalNum"] as! Int), gt: (dailyQuestData["goalTime"] as! Int), ct: (dailyQuestData["count"] as! Int), c: (dailyQuestData["complete"] as! Bool))
        }
        else if ((dailyQuestData["questType"] as! String) == "breathe infinite"){
            dailyQuest = BreatheInfiniteQuest(qs: (dailyQuestData["questString"] as! String), ts: (dailyQuestData["timeStart"] as! Date), te: (dailyQuestData["timeEnd"] as! Date), exp: (dailyQuestData["exp"] as! Int), r: (dailyQuestData["reward"] as! String), gc: (dailyQuestData["goalCycle"] as! Int), gn: (dailyQuestData["goalNum"] as! Int), gt: (dailyQuestData["goalTime"] as! Int), c: (dailyQuestData["complete"] as! Bool))
        }
        else if ((dailyQuestData["questType"] as! String) == "lotus"){
            dailyQuest = LotusQuest(qs: (dailyQuestData["questString"] as! String), ts: (dailyQuestData["timeStart"] as! Date), te: (dailyQuestData["timeEnd"] as! Date), exp: (dailyQuestData["exp"] as! Int), r: (dailyQuestData["reward"] as! String), obj: (dailyQuestData["obj"] as! Int), gn: (dailyQuestData["goalNum"] as! Int), ct: (dailyQuestData["count"] as! Int), c: (dailyQuestData["complete"] as! Bool))
        }
        else if ((dailyQuestData["questType"] as! String) == "play all"){
            dailyQuest = PlayAllQuest(qs: (dailyQuestData["questString"] as! String), ts: (dailyQuestData["timeStart"] as! Date), te: (dailyQuestData["timeEnd"] as! Date), exp: (dailyQuestData["exp"] as! Int), r: (dailyQuestData["reward"] as! String), g: (dailyQuestData["goal"] as! Int), bfp: (dailyQuestData["bfPlayed"] as! Int), bip: (dailyQuestData["biPlayed"] as! Int), lp: (dailyQuestData["lPlayed"] as! Int), c: (dailyQuestData["complete"] as! Bool))
        }
    }
    
    func generateQuest(){
        let num = Int.random(in: 1 ... 100)//RNG for which quest type appears
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
                saveQuest(progress: false)
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
                dailyQuestData["goalNum"] = 0
                dailyQuestData["count"] = 0
                saveQuest(progress: false)
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
                saveQuest(progress: false)
                buildQuest()
            }
//            else if (num2 == 4){//BF: Play a game that lasts x minutes without failing a cycle
//                let x = Int.random(in: 3 ... 8)
//                dailyQuestData["questType"] = "breathe focus"
//                dailyQuestData["questString"] = "Breathe Focus\nPlay a game that lasts " + String(x) + " minutes without failing a cycle."
//                dailyQuestData["timeStart"] = today
//                dailyQuestData["timeEnd"] = calendar.date(byAdding: .day, value: 1, to: today)
//                dailyQuestData["reward"] = "Progress!"
//                dailyQuestData["complete"] = false
//                dailyQuestData["exp"] = 20*x
//                dailyQuestData["obj"] = 3
//                dailyQuestData["goalTime"] = x*60
//                saveQuest(progress: false)
//                buildQuest()
//            }
        }
        else if (num <= 75){//BI: Play for x minutes and complete y cycles of rate z
            let x = Int.random(in: 5 ... 15)
            let y = Int.random(in: 3 ... 10)
            let z = Int.random(in: 3 ... 8)
            dailyQuestData["questType"] = "breathe infinite"
            dailyQuestData["questString"] = "Breathe Infinite\nPlay a " + String(x) + "-minute session and complete " + String(y) + " cycles at rate " + String(z) + "."
            dailyQuestData["timeStart"] = today
            dailyQuestData["timeEnd"] = calendar.date(byAdding: .day, value: 1, to: today)
            dailyQuestData["reward"] = "Progress!"
            dailyQuestData["complete"] = false
            dailyQuestData["exp"] = 10*x*y*z
            dailyQuestData["goalTime"] = x*60
            dailyQuestData["goalNum"] = y
            dailyQuestData["goalCycle"] = z
            saveQuest(progress: false)
            buildQuest()
        }
        else if (num <= 90){//Lotus Quests
            let num2 = Int.random(in: 1 ... 2)//No longer want Quest 2
            if (num2 == 1){//L: Play x rounds
                var x = Int.random(in: 4 ... 8)
                x *= 5
                dailyQuestData["questType"] = "lotus"
                dailyQuestData["questString"] = "Lotus\nPlay " + String(x) + " rounds."
                dailyQuestData["timeStart"] = today
                dailyQuestData["timeEnd"] = calendar.date(byAdding: .day, value: 1, to: today)
                dailyQuestData["reward"] = "Progress!"
                dailyQuestData["complete"] = false
                dailyQuestData["exp"] = 10*x
                dailyQuestData["obj"] = 0
                dailyQuestData["goalNum"] = x
                dailyQuestData["count"] = 0
                saveQuest(progress: false)
                buildQuest()
            }
//            else if (num2 == 2){//L: Play a game of x rounds without missing
//                var x = Int.random(in: 2 ... 6)
//                x *= 5
//                dailyQuestData["questType"] = "lotus"
//                dailyQuestData["questString"] = "Lotus\nPlay a game with " + String(x) + " rounds without missing."
//                dailyQuestData["timeStart"] = today
//                dailyQuestData["timeEnd"] = calendar.date(byAdding: .day, value: 1, to: today)
//                dailyQuestData["reward"] = "Progress!"
//                dailyQuestData["complete"] = false
//                dailyQuestData["exp"] = 15*x
//                dailyQuestData["obj"] = 1
//                dailyQuestData["goalNum"] = x
//                dailyQuestData["count"] = 0
//                saveQuest(progress: false)
//                buildQuest()
//            }
            else if (num2 == 2){//L: Play x games
                let x = Int.random(in: 2 ... 5)
                dailyQuestData["questType"] = "lotus"
                dailyQuestData["questString"] = "Lotus\nPlay " + String(x) + " games."
                dailyQuestData["timeStart"] = today
                dailyQuestData["timeEnd"] = calendar.date(byAdding: .day, value: 1, to: today)
                dailyQuestData["reward"] = "Progress!"
                dailyQuestData["complete"] = false
                dailyQuestData["exp"] = 20*x
                dailyQuestData["obj"] = 0
                dailyQuestData["goalNum"] = x
                dailyQuestData["count"] = 0
                saveQuest(progress: false)
                buildQuest()
            }
        }
        else{//PA: Play each game for x minutes
            let x = Int.random(in: 2 ... 5)
            dailyQuestData["questType"] = "play all"
            dailyQuestData["questString"] = "Play All\nPlay each game for " + String(x) + " minutes."
            dailyQuestData["timeStart"] = today
            dailyQuestData["timeEnd"] = calendar.date(byAdding: .day, value: 1, to: today)
            dailyQuestData["reward"] = "Progress!"
            dailyQuestData["complete"] = false
            dailyQuestData["exp"] = 40*x
            dailyQuestData["goal"] = x*60
            dailyQuestData["bfPlayed"] = 0
            dailyQuestData["biPlayed"] = 0
            dailyQuestData["lPlayed"] = 0
            saveQuest(progress: false)
            buildQuest()
        }
    }
    
    func questRewardGenerator() -> String{
        
    }
    
    
    
}
