//
//  HomeViewController.swift
//  TenacityV3
//
//  Created by PLL on 7/26/19.
//  Copyright © 2019 PLL. All rights reserved.
//


import Charts
import RealmSwift


let weekDays = ["Sun.", "Mon.", "Tue.", "Wed.", "Thu.", "Fri.", "Sat."]


var screenWidth = CGFloat(300.0)

var circleGraphRadius = CGFloat(75)
var circleGraphWidth = CGFloat(14)

var breatheFGraphEndAngle = CGFloat(0)
let breatheFGraphOutColor = UIColor(red: 0.15, green: 0.21, blue: 0.17, alpha: 1.0).cgColor
let breatheFGraphProgColor = UIColor(red: 0.21, green: 0.84, blue: 0.44, alpha: 1.0).cgColor

var breatheIGraphEndAngle = CGFloat(0)
let breatheIGraphOutColor = UIColor(red: 0.21, green: 0.20, blue: 0.16, alpha: 1.0).cgColor
let breatheIGraphProgColor = UIColor(red: 0.96, green: 0.95, blue: 0.35, alpha: 1.0).cgColor

var lotusGraphEndAngle = CGFloat(0)
let lotusGraphOutColor = UIColor(red: 0.21, green: 0.15, blue: 0.18, alpha: 1.0).cgColor
let lotusGraphProgColor = UIColor(red: 0.84, green: 0.22, blue: 0.53, alpha: 1.0).cgColor



var currentGame = "breatheFocus"

class HomeViewController: PhoneViewController {
    
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var homeLineGraph: LineChartView!
    var homeTutorialCompleted = false
    
    
    // --------------------------- EXPERIENCE OUTLETS -----------------------------
    @IBOutlet weak var expBar1: UIImageView!
    @IBOutlet weak var expBar2: UIImageView!
    @IBOutlet weak var expBar3: UIImageView!
    @IBOutlet weak var expBar4: UIImageView!
    
    @IBOutlet weak var expLabel: UILabel!
    @IBOutlet weak var lvlLabel: UILabel!
    
    
    // --------------------------- PROGRESS OUTLETS -----------------------------
    @IBAction func progressHelpButton(_ sender: Any) {
    }
    @IBAction func settingsButton(_ sender: Any) {
    }
    
    // --------------------------- PET OUTLETS -----------------------------
 
    @IBOutlet weak var homePet: UIImageView!
    @IBOutlet weak var petQuoteLabel: UILabel!
    @IBAction func quoteButton(_ sender: Any) {
        let quotes = Quotes()
        petQuoteLabel.text = quotes.randomQuote()
    }
    
    
    // --------------------------- GOALS OUTLETS -----------------------------
    var breatheFGoalTime = 30.0
    var breatheIGoalTime = 20.0
    var lotusGoalTime = 20.0
    
    @IBAction func goalsHelpButton(_ sender: Any) {
    }
    @IBOutlet weak var breatheFocusLabel: UILabel!
    @IBOutlet weak var breatheInfiniteLabel: UILabel!
    @IBOutlet weak var lotusSwipeLabel: UILabel!
    
    @IBOutlet weak var breatheFMinuteGoalButton: UIButton!
    @IBOutlet weak var breatheIMinuteGoalButton: UIButton!
    @IBOutlet weak var lotusMinuteGoalButton: UIButton!
    
    @IBAction func breatheFGoalButtonPressed(_ sender: Any) {
        currentGame = "breatheFocus"
    }
    @IBAction func breatheIGoalButtonPressed(_ sender: Any) {
        currentGame = "breatheInfinite"
    }
    @IBAction func lotusGoalButtonPressed(_ sender: Any) {
        currentGame = "lotus"
    }
    // Achievements
//    @IBOutlet weak var badge1: UIButton!
//    @IBOutlet weak var badge2: UIButton!
//    @IBOutlet weak var badge3: UIButton!
//    @IBAction func achievementButton(_ sender: Any) {
//    }
    
