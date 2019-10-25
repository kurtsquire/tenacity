//
//  BreatheFocusStatsViewController.swift
//  TenacityV3
//
//  Created by PLL on 7/30/19.
//  Copyright © 2019 PLL. All rights reserved.
//

import UIKit
import RealmSwift
import Charts

class BreatheFocusStatsViewController: PhoneViewController{
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var minuteGoalLabel: UILabel!
    @IBOutlet weak var timePlayedLabel: UILabel!
    @IBOutlet weak var totalBreathsLabel: UILabel!
    @IBOutlet weak var averageBreathLabel: UILabel!
    @IBOutlet weak var setsPlayedLabel: UILabel!
    @IBOutlet weak var breatheFocusLabel: UILabel!
    @IBOutlet weak var totalBreathsLineChart: LineChartView!
    @IBOutlet weak var timePlayedLineChart: LineChartView!
    @IBOutlet weak var avgBreathsLineChart: LineChartView!
    @IBOutlet weak var setsPlayedLineChart: LineChartView!
    
    lazy var breatheFGraphCenter = breatheFocusLabel.center
    
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
        print("viewwillappear")
        refreshRealmData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        timePlayedLineChart.clear( )
        totalBreathsLineChart.clear( )
        setsPlayedLineChart.clear( )
    }
    
    override func viewDidLoad() { //opening app (only triggers when quitting and opening app again)
        super.viewDidLoad()
        
        print("viewdidload")
        // updates date for today
        today = Date()
        startTime = calendar.startOfDay(for: today)
        
        //creates a date at the beginning of the week to compare
        let weekComponents = calendar.dateComponents([.month, .yearForWeekOfYear, .weekOfYear], from: today)
        weekStartTime = calendar.date(from: weekComponents)!
        
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
        
        
//        self.avgBreathsLineChart.gridBackgroundColor = UIColor.white
//        self.avgBreathsLineChart.noDataText = "No data provided"
//        self.avgBreathsLineChart.doubleTapToZoomEnabled = false
//        self.avgBreathsLineChart.xAxis.labelPosition = XAxis.LabelPosition.bottom
//        self.avgBreathsLineChart.highlightPerTapEnabled = false
//        self.avgBreathsLineChart.highlightPerDragEnabled = false
//        self.avgBreathsLineChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: weekDays)
//        self.avgBreathsLineChart.xAxis.granularity = 1
//        self.avgBreathsLineChart.legend.textColor = UIColor.white
//        self.avgBreathsLineChart.xAxis.labelTextColor = UIColor.white
//        self.avgBreathsLineChart.rightAxis.labelTextColor = UIColor.white
//        self.avgBreathsLineChart.leftAxis.labelTextColor = UIColor.white
        
        
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
        print("viewdidappear")
        //refreshRealmData()
    }

    
    // ---------------------- REALM -----------------------------------
    func refreshRealmData(){
        let realm = try! Realm()
        
        let bfx = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@", "breathe focus", startTime)
        let bfw = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@ AND sessionDate <= %@", "breathe focus", weekStartTime, today)
        
        //breathe stats today
        var breatheFBreathsToday = 0
        var breatheFTimeToday = 0.0
        var breatheFCorrectToday = 0
        var breatheFTotalToday = 0
        
        var flengthtotalt = 0.0
        var fsessionst = 0
        for item in bfx{
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
        
        for item in bfw{
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
        
        let bfsun = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@ AND sessionDate <= %@", "breathe focus", weekStartTime,calendar.date(byAdding: DateComponents(day:1), to: weekStartTime, wrappingComponents: false) as Any)
        let bfmon = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@ AND sessionDate <= %@", "breathe focus", calendar.date(byAdding: DateComponents(day:1), to: weekStartTime, wrappingComponents: false) as Any,calendar.date(byAdding: DateComponents(day:2), to: weekStartTime, wrappingComponents: false) as Any)
        let bftues = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@ AND sessionDate <= %@", "breathe focus", calendar.date(byAdding: DateComponents(day:2), to: weekStartTime, wrappingComponents: false) as Any,calendar.date(byAdding: DateComponents(day:3), to: weekStartTime, wrappingComponents: false) as Any)
        let bfwed = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@ AND sessionDate <= %@", "breathe focus", calendar.date(byAdding: DateComponents(day:3), to: weekStartTime, wrappingComponents: false) as Any,calendar.date(byAdding: DateComponents(day:4), to: weekStartTime, wrappingComponents: false) as Any)
        let bfthurs = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@ AND sessionDate <= %@", "breathe focus", calendar.date(byAdding: DateComponents(day:4), to: weekStartTime, wrappingComponents: false) as Any,calendar.date(byAdding: DateComponents(day:5), to: weekStartTime, wrappingComponents: false) as Any)
        let bffri = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@ AND sessionDate <= %@", "breathe focus", calendar.date(byAdding: DateComponents(day:5), to: weekStartTime, wrappingComponents: false) as Any,calendar.date(byAdding: DateComponents(day:6), to: weekStartTime, wrappingComponents: false) as Any)
        let bfsat = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@ AND sessionDate <= %@", "breathe focus", calendar.date(byAdding: DateComponents(day:6), to: weekStartTime, wrappingComponents: false) as Any,calendar.date(byAdding: DateComponents(day:7), to: weekStartTime, wrappingComponents: false) as Any)
        
        
        //breathe stats Sunday
        var breatheFBreathsSunday = 0
        var breatheFTimeSunday = 0.0
        var breatheFCorrectSunday = 0
        var breatheFTotalSunday = 0
        
        var flengthtotalsun = 0.0
        var fsessionssun = 0
        for item in bfsun{
            breatheFTimeSunday += item.breatheFTimePlayed
            
            flengthtotalsun += item.breatheFBreathLength
            if item.breatheFBreathLength > 0{
                fsessionssun += 1
            }
            if item.gameDataType == "stop hold"{
                breatheFBreathsSunday += 1
            }
            breatheFCorrectSunday += item.breatheFCorrectSets
            breatheFTotalSunday += item.breatheFTotalSets
        }
        let breatheFAvgSunday = flengthtotalsun/Double(fsessionssun)
        
        //breathe stats Monday
        var breatheFBreathsMonday = 0
        var breatheFTimeMonday = 0.0
        var breatheFCorrectMonday = 0
        var breatheFTotalMonday = 0
        
        var flengthtotalmon = 0.0
        var fsessionsmon = 0
        for item in bfmon{
            breatheFTimeMonday += item.breatheFTimePlayed
            
            flengthtotalmon += item.breatheFBreathLength
            if item.breatheFBreathLength > 0{
                fsessionsmon += 1
            }
            if item.gameDataType == "stop hold"{
                breatheFBreathsMonday += 1
            }
            breatheFCorrectMonday += item.breatheFCorrectSets
            breatheFTotalMonday += item.breatheFTotalSets
        }
        let breatheFAvgMonday = flengthtotalmon/Double(fsessionsmon)
        
        //breathe stats Tuesday
        var breatheFBreathsTuesday = 0
        var breatheFTimeTuesday = 0.0
        var breatheFCorrectTuesday = 0
        var breatheFTotalTuesday = 0
        
        var flengthtotaltues = 0.0
        var fsessionstues = 0
        for item in bftues{
            breatheFTimeTuesday += item.breatheFTimePlayed
            
            flengthtotaltues += item.breatheFBreathLength
            if item.breatheFBreathLength > 0{
                fsessionstues += 1
            }
            if item.gameDataType == "stop hold"{
                breatheFBreathsTuesday += 1
            }
            breatheFCorrectTuesday += item.breatheFCorrectSets
            breatheFTotalTuesday += item.breatheFTotalSets
        }
        let breatheFAvgTuesday = flengthtotaltues/Double(fsessionstues)
        
        //breathe stats Wednesday
        var breatheFBreathsWednesday = 0
        var breatheFTimeWednesday = 0.0
        var breatheFCorrectWednesday = 0
        var breatheFTotalWednesday = 0
        
        var flengthtotalwed = 0.0
        var fsessionswed = 0
        for item in bfwed{
            breatheFTimeWednesday += item.breatheFTimePlayed
            
            flengthtotalwed += item.breatheFBreathLength
            if item.breatheFBreathLength > 0{
                fsessionswed += 1
            }
            if item.gameDataType == "stop hold"{
                breatheFBreathsWednesday += 1
            }
            breatheFCorrectWednesday += item.breatheFCorrectSets
            breatheFTotalWednesday += item.breatheFTotalSets
        }
        let breatheFAvgWednesday = flengthtotalwed/Double(fsessionswed)
        
        //breathe stats Thursday
        var breatheFBreathsThursday = 0
        var breatheFTimeThursday = 0.0
        var breatheFCorrectThursday = 0
        var breatheFTotalThursday = 0
        
        var flengthtotalthurs = 0.0
        var fsessionsthurs = 0
        for item in bfthurs{
            breatheFTimeThursday += item.breatheFTimePlayed
            
            flengthtotalthurs += item.breatheFBreathLength
            if item.breatheFBreathLength > 0{
                fsessionsthurs += 1
            }
            if item.gameDataType == "stop hold"{
                breatheFBreathsThursday += 1
            }
            breatheFCorrectThursday += item.breatheFCorrectSets
            breatheFTotalThursday += item.breatheFTotalSets
        }
        let breatheFAvgThursday = flengthtotalthurs/Double(fsessionsthurs)
        
        //breathe stats Friday
        var breatheFBreathsFriday = 0
        var breatheFTimeFriday = 0.0
        var breatheFCorrectFriday = 0
        var breatheFTotalFriday = 0
        
        var flengthtotalfri = 0.0
        var fsessionsfri = 0
        for item in bffri{
            breatheFTimeFriday += item.breatheFTimePlayed
            
            flengthtotalfri += item.breatheFBreathLength
            if item.breatheFBreathLength > 0{
                fsessionsfri += 1
            }
            if item.gameDataType == "stop hold"{
                breatheFBreathsFriday += 1
            }
            breatheFCorrectFriday += item.breatheFCorrectSets
            breatheFTotalFriday += item.breatheFTotalSets
        }
        let breatheFAvgFriday = flengthtotalfri/Double(fsessionsfri)
        
        //breathe stats Saturday
        var breatheFBreathsSaturday = 0
        var breatheFTimeSaturday = 0.0
        var breatheFCorrectSaturday = 0
        var breatheFTotalSaturday = 0
        
        var flengthtotalsat = 0.0
        var fsessionssat = 0
        for item in bfsat{
            breatheFTimeSaturday += item.breatheFTimePlayed
            
            flengthtotalsat += item.breatheFBreathLength
            if item.breatheFBreathLength > 0{
                fsessionssat += 1
            }
            if item.gameDataType == "stop hold"{
                breatheFBreathsSaturday += 1
            }
            breatheFCorrectSaturday += item.breatheFCorrectSets
            breatheFTotalSaturday += item.breatheFTotalSets
        }
        let breatheFAvgSaturday = flengthtotalsat/Double(fsessionssat)
        
        let breatheFTimePlayed : [Double] = [breatheFTimeSunday/60, breatheFTimeMonday/60, breatheFTimeTuesday/60, breatheFTimeWednesday/60, breatheFTimeThursday/60, breatheFTimeFriday/60, breatheFTimeSaturday/60]
        let breatheFTotalBreaths : [Double] = [Double(breatheFBreathsSunday), Double(breatheFBreathsMonday), Double(breatheFBreathsTuesday), Double(breatheFBreathsWednesday), Double(breatheFBreathsThursday), Double(breatheFBreathsFriday), Double(breatheFBreathsSaturday)]
        let breatheFAvgBreaths : [Double] = [breatheFAvgSunday, breatheFAvgMonday, breatheFAvgTuesday, breatheFAvgWednesday, breatheFAvgThursday, breatheFAvgFriday, breatheFAvgSaturday]
        let breatheFSetsPlayed : [Double] = [Double(fsessionssun), Double(fsessionsmon), Double(fsessionstues), Double(fsessionswed), Double(fsessionsthurs), Double(fsessionsfri), Double(fsessionssat)]
        
        let timePlayed = [
            0 : (gameName: "Time Played", gameData: breatheFTimePlayed, gameColor: UIColor(cgColor: breatheFGraphProgColor), gameGoal: breatheFGoalTime)
        ]
        let totalBreaths = [
            0 : (gameName: "Total Breaths", gameData: breatheFTotalBreaths, gameColor: UIColor(cgColor: breatheFGraphProgColor), gameGoal: breatheFGoalTime)
        ]
        let avgBreaths = [
            0 : (gameName: "Average Breaths", gameData: breatheFAvgBreaths, gameColor: UIColor(cgColor: breatheFGraphProgColor), gameGoal: breatheFGoalTime)
        ]
        let setsPlayed = [
            0 : (gameName: "Sets Played", gameData: breatheFSetsPlayed, gameColor: UIColor(cgColor: breatheFGraphProgColor), gameGoal: breatheFGoalTime)
        ]
        
        
        let timePlayedChart : LineChart = LineChart(lineChartView: self.timePlayedLineChart, goalColor: UIColor.red, gamesInfo: timePlayed)
        
        timePlayedChart.drawGoalGraph(gameNum: 0)
        
        
        let totalBreathsChart : LineChart = LineChart(lineChartView: self.totalBreathsLineChart, goalColor: UIColor.red, gamesInfo: totalBreaths)
        
        totalBreathsChart.drawWeekGraph()
        
        
        //        let avgBreathsChart : LineChart = LineChart(lineChartView: self.avgBreathsLineChart, goalColor: UIColor.red, gamesInfo: avgBreaths)
        //
        //        avgBreathsChart.drawWeekGraph()
        
        
        let setsPlayedChart : LineChart = LineChart(lineChartView: self.setsPlayedLineChart, goalColor: UIColor.red, gamesInfo: setsPlayed)
        
        setsPlayedChart.drawWeekGraph()
        
        DispatchQueue.main.async {
            self.minuteGoalLabel.text = String(Int(breatheFTimeToday/60)) + "/" + String(Int(breatheFGoalTime)) + "mins"
            
            
            breatheFGraphEndAngle = CGFloat((breatheFTimeToday/60)/breatheFGoalTime)
            if (breatheFGraphEndAngle == 0){
                breatheFGraphEndAngle = 0.01
            }
            let breatheFCircleGraph = CircleChart(radius: circleGraphRadius, progressEndAngle: breatheFGraphEndAngle, center: self.breatheFGraphCenter, lineWidth: circleGraphWidth, outlineColor: breatheFGraphOutColor, progressColor: breatheFGraphProgColor)
            self.mainView.layer.addSublayer(breatheFCircleGraph.outlineLayer)
            self.mainView.layer.addSublayer(breatheFCircleGraph.progressLayer)
        }
    }
    
}
