//
//  BreatheInfiniteStatsViewController.swift
//  TenacityV3
//
//  Created by PLL on 7/30/19.
//  Copyright © 2019 PLL. All rights reserved.
//

import UIKit
import RealmSwift

class BreatheInfiniteStatsViewController: UIViewController{
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var minuteGoalLabel: UILabel!
    @IBOutlet weak var timePlayedLabel: UILabel!
    @IBOutlet weak var totalBreathsTakenLabel: UILabel!
    @IBOutlet weak var averageBreathLengthLabel: UILabel!
    @IBOutlet weak var setsPlayedLabel: UILabel!
    @IBOutlet weak var cyclesLabel: UILabel!
    @IBOutlet weak var breatheInfiniteLabel: UILabel!
    
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
        print(today.timeIntervalSince1970)
        startTime = calendar.startOfDay(for: today)
        
        //creates a date at the beginning of the week to compare
        let weekComponents = calendar.dateComponents([.month, .yearForWeekOfYear, .weekOfYear], from: today)
        weekStartTime = calendar.date(from: weekComponents)!
        
        refreshRealmData()
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
            self.timePlayedLabel.text = "Week: " + String(Int(breatheITimeWeek/60)) + " min" + "\nToday: " + String(Int(breatheITimeToday)) + " secs"
            self.totalBreathsTakenLabel.text = "Week: " + String(breatheIBreathsWeek) + "\nToday: " + String(breatheIBreathsToday)
            self.averageBreathLengthLabel.text = "Week: " + String(breatheIAvgWeek) + "\nToday: " + String(breatheIAvgToday)
            self.setsPlayedLabel.text = "Today:" + String(breatheITotalToday) + "\nThis Week: " + String(breatheITotalWeek)
            
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
