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
    
    lazy var breatheIGraphCenter = breatheInfiniteLabel.center
    
    var gamesInfo = [
        1 : ( gameName: "Breathe Flow", gameData: expFlow, gameColor: UIColor(cgColor: breatheFGraphProgColor), gameGoal: 20.00 ),
        0 : ( gameName: "Breathe Focus", gameData: expFocus, gameColor: UIColor(cgColor: breatheIGraphProgColor), gameGoal: 22.50 ),
        2 : ( gameName: "Lotus", gameData: expLotus, gameColor: UIColor(cgColor: lotusGraphProgColor), gameGoal: 30.00 )
    ]
    
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
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // adds top bar back before we leave
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
        let timePlayedChart : LineChart = LineChart(lineChartView: timePlayedLineChart, goalColor: UIColor.red, gamesInfo: gamesInfo)
        
        timePlayedChart.drawGoalGraph(gameNum: 0)
        
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
        let totalBreathsChart : LineChart = LineChart(lineChartView: totalBreathsLineChart, goalColor: UIColor.red, gamesInfo: gamesInfo)
        
        totalBreathsChart.drawGoalGraph(gameNum: 1)
        
        self.avgBreathsLineChart.gridBackgroundColor = UIColor.white
        
        self.avgBreathsLineChart.noDataText = "No data provided"
        
        self.avgBreathsLineChart.doubleTapToZoomEnabled = false
        
        self.avgBreathsLineChart.xAxis.labelPosition = XAxis.LabelPosition.bottom
        
        self.avgBreathsLineChart.highlightPerTapEnabled = false
        self.avgBreathsLineChart.highlightPerDragEnabled = false
        
        self.avgBreathsLineChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: weekDays)
        
        self.avgBreathsLineChart.xAxis.granularity = 1
        self.avgBreathsLineChart.legend.textColor = UIColor.white
        self.avgBreathsLineChart.xAxis.labelTextColor = UIColor.white
        self.avgBreathsLineChart.rightAxis.labelTextColor = UIColor.white
        self.avgBreathsLineChart.leftAxis.labelTextColor = UIColor.white
        let avgBreathsChart : LineChart = LineChart(lineChartView: avgBreathsLineChart, goalColor: UIColor.red, gamesInfo: gamesInfo)
        
        avgBreathsChart.drawGoalGraph(gameNum: 1)
        
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
        let setsPlayedChart : LineChart = LineChart(lineChartView: setsPlayedLineChart, goalColor: UIColor.red, gamesInfo: gamesInfo)
        
        setsPlayedChart.drawGoalGraph(gameNum: 1)
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
        
        DispatchQueue.main.async {
            self.minuteGoalLabel.text = String(Int(breatheITimeToday/60)) + "/" + String(Int(breatheIGoalTime)) + "mins"
//            self.timePlayedLabel.text = "Week: " + String(Int(breatheITimeWeek/60)) + " min" + "\nToday: " + String(Int(breatheITimeToday)) + " secs"
//            self.totalBreathsTakenLabel.text = "Week: " + String(breatheIBreathsWeek) + "\nToday: " + String(breatheIBreathsToday)
//            self.averageBreathLengthLabel.text = "Week: " + String(breatheIAvgWeek) + "\nToday: " + String(breatheIAvgToday)
//            self.setsPlayedLabel.text = "Today:" + String(breatheITotalToday) + "\nThis Week: " + String(breatheITotalWeek)
//            var a = "Breath Cycles  (Length: how many you have done)\n"
//            for i in 0..<cyclesTodayArray.count{
//                a += String(i) + ": " + String(cyclesTodayArray[i]) + ", "
//            }
//            self.cyclesLabel.text = a
            
            breatheIGraphEndAngle = CGFloat((breatheITimeToday/60)/breatheIGoalTime)
            if (breatheIGraphEndAngle == 0){
                breatheIGraphEndAngle = 0.01
            }
            let breatheICircleGraph = CircleChart(radius: circleGraphRadius, progressEndAngle: breatheIGraphEndAngle, center: self.breatheIGraphCenter, lineWidth: circleGraphWidth, outlineColor: breatheIGraphOutColor, progressColor: breatheIGraphProgColor)
            self.mainView.layer.addSublayer(breatheICircleGraph.outlineLayer)
            self.mainView.layer.addSublayer(breatheICircleGraph.progressLayer)
        }
    }
}