    // Center of the Circle Goal Graphs
    lazy var breatheFGraphCenter = breatheFocusLabel.center
    lazy var breatheIGraphCenter = breatheInfiniteLabel.center
    lazy var lotusGraphCenter = lotusSwipeLabel.center
    
    // --------------------------- QUEST OUTLETS -----------------------------
    @IBOutlet weak var rerollButton: UIButton!
    @IBAction func questRerollButton(_ sender: Any) {
        if (rerolls > 0 && !(dailyQuestData["complete"] as! Bool)){
            generateQuest()
            questDetailsLabel.text = dailyQuest.questString
            rerolls -= 1
            UserDefaults.standard.set(rerolls, forKey: "rerolls")
            rerollButton.setTitle("Reroll x" + String(rerolls), for: .normal)
        }
    }
    @IBAction func questHelpButton(_ sender: Any) {
    }
    @IBOutlet weak var questDetailsLabel: UILabel!
    //@IBOutlet weak var rewardImage: UIImageView!
    
    
    // --------------------------- NUDGES -----------------------------
    @IBAction func nudgeHelpButton(_ sender: Any) {
    }
    @IBOutlet weak var nudge1: UILabel!
    @IBOutlet weak var nudge2: UILabel!
    @IBOutlet weak var nudge3: UILabel!
    @IBOutlet weak var nudge4: UILabel!
    @IBOutlet weak var nudge5: UILabel!
    @IBOutlet weak var nudge6: UILabel!
    
    
    // ------------------------- VARIABLES TIME ----------------------------------
    var calendar = Calendar.autoupdatingCurrent
    var today = Date()
    var startTime = Date()
    var weekStartTime = Date()
    
    // -------------------------- VIEW LOADS ----------------------------
    
    // changes the top font to white (time and battery life wifi etc)
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // takes out top bar
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // updates date for today
        today = Date()
        startTime = calendar.startOfDay(for: today)
        
        //creates a date at the beginning of the week to compare
        let weekComponents = calendar.dateComponents([.month, .yearForWeekOfYear, .weekOfYear], from: today)
        weekStartTime = calendar.date(from: weekComponents)!
        
        testUserDefaults()
        
        print("viewWillAppear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("viewdiddisapear")
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
        
        
        // sets graph components
        self.homeLineGraph.gridBackgroundColor = UIColor.white
        self.homeLineGraph.noDataText = "No data provided"
        self.homeLineGraph.doubleTapToZoomEnabled = false
        self.homeLineGraph.xAxis.labelPosition = XAxis.LabelPosition.bottom
        self.homeLineGraph.highlightPerTapEnabled = false
        self.homeLineGraph.highlightPerDragEnabled = false
        self.homeLineGraph.xAxis.valueFormatter = IndexAxisValueFormatter(values: weekDays)
        self.homeLineGraph.xAxis.granularity = 1
        self.homeLineGraph.legend.textColor = UIColor.white
        self.homeLineGraph.xAxis.labelTextColor = UIColor.white
        self.homeLineGraph.rightAxis.labelTextColor = UIColor.white
        self.homeLineGraph.leftAxis.labelTextColor = UIColor.white
        
        print("viewdidload")

    }
    
