//
//  BreatheFocusStatsViewController.swift
//  TenacityV3
//
//  Created by PLL on 7/30/19.
//  Copyright © 2019 PLL. All rights reserved.
//

import UIKit
import RealmSwift

class BreatheFocusStatsViewController: PhoneViewController{
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var minuteGoalLabel: UILabel!
    @IBOutlet weak var timePlayedLabel: UILabel!
    @IBOutlet weak var totalBreathsLabel: UILabel!
    @IBOutlet weak var averageBreathLabel: UILabel!
    @IBOutlet weak var setsPlayedLabel: UILabel!
    @IBOutlet weak var breatheFocusLabel: UILabel!
    
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
            self.timePlayedLabel.text = "Week: " + String(Int(breatheFTimeWeek/60)) + " mins" + "\nToday: " + String(Int(breatheFTimeToday)) + " secs"
            self.totalBreathsLabel.text = "Week: " + String(breatheFBreathsWeek) + "\nToday: " + String(breatheFBreathsToday)
            self.averageBreathLabel.text = "Week: " + String(breatheFAvgWeek) + "\nToday: " + String(breatheFAvgToday)
            self.setsPlayedLabel.text = "Today:\nCorrect Sets: " + String(breatheFCorrectToday) + "\nTotal Sets: " + String(breatheFTotalToday) + "\nThis Week:\nCorrect Sets: " + String(breatheFCorrectWeek) + "\nTotal Sets: " + String(breatheFTotalWeek)
            
            
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
