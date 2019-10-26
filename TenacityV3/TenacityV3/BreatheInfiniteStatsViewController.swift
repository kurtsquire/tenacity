//
//  BreatheInfiniteStatsViewController.swift
//  TenacityV3
//
//  Created by PLL on 7/30/19.
//  Copyright © 2019 PLL. All rights reserved.
//

import UIKit
import RealmSwift
import Charts

class BreatheInfiniteStatsViewController: PhoneViewController{
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var minuteGoalLabel: UILabel!
    @IBOutlet weak var timePlayedLabel: UILabel!
    @IBOutlet weak var totalBreathsTakenLabel: UILabel!
    @IBOutlet weak var averageBreathLengthLabel: UILabel!
    @IBOutlet weak var setsPlayedLabel: UILabel!
    @IBOutlet weak var cyclesLabel: UILabel!
    @IBOutlet weak var breatheInfiniteLabel: UILabel!
    @IBOutlet weak var timePlayedLineChart: LineChartView!
    @IBOutlet weak var totalBreathsLineChart: LineChartView!
    @IBOutlet weak var avgBreathsLineChart: LineChartView!
    @IBOutlet weak var setsPlayedLineChart: LineChartView!
    
    var breatheIGoalTime = 0.0
    
    lazy var breatheIGraphCenter = breatheInfiniteLabel.center
    
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
        // adds top bar back before we leave
        
        timePlayedLineChart.clear( )
        totalBreathsLineChart.clear( )
        setsPlayedLineChart.clear( )
        
        //navigationController?.setNavigationBarHidden(false, animated: false)
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
        
        
        self.totalBreathsLineChart.gridBackgroundColor = UIColor.white
        
        self.totalBreathsLineChart.noDataText = "No data provided"
        
        self.totalBreathsLineChart.doubleTapToZoomEnabled = false
        
        self.totalBreathsLineChart.xAxis.labelPosition = XAxis.LabelPosition.bottom
        
        self.totalBreathsLineChart.highlightPerTapEnabled = false
        self.totalBreathsLineChart.highlightPerDragEnabled = false
        
