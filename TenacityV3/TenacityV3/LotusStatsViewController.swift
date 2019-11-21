//
//  LotusStatsViewController.swift
//  TenacityV3
//
//  Created by PLL on 7/30/19.
//  Copyright © 2019 PLL. All rights reserved.
//

import UIKit
import RealmSwift
import Charts

class LotusStatsViewController: PhoneViewController{
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var minuteGoalLabel: UILabel!
    @IBOutlet weak var timePlayedLabel: UILabel!
    @IBOutlet weak var roundsPlayedLabel: UILabel!
    @IBOutlet weak var swipesLabel: UILabel!
    @IBOutlet weak var lotusSwipeLabel: UILabel!
    @IBOutlet weak var timePlayedLineChart: LineChartView!
    @IBOutlet weak var totalRoundsLineChart: LineChartView!
    
    var lotusGoalTime = 0.0
    
    lazy var lotusGraphCenter = lotusSwipeLabel.center
    
    @IBOutlet weak var lotusMinuteGoalButton: UIButton!
    @IBAction func lotusGoalButtonPressed(_ sender: Any) {
        currentGame = "lotus"
    }
    
    // ------------------------- TIME ----------------------------------
    var calendar = Calendar.autoupdatingCurrent
    var today = Date()
    var startTime = Date()
    var weekStartTime = Date()
    
