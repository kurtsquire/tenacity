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
    
    // ---------------------- REALM -----------------------------------
    func refreshRealmData(){
        let realm = try! Realm()
        
        let bfx = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@", "breathe focus", startTime)
        let bfw = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@", "breathe focus", weekStartTime)
        
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
        
        DispatchQueue.main.async {
            self.minuteGoalLabel.text = String(Int(breatheFTimeToday/60)) + "/" + String(Int(breatheFGoalTime)) + "mins"
//            self.timePlayedLabel.text = "Week: " + String(Int(breatheFTimeWeek/60)) + " mins" + "\nToday: " + String(Int(breatheFTimeToday)) + " secs"
//            self.totalBreathsLabel.text = "Week: " + String(breatheFBreathsWeek) + "\nToday: " + String(breatheFBreathsToday)
//            self.averageBreathLabel.text = "Week: " + String(breatheFAvgWeek) + "\nToday: " + String(breatheFAvgToday)
//            self.setsPlayedLabel.text = "Today:\nCorrect Sets: " + String(breatheFCorrectToday) + "\nTotal Sets: " + String(breatheFTotalToday) + "\nThis Week:\nCorrect Sets: " + String(breatheFCorrectWeek) + "\nTotal Sets: " + String(breatheFTotalWeek)
            
            
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