        self.totalBreathsLineChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: weekDays)
        
        self.totalBreathsLineChart.xAxis.granularity = 1
        self.totalBreathsLineChart.legend.textColor = UIColor.white
        self.totalBreathsLineChart.xAxis.labelTextColor = UIColor.white
        self.totalBreathsLineChart.rightAxis.labelTextColor = UIColor.white
        self.totalBreathsLineChart.leftAxis.labelTextColor = UIColor.white
        
        self.setsPlayedLineChart.gridBackgroundColor = UIColor.white
        
        self.setsPlayedLineChart.noDataText = "No data provided"
        
        self.setsPlayedLineChart.doubleTapToZoomEnabled = false
        
        self.setsPlayedLineChart.xAxis.labelPosition = XAxis.LabelPosition.bottom
        
        self.setsPlayedLineChart.highlightPerTapEnabled = false
        self.setsPlayedLineChart.highlightPerDragEnabled = false
        
        self.setsPlayedLineChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: weekDays)
        
        self.setsPlayedLineChart.xAxis.granularity = 1
        self.setsPlayedLineChart.legend.textColor = UIColor.white
        self.setsPlayedLineChart.xAxis.labelTextColor = UIColor.white
        self.setsPlayedLineChart.rightAxis.labelTextColor = UIColor.white
        self.setsPlayedLineChart.leftAxis.labelTextColor = UIColor.white
    }
    
    override func viewDidAppear(_ animated: Bool) { //openign back up the tab (works from other tabs)
        super.viewDidAppear(animated)
        
        //refreshRealmData()
    }
    
    
    func refreshRealmData(){
        let realm = try! Realm()
        
        let biw = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@", "breathe infinite", weekStartTime)
        let bix = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@", "breathe infinite", startTime)
        
        //breathe Infinite stats today
        var breatheIBreathsToday = 0
        var breatheITimeToday = 0.0
        var breatheITotalToday = 0
        
        var ilengthtotalt = 0.0
        var isessionst = 0
        
        var cyclesTodayArray = [0,0,0,0,0,0,0,0,0,0,0]
        
        for item in bix{
            breatheITimeToday += item.breatheITimePlayed
            ilengthtotalt += item.breatheIBreathLength
            if item.breatheIBreathLength > 0{
                isessionst += 1
            }
            if item.gameDataType == "stop hold"{
                breatheIBreathsToday += 1
            }
            breatheITotalToday += item.breatheITotalSets
            
            for i in 0..<item.breatheICycleList.count{
                cyclesTodayArray[i] += item.breatheICycleList[i]
            }
        }
        
        let breatheIAvgToday = ilengthtotalt/Double(isessionst)
        
        //breathe Infinite stats week
        var breatheIBreathsWeek = 0
        var breatheITimeWeek = 0.0
        var breatheITotalWeek = 0
        
        var ilengthtotalw = 0.0
        var isessionsw = 0
        for item in biw{
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
        
        let bisun = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@ AND sessionDate <= %@", "breathe infinite", weekStartTime,calendar.date(byAdding: DateComponents(day:1), to: weekStartTime, wrappingComponents: false) as Any)
        let bimon = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@ AND sessionDate <= %@", "breathe infinite", calendar.date(byAdding: DateComponents(day:1), to: weekStartTime, wrappingComponents: false) as Any,calendar.date(byAdding: DateComponents(day:2), to: weekStartTime, wrappingComponents: false) as Any)
        let bitues = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@ AND sessionDate <= %@", "breathe infinite", calendar.date(byAdding: DateComponents(day:2), to: weekStartTime, wrappingComponents: false) as Any,calendar.date(byAdding: DateComponents(day:3), to: weekStartTime, wrappingComponents: false) as Any)
        let biwed = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@ AND sessionDate <= %@", "breathe infinite", calendar.date(byAdding: DateComponents(day:3), to: weekStartTime, wrappingComponents: false) as Any,calendar.date(byAdding: DateComponents(day:4), to: weekStartTime, wrappingComponents: false) as Any)
        let bithurs = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@ AND sessionDate <= %@", "breathe infinite", calendar.date(byAdding: DateComponents(day:4), to: weekStartTime, wrappingComponents: false) as Any,calendar.date(byAdding: DateComponents(day:5), to: weekStartTime, wrappingComponents: false) as Any)
        let bifri = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@ AND sessionDate <= %@", "breathe infinite", calendar.date(byAdding: DateComponents(day:5), to: weekStartTime, wrappingComponents: false) as Any,calendar.date(byAdding: DateComponents(day:6), to: weekStartTime, wrappingComponents: false) as Any)
        let bisat = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@ AND sessionDate <= %@", "breathe infinite", calendar.date(byAdding: DateComponents(day:6), to: weekStartTime, wrappingComponents: false) as Any,calendar.date(byAdding: DateComponents(day:7), to: weekStartTime, wrappingComponents: false) as Any)
        
        //breathe stats Sunday
        var breatheIBreathsSunday = 0
        var breatheITimeSunday = 0.0
        var breatheITotalSunday = 0
        
        var flengthtotalsun = 0.0
        var fsessionssun = 0
        for item in bisun{
            breatheITimeSunday += item.breatheITimePlayed
            
            flengthtotalsun += item.breatheIBreathLength
            if item.breatheIBreathLength > 0{
                fsessionssun += 1
            }
            if item.gameDataType == "stop hold"{
                breatheIBreathsSunday += 1
            }
            breatheITotalSunday += item.breatheITotalSets
        }
        let breatheIAvgSunday = flengthtotalsun/Double(fsessionssun)
        
        //breathe stats Monday
        var breatheIBreathsMonday = 0
        var breatheITimeMonday = 0.0
        var breatheITotalMonday = 0
        
        var flengthtotalmon = 0.0
        var fsessionsmon = 0
        for item in bimon{
            breatheITimeMonday += item.breatheITimePlayed
            
            flengthtotalmon += item.breatheIBreathLength
            if item.breatheIBreathLength > 0{
                fsessionsmon += 1
            }
            if item.gameDataType == "stop hold"{
                breatheIBreathsMonday += 1
            }
            breatheITotalMonday += item.breatheITotalSets
        }
        let breatheIAvgMonday = flengthtotalmon/Double(fsessionsmon)
        
        //breathe stats Tuesday
        var breatheIBreathsTuesday = 0
        var breatheITimeTuesday = 0.0
        var breatheITotalTuesday = 0
        
        var flengthtotaltues = 0.0
        var fsessionstues = 0
        for item in bitues{
            breatheITimeTuesday += item.breatheITimePlayed
            
            flengthtotaltues += item.breatheIBreathLength
            if item.breatheIBreathLength > 0{
                fsessionstues += 1
            }
            if item.gameDataType == "stop hold"{
                breatheIBreathsTuesday += 1
            }
            breatheITotalTuesday += item.breatheITotalSets
        }
        let breatheIAvgTuesday = flengthtotaltues/Double(fsessionstues)
        
        //breathe stats Wednesday
        var breatheIBreathsWednesday = 0
        var breatheITimeWednesday = 0.0
        var breatheITotalWednesday = 0
        
        var flengthtotalwed = 0.0
        var fsessionswed = 0
        for item in biwed{
            breatheITimeWednesday += item.breatheITimePlayed
            
            flengthtotalwed += item.breatheIBreathLength
            if item.breatheIBreathLength > 0{
                fsessionswed += 1
            }
            if item.gameDataType == "stop hold"{
                breatheIBreathsWednesday += 1
            }
            breatheITotalWednesday += item.breatheITotalSets
        }
        let breatheIAvgWednesday = flengthtotalwed/Double(fsessionswed)
        
        //breathe stats Thursday
        var breatheIBreathsThursday = 0
        var breatheITimeThursday = 0.0
        var breatheITotalThursday = 0
        
        var flengthtotalthurs = 0.0
        var fsessionsthurs = 0
        for item in bithurs{
            breatheITimeThursday += item.breatheITimePlayed
            
            flengthtotalthurs += item.breatheIBreathLength
            if item.breatheIBreathLength > 0{
                fsessionsthurs += 1
            }
            if item.gameDataType == "stop hold"{
                breatheIBreathsThursday += 1
            }
            breatheITotalThursday += item.breatheITotalSets
        }
        let breatheIAvgThursday = flengthtotalthurs/Double(fsessionsthurs)
        
        //breathe stats Friday
        var breatheIBreathsFriday = 0
        var breatheITimeFriday = 0.0
        var breatheITotalFriday = 0
        
        var flengthtotalfri = 0.0
        var fsessionsfri = 0
        for item in bifri{
            breatheITimeFriday += item.breatheITimePlayed
            
            flengthtotalfri += item.breatheIBreathLength
            if item.breatheIBreathLength > 0{
                fsessionsfri += 1
            }
            if item.gameDataType == "stop hold"{
                breatheIBreathsFriday += 1
            }
            breatheITotalFriday += item.breatheITotalSets
        }
        let breatheIAvgFriday = flengthtotalfri/Double(fsessionsfri)
        
        //breathe stats Saturday
        var breatheIBreathsSaturday = 0
        var breatheITimeSaturday = 0.0
        var breatheITotalSaturday = 0
        
        var flengthtotalsat = 0.0
        var fsessionssat = 0
        for item in bisat{
            breatheITimeSaturday += item.breatheITimePlayed
            
            flengthtotalsat += item.breatheIBreathLength
            if item.breatheIBreathLength > 0{
                fsessionssat += 1
            }
            if item.gameDataType == "stop hold"{
                breatheIBreathsSaturday += 1
            }
            breatheITotalSaturday += item.breatheITotalSets
        }
        let breatheIAvgSaturday = flengthtotalsat/Double(fsessionssat)
        
        let breatheITimePlayed : [Double] = [breatheITimeSunday/60, breatheITimeMonday/60, breatheITimeTuesday/60, breatheITimeWednesday/60, breatheITimeThursday/60, breatheITimeFriday/60, breatheITimeSaturday/60]
        let breatheITotalBreaths : [Double] = [Double(breatheIBreathsSunday), Double(breatheIBreathsMonday), Double(breatheIBreathsTuesday), Double(breatheIBreathsWednesday), Double(breatheIBreathsThursday), Double(breatheIBreathsFriday), Double(breatheIBreathsSaturday)]
        let breatheIAvgBreaths : [Double] = [breatheIAvgSunday, breatheIAvgMonday, breatheIAvgTuesday, breatheIAvgWednesday, breatheIAvgThursday, breatheIAvgFriday, breatheIAvgSaturday]
        let breatheISetsPlayed : [Double] = [Double(fsessionssun), Double(fsessionsmon), Double(fsessionstues), Double(fsessionswed), Double(fsessionsthurs), Double(fsessionsfri), Double(fsessionssat)]
        
        let timePlayed = [
            0 : (gameName: "Time Played", gameData: breatheITimePlayed, gameColor: UIColor(cgColor: breatheIGraphProgColor), gameGoal: breatheIGoalTime)
        ]
        let totalBreaths = [
            0 : (gameName: "Total Breaths", gameData: breatheITotalBreaths, gameColor: UIColor(cgColor: breatheIGraphProgColor), gameGoal: breatheIGoalTime)
        ]
        let avgBreaths = [
            0 : (gameName: "Average Breaths", gameData: breatheIAvgBreaths, gameColor: UIColor(cgColor: breatheIGraphProgColor), gameGoal: breatheIGoalTime)
        ]
        let setsPlayed = [
            0 : (gameName: "Sets Played", gameData: breatheISetsPlayed, gameColor: UIColor(cgColor: breatheIGraphProgColor), gameGoal: breatheIGoalTime)
        ]
        
        
        let timePlayedChart : LineChart = LineChart(lineChartView: self.timePlayedLineChart, goalColor: UIColor.red, gamesInfo: timePlayed)
        
        timePlayedChart.drawGoalGraph(gameNum: 0)
        
        
        let totalBreathsChart : LineChart = LineChart(lineChartView: self.totalBreathsLineChart, goalColor: UIColor.red, gamesInfo: totalBreaths)
        
        totalBreathsChart.drawWeekGraph()
        
        let setsPlayedChart : LineChart = LineChart(lineChartView: self.setsPlayedLineChart, goalColor: UIColor.red, gamesInfo: setsPlayed)
        
        setsPlayedChart.drawWeekGraph()
        
        DispatchQueue.main.async {
            
            self.minuteGoalLabel.text = String(Int(breatheITimeToday/60)) + "/" + String(Int(self.breatheIGoalTime)) + "mins"
            
            
            breatheIGraphEndAngle = CGFloat((breatheITimeToday/60)/self.breatheIGoalTime)
            if (breatheIGraphEndAngle == 0){
                breatheIGraphEndAngle = 0.01
            }
            let breatheICircleGraph = CircleChart(radius: circleGraphRadius, progressEndAngle: breatheIGraphEndAngle, center: self.breatheIGraphCenter, lineWidth: circleGraphWidth, outlineColor: breatheIGraphOutColor, progressColor: breatheIGraphProgColor)
            self.mainView.layer.addSublayer(breatheICircleGraph.outlineLayer)
            self.mainView.layer.addSublayer(breatheICircleGraph.progressLayer)
        }
    }
    
    override func testUserDefaults() {
        // get goal times
        breatheIGoalTime = Double(UserDefaults.standard.integer(forKey: "breatheIGoalTime"))
    }
}