    override func viewDidAppear(_ animated: Bool) { //openign back up the tab (works from other tabs)
        super.viewDidAppear(animated)
        
        
        refreshRealmData()
        testUserDefaults()
        
        // update labels -------------
        updateExp()
        updatePet()
        
        // quotes
        let quotes = Quotes()
        petQuoteLabel.text = quotes.randomQuote()
        if (nudge1.text == "No Current Nudge" && nudge2.text == "No Current Nudge" && nudge3.text == "No Current Nudge" && nudge4.text == "No Current Nudge" && nudge5.text == "No Current Nudge" && nudge6.text == "No Current Nudge"){
            let num = Int.random(in: 1 ... 8)
            if (num == 1){
                petQuoteLabel.text = "try setting a nudge today"
            }
            else if (num == 2){
                petQuoteLabel.text = "use nudges to plan out your day"
            }
            else if (num == 3){
                petQuoteLabel.text = "nudges can be used to send you reminders"
            }
            else if (num == 4){
                petQuoteLabel.text = "(whispering: set a nudge)"
            }
        }
        
        if !dailyQuestData.isEmpty{
            if dailyQuest.complete{
//                if ((dailyQuestData["reward"] as! Int) != 0){
//                    questDetailsLabel.text = "Great job! You've earned " + petArray[(dailyQuestData["reward"] as! Int) - 1].capitalized + "!"
//                }
                
                questDetailsLabel.text = "Great job! You've earned bonus EXP and Points!"
                
            }
            else {
                questDetailsLabel.text = dailyQuest.questString
            }
        }
        else{
            questDetailsLabel.text = "No Current Quest"
        }
        
        if !homeTutorialCompleted{
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "Home Popup")

            self.present(newViewController, animated: true, completion: nil)
        }
    }
    // ----------------------- UTILITY -------------------------------
    
    func updateExp(){
        let lvl = (exp/1000)
        let baseEXP = (exp - (lvl*1000))
        lvlLabel.text = "Rank " + String(lvl + 1) // +1 so that you start lvl 1 not 0
        expLabel.text = String(baseEXP) + "/1000" //this allows an exp value of 7856 -> lvl 7 with 856 exp
    
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
    }
    
    func updatePet(){
        homePet.image = UIImage.init(named: petArray[petEquipped])
    }
    
    
    
    // ---------------------- REALM -----------------------------------
    func refreshRealmData(){
        let realm = try! Realm()
    
        let bfx = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@", "breathe focus", startTime)
        let bix = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@", "breathe infinite", startTime)
        let lx = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@", "lotus", startTime)
    
        // ------------------------------------ BREATHE INFINITE --------------------------------------------------
        
        let bisun = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@ AND sessionDate <= %@", "breathe infinite", weekStartTime,calendar.date(byAdding: DateComponents(day:1), to: weekStartTime, wrappingComponents: false) as Any)
        let bimon = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@ AND sessionDate <= %@", "breathe infinite", calendar.date(byAdding: DateComponents(day:1), to: weekStartTime, wrappingComponents: false) as Any,calendar.date(byAdding: DateComponents(day:2), to: weekStartTime, wrappingComponents: false) as Any)
        let bitues = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@ AND sessionDate <= %@", "breathe infinite", calendar.date(byAdding: DateComponents(day:2), to: weekStartTime, wrappingComponents: false) as Any,calendar.date(byAdding: DateComponents(day:3), to: weekStartTime, wrappingComponents: false) as Any)
        let biwed = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@ AND sessionDate <= %@", "breathe infinite", calendar.date(byAdding: DateComponents(day:3), to: weekStartTime, wrappingComponents: false) as Any,calendar.date(byAdding: DateComponents(day:4), to: weekStartTime, wrappingComponents: false) as Any)
        let bithurs = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@ AND sessionDate <= %@", "breathe infinite", calendar.date(byAdding: DateComponents(day:4), to: weekStartTime, wrappingComponents: false) as Any,calendar.date(byAdding: DateComponents(day:5), to: weekStartTime, wrappingComponents: false) as Any)
        let bifri = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@ AND sessionDate <= %@", "breathe infinite", calendar.date(byAdding: DateComponents(day:5), to: weekStartTime, wrappingComponents: false) as Any,calendar.date(byAdding: DateComponents(day:6), to: weekStartTime, wrappingComponents: false) as Any)
        let bisat = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@ AND sessionDate <= %@", "breathe infinite", calendar.date(byAdding: DateComponents(day:6), to: weekStartTime, wrappingComponents: false) as Any,calendar.date(byAdding: DateComponents(day:7), to: weekStartTime, wrappingComponents: false) as Any)
        
        var breatheITimeSunday = 0.0
        for item in bisun{
            breatheITimeSunday += item.breatheITimePlayed
        }
        
        var breatheITimeMonday = 0.0
        for item in bimon{
            breatheITimeMonday += item.breatheITimePlayed
        }
        
        var breatheITimeTuesday = 0.0
        for item in bitues{
            breatheITimeTuesday += item.breatheITimePlayed
        }
        
        var breatheITimeWednesday = 0.0
        for item in biwed{
            breatheITimeWednesday += item.breatheITimePlayed
        }
        
        var breatheITimeThursday = 0.0
        for item in bithurs{
            breatheITimeThursday += item.breatheITimePlayed
        }
        
        var breatheITimeFriday = 0.0
        for item in bifri{
            breatheITimeFriday += item.breatheITimePlayed
        }
        
        var breatheITimeSaturday = 0.0
        for item in bisat{
            breatheITimeSaturday += item.breatheITimePlayed
        }
        
        let breatheITimePlayed : [Double] = [breatheITimeSunday/60, breatheITimeMonday/60, breatheITimeTuesday/60, breatheITimeWednesday/60, breatheITimeThursday/60, breatheITimeFriday/60, breatheITimeSaturday/60]
        
        // ---------------------------------------- BREATHE FOCUS -------------------------------------------------------
        let bfsun = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@ AND sessionDate <= %@", "breathe focus", weekStartTime,calendar.date(byAdding: DateComponents(day:1), to: weekStartTime, wrappingComponents: false) as Any)
        let bfmon = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@ AND sessionDate <= %@", "breathe focus", calendar.date(byAdding: DateComponents(day:1), to: weekStartTime, wrappingComponents: false) as Any,calendar.date(byAdding: DateComponents(day:2), to: weekStartTime, wrappingComponents: false) as Any)
        let bftues = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@ AND sessionDate <= %@", "breathe focus", calendar.date(byAdding: DateComponents(day:2), to: weekStartTime, wrappingComponents: false) as Any,calendar.date(byAdding: DateComponents(day:3), to: weekStartTime, wrappingComponents: false) as Any)
        let bfwed = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@ AND sessionDate <= %@", "breathe focus", calendar.date(byAdding: DateComponents(day:3), to: weekStartTime, wrappingComponents: false) as Any,calendar.date(byAdding: DateComponents(day:4), to: weekStartTime, wrappingComponents: false) as Any)
        let bfthurs = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@ AND sessionDate <= %@", "breathe focus", calendar.date(byAdding: DateComponents(day:4), to: weekStartTime, wrappingComponents: false) as Any,calendar.date(byAdding: DateComponents(day:5), to: weekStartTime, wrappingComponents: false) as Any)
        let bffri = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@ AND sessionDate <= %@", "breathe focus", calendar.date(byAdding: DateComponents(day:5), to: weekStartTime, wrappingComponents: false) as Any,calendar.date(byAdding: DateComponents(day:6), to: weekStartTime, wrappingComponents: false) as Any)
        let bfsat = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@ AND sessionDate <= %@", "breathe focus", calendar.date(byAdding: DateComponents(day:6), to: weekStartTime, wrappingComponents: false) as Any,calendar.date(byAdding: DateComponents(day:7), to: weekStartTime, wrappingComponents: false) as Any)
        
        var breatheFTimeSunday = 0.0
        for item in bfsun{
            breatheFTimeSunday += item.breatheFTimePlayed
        }
        
        var breatheFTimeMonday = 0.0
        for item in bfmon{
            breatheFTimeMonday += item.breatheFTimePlayed
        }
        
        var breatheFTimeTuesday = 0.0
        for item in bftues{
            breatheFTimeTuesday += item.breatheFTimePlayed
        }
        
        var breatheFTimeWednesday = 0.0
        for item in bfwed{
            breatheFTimeWednesday += item.breatheFTimePlayed
        }
        
        var breatheFTimeThursday = 0.0
        for item in bfthurs{
            breatheFTimeThursday += item.breatheFTimePlayed
        }
        
        var breatheFTimeFriday = 0.0
        for item in bffri{
            breatheFTimeFriday += item.breatheFTimePlayed
        }
        
        var breatheFTimeSaturday = 0.0
        for item in bfsat{
            breatheFTimeSaturday += item.breatheFTimePlayed
        }
        
        let breatheFTimePlayed : [Double] = [breatheFTimeSunday/60, breatheFTimeMonday/60, breatheFTimeTuesday/60, breatheFTimeWednesday/60, breatheFTimeThursday/60, breatheFTimeFriday/60, breatheFTimeSaturday/60]
        
        // ---------------------------------------- LOTUS SWIPE --------------------------------------------------
        let lsun = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@ AND sessionDate <= %@", "lotus", weekStartTime,calendar.date(byAdding: DateComponents(day:1), to: weekStartTime, wrappingComponents: false) as Any)
        let lmon = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@ AND sessionDate <= %@", "lotus", calendar.date(byAdding: DateComponents(day:1), to: weekStartTime, wrappingComponents: false) as Any,calendar.date(byAdding: DateComponents(day:2), to: weekStartTime, wrappingComponents: false) as Any)
        let ltues = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@ AND sessionDate <= %@", "lotus", calendar.date(byAdding: DateComponents(day:2), to: weekStartTime, wrappingComponents: false) as Any,calendar.date(byAdding: DateComponents(day:3), to: weekStartTime, wrappingComponents: false) as Any)
        let lwed = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@ AND sessionDate <= %@", "lotus", calendar.date(byAdding: DateComponents(day:3), to: weekStartTime, wrappingComponents: false) as Any,calendar.date(byAdding: DateComponents(day:4), to: weekStartTime, wrappingComponents: false) as Any)
        let lthurs = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@ AND sessionDate <= %@", "lotus", calendar.date(byAdding: DateComponents(day:4), to: weekStartTime, wrappingComponents: false) as Any,calendar.date(byAdding: DateComponents(day:5), to: weekStartTime, wrappingComponents: false) as Any)
        let lfri = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@ AND sessionDate <= %@", "lotus", calendar.date(byAdding: DateComponents(day:5), to: weekStartTime, wrappingComponents: false) as Any,calendar.date(byAdding: DateComponents(day:6), to: weekStartTime, wrappingComponents: false) as Any)
        let lsat = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@ AND sessionDate <= %@", "lotus", calendar.date(byAdding: DateComponents(day:6), to: weekStartTime, wrappingComponents: false) as Any,calendar.date(byAdding: DateComponents(day:7), to: weekStartTime, wrappingComponents: false) as Any)
        
        //calculating lotus sunday
        var lotusTimeSun = 0.0
        
        for item in lsun{
            lotusTimeSun += item.lotusTimePlayed
        }
        
        //calculating lotus monday
        var lotusTimeMon = 0.0
        
        for item in lmon{
            lotusTimeMon += item.lotusTimePlayed
        }
        
        //calculating lotus rounds tuesday
        var lotusTimeTues = 0.0
        
        for item in ltues{
            lotusTimeTues += item.lotusTimePlayed
        }
        
        //calculating lotus rounds wednesday
        var lotusTimeWed = 0.0
        
        for item in lwed{
            lotusTimeWed += item.lotusTimePlayed
        }
        
        //calculating lotus rounds thursday
        var lotusTimeThurs = 0.0
        
        for item in lthurs{
            lotusTimeThurs += item.lotusTimePlayed
        }
        
        //calculating lotus rounds friday
        var lotusTimeFri = 0.0
        
        for item in lfri{
            lotusTimeFri += item.lotusTimePlayed
        }
        
        //calculating lotus rounds saturday
        var lotusTimeSat = 0.0
        
        for item in lsat{
            lotusTimeSat += item.lotusTimePlayed
        }
        
        let lotusTimePlayed : [Double] = [
            lotusTimeSun/60, lotusTimeMon/60, lotusTimeTues/60, lotusTimeWed/60, lotusTimeThurs/60, lotusTimeFri/60, lotusTimeSat/60
        ]
        
        
        let gamesInfo = [
            1 : ( gameName: "Breathe Infinite", gameData: breatheITimePlayed, gameColor: UIColor(cgColor: breatheIGraphProgColor), gameGoal: breatheFGoalTime ),
            0 : ( gameName: "Breathe Focus", gameData: breatheFTimePlayed, gameColor: UIColor(cgColor: breatheFGraphProgColor), gameGoal: breatheIGoalTime ),
            2 : ( gameName: "Lotus", gameData: lotusTimePlayed, gameColor: UIColor(cgColor: lotusGraphProgColor), gameGoal: lotusGoalTime )
        ]
        
        let timePlayedChart : LineChart = LineChart(lineChartView: self.homeLineGraph, goalColor: UIColor.red, gamesInfo: gamesInfo)
        
        timePlayedChart.drawWeekGraph()
        
        
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
            self.breatheFMinuteGoalButton.setTitle(String(Int(breatheFTimeToday/60)) + "/" + String(Int(self.breatheFGoalTime)) + "mins", for: .normal)
            self.breatheIMinuteGoalButton.setTitle(String(Int(breatheITimeToday/60)) + "/" + String(Int(self.breatheIGoalTime)) + "mins", for: .normal)
            self.lotusMinuteGoalButton
                .setTitle(String(Int(lotusTimeToday/60)) + "/" + String(Int(self.lotusGoalTime)) + "mins", for: .normal)
            
            breatheFGraphEndAngle = CGFloat((breatheFTimeToday/60)/self.breatheFGoalTime)
            if (breatheFGraphEndAngle == 0){
                breatheFGraphEndAngle = 0.01
            }
            
            breatheIGraphEndAngle = CGFloat((breatheITimeToday/60)/self.breatheIGoalTime)
            if (breatheIGraphEndAngle == 0){
                breatheIGraphEndAngle = 0.01
            }
            
            lotusGraphEndAngle = CGFloat((lotusTimeToday/60)/self.lotusGoalTime)
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
    override func testUserDefaults(){
        let defaults = UserDefaults.standard
        
        // get exp
        exp = defaults.integer(forKey: "exp")
        //get rerolls
        rerolls = defaults.integer(forKey: "rerolls")
        // get nudges
        nudge1.text =  defaults.string(forKey: "dateString0") ?? "No Current Nudge"
        nudge2.text = defaults.string(forKey: "dateString1") ?? "No Current Nudge"
        nudge3.text = defaults.string(forKey: "dateString2") ?? "No Current Nudge"
        nudge4.text = defaults.string(forKey: "dateString3") ?? "No Current Nudge"
        nudge5.text = defaults.string(forKey: "dateString4") ?? "No Current Nudge"
        nudge6.text = defaults.string(forKey: "dateString5") ?? "No Current Nudge"
        
        // get owned pets
        petOwned = defaults.array(forKey: "petOwned") as? [Int] ?? [1]
        
        // get tutorial completed or not
        homeTutorialCompleted = defaults.bool(forKey: "homeTutorialCompleted")

        // get quest
        dailyQuestData = defaults.dictionary(forKey: "dailyQuestData") ?? [:]
        
        // if no quest
        if dailyQuestData.isEmpty{
            generateQuest()
            rerolls = 3
            defaults.set(rerolls, forKey: "rerolls")
            rerollButton.setTitle("Reroll x" + String(rerolls), for: .normal)
        }
        // if new day -> new quest
        else if (dailyQuestData["timeEnd"] as! Date) < today{
            generateQuest()
            rerolls = 3
            defaults.set(rerolls, forKey: "rerolls")
            rerollButton.setTitle("Reroll x" + String(rerolls), for: .normal)
        }
        // else use current quest
        else {
            self.buildQuest()
            rerollButton.setTitle("Reroll x" + String(rerolls), for: .normal)
        }
        
        //get equipped pet
        petEquipped = defaults.integer(forKey: "petEquipped")
        
        // if current quest is/isn't complete show/dont show pet reward
        if (dailyQuestData["complete"] as! Bool){
            //rewardImage.image = UIImage.init(named: petArray[(dailyQuestData["reward"] as! Int) - 1])
        }
        else{
            //rewardImage.image = UIImage.init(named: petArray[(dailyQuestData["reward"] as! Int) - 1] + " shadow")
        }
        
        // get goal times
        breatheFGoalTime = Double(defaults.integer(forKey: "breatheFGoalTime"))
        if breatheFGoalTime == 0{
            breatheFGoalTime = 10
            defaults.set(10, forKey: "breatheFGoalTime")
        }
        breatheIGoalTime = Double(defaults.integer(forKey: "breatheIGoalTime"))
        if breatheIGoalTime == 0{
            breatheIGoalTime = 10
            defaults.set(10, forKey: "breatheIGoalTime")
        }
        lotusGoalTime = Double(defaults.integer(forKey: "lotusGoalTime"))
        if lotusGoalTime == 0{
            lotusGoalTime = 10
            defaults.set(10, forKey: "lotusGoalTime")
        }
        
    }
    
    // -------------------------- QUESTS -------------------------------------
    func generateQuest(){
        let num = Int.random(in: 1 ... 100)//RNG for which quest type appears
        if (num <= 60){//Breathe Focus Quests
            let num2 = Int.random(in: 1 ... 3) // no longer want quest 4
            if (num2 == 1){//BF: Spend x minutes at rate y
                let x = Int.random(in: 4 ... 12) // 5-15
                let y = Int.random(in: 3 ... 7) // 3-8
                dailyQuestData["questType"] = "breathe focus"
                dailyQuestData["questString"] = "Breathe Focus\nPlay for " + String(x) + " minutes with rate set to " + String(y) + " in one session."
                dailyQuestData["timeStart"] = startTime
                dailyQuestData["timeEnd"] = calendar.date(byAdding: .day, value: 1, to: startTime)
                dailyQuestData["reward"] = questRewardGenerator()
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
                let x = Int.random(in: 6 ... 15)
                dailyQuestData["questType"] = "breathe focus"
                dailyQuestData["questString"] = "Breathe Focus\nPlay for " + String(x) + " minutes in one session."
                dailyQuestData["timeStart"] = startTime
                dailyQuestData["timeEnd"] = calendar.date(byAdding: .day, value: 1, to: startTime)
                dailyQuestData["reward"] = questRewardGenerator()
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
                let x = Int.random(in: 2 ... 4)
                let y = Int.random(in: 2 ... 4)
                dailyQuestData["questType"] = "breathe focus"
                dailyQuestData["questString"] = "Breathe Focus\nPlay " + String(x) + " games that last at least " + String(y) + " minutes."
                dailyQuestData["timeStart"] = startTime
                dailyQuestData["timeEnd"] = calendar.date(byAdding: .day, value: 1, to: startTime)
                dailyQuestData["reward"] = questRewardGenerator()
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
//                dailyQuestData["timeStart"] = startTime
//                dailyQuestData["timeEnd"] = calendar.date(byAdding: .day, value: 1, to: startTime)
//                dailyQuestData["reward"] = questRewardGenerator()
//                dailyQuestData["complete"] = false
//                dailyQuestData["exp"] = 20*x
//                dailyQuestData["obj"] = 3
//                dailyQuestData["goalTime"] = x*60
//                saveQuest(progress: false)
//                buildQuest()
//            }
        }
        else if (num <= 75){//BI: Play for x minutes and complete y cycles of rate z
            let x = Int.random(in: 5 ... 10)
            let y = Int.random(in: 3 ... 10)
            let z = Int.random(in: 3 ... 8)
            dailyQuestData["questType"] = "breathe infinite"
            dailyQuestData["questString"] = "Breathe Infinite\nPlay a " + String(x) + "-minute session and complete " + String(y) + " cycles at rate " + String(z) + "."
            dailyQuestData["timeStart"] = startTime
            dailyQuestData["timeEnd"] = calendar.date(byAdding: .day, value: 1, to: startTime)
            dailyQuestData["reward"] = questRewardGenerator()
            dailyQuestData["complete"] = false
            dailyQuestData["exp"] = 10*x*y*z
            dailyQuestData["goalTime"] = x*60
            dailyQuestData["goalNum"] = y
            dailyQuestData["goalCycle"] = z
            saveQuest(progress: false)
            buildQuest()
        }
        else if (num <= 90){//Lotus Quests
            let num2 = Int.random(in: 1 ... 2)
            if (num2 == 1){//L: Play x rounds
                var x = Int.random(in: 5 ... 20)
                x *= 5
                dailyQuestData["questType"] = "lotus"
                dailyQuestData["questString"] = "Lotus\nPlay " + String(x) + " rounds in one session."
                dailyQuestData["timeStart"] = startTime
                dailyQuestData["timeEnd"] = calendar.date(byAdding: .day, value: 1, to: startTime)
                dailyQuestData["reward"] = questRewardGenerator()
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
//                dailyQuestData["timeStart"] = startTime
//                dailyQuestData["timeEnd"] = calendar.date(byAdding: .day, value: 1, to: startTime)
//                dailyQuestData["reward"] = questRewardGenerator()
//                dailyQuestData["complete"] = false
//                dailyQuestData["exp"] = 15*x
//                dailyQuestData["obj"] = 1
//                dailyQuestData["goalNum"] = x
//                dailyQuestData["count"] = 0
//                saveQuest(progress: false)
//                buildQuest()
//            }
            else if (num2 == 2){//L: Play x games
                let x = Int.random(in: 2 ... 3)
                dailyQuestData["questType"] = "lotus"
                dailyQuestData["questString"] = "Lotus\nPlay " + String(x) + " sessions."
                dailyQuestData["timeStart"] = startTime
                dailyQuestData["timeEnd"] = calendar.date(byAdding: .day, value: 1, to: startTime)
                dailyQuestData["reward"] = questRewardGenerator()
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
            let x = Int.random(in: 2 ... 4)
            dailyQuestData["questType"] = "play all"
            dailyQuestData["questString"] = "Play All\nPlay each game for " + String(x) + " minutes in one session each."
            dailyQuestData["timeStart"] = startTime
            dailyQuestData["timeEnd"] = calendar.date(byAdding: .day, value: 1, to: startTime)
            dailyQuestData["reward"] = questRewardGenerator()
            dailyQuestData["complete"] = false
            dailyQuestData["exp"] = 40*x
            dailyQuestData["goal"] = x*60
            dailyQuestData["bfPlayed"] = 0
            dailyQuestData["biPlayed"] = 0
            dailyQuestData["lPlayed"] = 0
            saveQuest(progress: false)
            buildQuest()
        }
        saveToRealm(what: dailyQuestData["questString"] as! String)
    }
    
    func questRewardGenerator() -> Int{
        let companions = Companions()
        let random = companions.generateRandomPet()
        if (random == 0){
            // give exp
        }
        else{ // change mystery pet
            //rewardImage.image = UIImage.init(named: petArray[random - 1] + " shadow")
        }
        return random
    }

}