    // changes the top font to white (time and battery life wifi etc)
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // takes out top bar
        navigationController?.setNavigationBarHidden(true, animated: false)
        refreshRealmData()
        testUserDefaults()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        timePlayedLineChart.clear( )
        totalRoundsLineChart.clear( )
    }
    
    override func viewDidLoad() { //opening app (only triggers when quitting and opening app again)
        super.viewDidLoad()
        
        // updates date for today
        today = Date()
        startTime = calendar.startOfDay(for: today)
        
        //creates a date at the beginning of the week to compare
        let weekComponents = calendar.dateComponents([.month, .yearForWeekOfYear, .weekOfYear], from: today)
        weekStartTime = calendar.date(from: weekComponents)!
        
        refreshRealmData()
        testUserDefaults()
        
        // ---------------------- LINES -----------------------------------
        
        self.timePlayedLineChart.gridBackgroundColor = UIColor.white
        
        self.timePlayedLineChart.noDataText = "No data provided"
        
        self.timePlayedLineChart.doubleTapToZoomEnabled = false
        
        self.timePlayedLineChart.xAxis.labelPosition = XAxis.LabelPosition.bottom
        
        self.timePlayedLineChart.highlightPerTapEnabled = false
        self.timePlayedLineChart.highlightPerDragEnabled = false
        
        self.timePlayedLineChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: weekDays)
        
        self.timePlayedLineChart.xAxis.granularity = 1
        self.timePlayedLineChart.legend.textColor = UIColor.white
        self.timePlayedLineChart.xAxis.labelTextColor = UIColor.white
        self.timePlayedLineChart.rightAxis.labelTextColor = UIColor.white
        self.timePlayedLineChart.leftAxis.labelTextColor = UIColor.white
        
        
        self.totalRoundsLineChart.gridBackgroundColor = UIColor.white
        
        self.totalRoundsLineChart.noDataText = "No data provided"
        
        self.totalRoundsLineChart.doubleTapToZoomEnabled = false
        
        self.totalRoundsLineChart.xAxis.labelPosition = XAxis.LabelPosition.bottom
        
        self.totalRoundsLineChart.highlightPerTapEnabled = false
        self.totalRoundsLineChart.highlightPerDragEnabled = false
        
        self.totalRoundsLineChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: weekDays)
        
        self.totalRoundsLineChart.xAxis.granularity = 1
        self.totalRoundsLineChart.legend.textColor = UIColor.white
        self.totalRoundsLineChart.xAxis.labelTextColor = UIColor.white
        self.totalRoundsLineChart.rightAxis.labelTextColor = UIColor.white
        self.totalRoundsLineChart.leftAxis.labelTextColor = UIColor.white
        
    }
    
    override func viewDidAppear(_ animated: Bool) { //openign back up the tab (works from other tabs)
        super.viewDidAppear(animated)
        
        //refreshRealmData()
    }
    
    
    func refreshRealmData(){
        let realm = try! Realm()
        
        let lw = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@", "lotus", weekStartTime)
        let lx = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@", "lotus", startTime)
        
        print("something")
        print(lw)
        var lotusRoundsToday = 0
        var lotusRoundsWeek = 0
        var lotusTimeToday = 0.0
        var lotusTimeWeek = 0.0
        var lotusArrayToday = [0,0,0,0]
        
        //calculating lotus rounds today
        for item in lx{
            lotusRoundsToday += item.lotusRoundsPlayed
            lotusTimeToday += item.lotusTimePlayed
            for i in 0..<item.lotusCorrectList.count{
                lotusArrayToday[i] += item.lotusCorrectList[i]
            }
        }
        //calculating lotus rounds this week
        for item in lw{
            lotusRoundsWeek += item.lotusRoundsPlayed
            lotusTimeWeek += item.lotusTimePlayed
        }
        
        let lsun = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@ AND sessionDate <= %@", "lotus", weekStartTime,calendar.date(byAdding: DateComponents(day:1), to: weekStartTime, wrappingComponents: false) as Any)
        let lmon = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@ AND sessionDate <= %@", "lotus", calendar.date(byAdding: DateComponents(day:1), to: weekStartTime, wrappingComponents: false) as Any,calendar.date(byAdding: DateComponents(day:2), to: weekStartTime, wrappingComponents: false) as Any)
        let ltues = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@ AND sessionDate <= %@", "lotus", calendar.date(byAdding: DateComponents(day:2), to: weekStartTime, wrappingComponents: false) as Any,calendar.date(byAdding: DateComponents(day:3), to: weekStartTime, wrappingComponents: false) as Any)
        let lwed = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@ AND sessionDate <= %@", "lotus", calendar.date(byAdding: DateComponents(day:3), to: weekStartTime, wrappingComponents: false) as Any,calendar.date(byAdding: DateComponents(day:4), to: weekStartTime, wrappingComponents: false) as Any)
        let lthurs = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@ AND sessionDate <= %@", "lotus", calendar.date(byAdding: DateComponents(day:4), to: weekStartTime, wrappingComponents: false) as Any,calendar.date(byAdding: DateComponents(day:5), to: weekStartTime, wrappingComponents: false) as Any)
        let lfri = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@ AND sessionDate <= %@", "lotus", calendar.date(byAdding: DateComponents(day:5), to: weekStartTime, wrappingComponents: false) as Any,calendar.date(byAdding: DateComponents(day:6), to: weekStartTime, wrappingComponents: false) as Any)
        let lsat = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@ AND sessionDate <= %@", "lotus", calendar.date(byAdding: DateComponents(day:6), to: weekStartTime, wrappingComponents: false) as Any,calendar.date(byAdding: DateComponents(day:7), to: weekStartTime, wrappingComponents: false) as Any)
        
        print("lololol")
        print(lsun)
        
        print("lololol")
        print(lsat)
        
        //calculating lotus rounds sunday
        var lotusRoundsSun = 0
        var lotusTimeSun = 0.0
        
        for item in lsun{
            lotusRoundsSun += item.lotusRoundsPlayed
            lotusTimeSun += item.lotusTimePlayed
        }
        
        //calculating lotus rounds monday
        var lotusRoundsMon = 0
        var lotusTimeMon = 0.0
        
        for item in lmon{
            lotusRoundsMon += item.lotusRoundsPlayed
            lotusTimeMon += item.lotusTimePlayed
        }
        
        //calculating lotus rounds tuesday
        var lotusRoundsTues = 0
        var lotusTimeTues = 0.0
        
        for item in ltues{
            lotusRoundsTues += item.lotusRoundsPlayed
            lotusTimeTues += item.lotusTimePlayed
        }
        
        //calculating lotus rounds wednesday
        var lotusRoundsWed = 0
        var lotusTimeWed = 0.0
        
        for item in lwed{
            lotusRoundsWed += item.lotusRoundsPlayed
            lotusTimeWed += item.lotusTimePlayed
        }
        
        //calculating lotus rounds thursday
        var lotusRoundsThurs = 0
        var lotusTimeThurs = 0.0
        
        for item in lthurs{
            lotusRoundsThurs += item.lotusRoundsPlayed
            lotusTimeThurs += item.lotusTimePlayed
        }
        
        //calculating lotus rounds friday
        var lotusRoundsFri = 0
        var lotusTimeFri = 0.0
        
        for item in lfri{
            lotusRoundsFri += item.lotusRoundsPlayed
            lotusTimeFri += item.lotusTimePlayed
        }
        
        //calculating lotus rounds saturday
        var lotusRoundsSat = 0
        var lotusTimeSat = 0.0
        
        for item in lsat{
            lotusRoundsSat += item.lotusRoundsPlayed
            lotusTimeSat += item.lotusTimePlayed
        }
        
        let lotusTimePlayed : [Double] = [
            lotusTimeSun/60, lotusTimeMon/60, lotusTimeTues/60, lotusTimeWed/60, lotusTimeThurs/60, lotusTimeFri/60, lotusTimeSat/60
        ]
        let lotusRoundsPlayed : [Double] = [
            Double(lotusRoundsSun), Double(lotusRoundsMon), Double(lotusRoundsTues), Double(lotusRoundsWed), Double(lotusRoundsThurs), Double(lotusRoundsFri), Double(lotusRoundsSat)
        ]
        
        let timePlayed = [
            0 : (gameName: "Time Played", gameData: lotusTimePlayed, gameColor: UIColor(cgColor: lotusGraphProgColor), gameGoal: lotusGoalTime)
        ]
        let roundsPlayed = [
            0 : (gameName: "Rounds Played", gameData: lotusRoundsPlayed, gameColor: UIColor(cgColor: lotusGraphProgColor), gameGoal: lotusGoalTime)
        ]
        
        print("foo")
        print(timePlayed)
        print("bar")
        print(roundsPlayed)
        
        let timePlayedChart : LineChart = LineChart(lineChartView: self.timePlayedLineChart, goalColor: UIColor.red, gamesInfo: timePlayed)
        
        timePlayedChart.drawGoalGraph(gameNum: 0)
        
        
        let roundsPlayedChart : LineChart = LineChart(lineChartView: self.totalRoundsLineChart, goalColor: UIColor.red, gamesInfo: roundsPlayed)
        
        roundsPlayedChart.drawWeekGraph()
        
        //        let timePlayed = [
        //            0 : (
        //        ]
        
        DispatchQueue.main.async {
            
            self.lotusMinuteGoalButton
            .setTitle(String(Int(lotusTimeToday/60)) + "/" + String(Int(self.lotusGoalTime)) + "mins", for: .normal)

            var a = ""
                        for i in 0..<lotusArrayToday.count{
                            a += String(i) + " wrong: " + String(lotusArrayToday[i]) + "\n"
                        }
                        self.swipesLabel.text = a
            
            let lotusCircleGraph = CircleChart(radius: circleGraphRadius, progressEndAngle: lotusGraphEndAngle, center: self.lotusGraphCenter, lineWidth: circleGraphWidth, outlineColor: lotusGraphOutColor, progressColor: lotusGraphProgColor)
            self.mainView.layer.addSublayer(lotusCircleGraph.outlineLayer)
            self.mainView.layer.addSublayer(lotusCircleGraph.progressLayer)
        }
        
    }
    
    override func testUserDefaults() {
        // get goal times
        lotusGoalTime = Double(UserDefaults.standard.integer(forKey: "lotusGoalTime"))
    }
    
}
