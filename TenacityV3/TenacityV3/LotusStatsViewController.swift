//
//  LotusStatsViewController.swift
//  TenacityV3
//
//  Created by PLL on 7/30/19.
//  Copyright © 2019 PLL. All rights reserved.
//

import UIKit
import RealmSwift

class LotusStatsViewController: PhoneViewController{
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var minuteGoalLabel: UILabel!
    @IBOutlet weak var timePlayedLabel: UILabel!
    @IBOutlet weak var roundsPlayedLabel: UILabel!
    @IBOutlet weak var swipesLabel: UILabel!
    @IBOutlet weak var lotusSwipeLabel: UILabel!
    
    lazy var lotusGraphCenter = lotusSwipeLabel.center
    
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
    
    
    func refreshRealmData(){
        let realm = try! Realm()
        
        let lw = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@", "lotus", weekStartTime)
        let lx = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@", "lotus", startTime)
        
        
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
        
        DispatchQueue.main.async {
            self.minuteGoalLabel.text = String(Int(lotusTimeToday/60)) + "/" + String(Int(lotusGoalTime)) + "mins"
            self.timePlayedLabel.text = "Week: " + String(lotusTimeWeek) + "\nToday: " + String(lotusTimeToday)
            self.roundsPlayedLabel.text = "Week:\n" + String(lotusRoundsWeek) + "\nToday:\n" + String(lotusRoundsToday)
            var a = "Lotus Swipe Wrong Attempts  (Attempts: how many misses before correct)\n"
            for i in 0..<lotusArrayToday.count{
                a += String(i) + ": " + String(lotusArrayToday[i]) + ", "
            }
            self.swipesLabel.text = a
            
            let lotusCircleGraph = CircleChart(radius: circleGraphRadius, progressEndAngle: lotusGraphEndAngle, center: self.lotusGraphCenter, lineWidth: circleGraphWidth, outlineColor: lotusGraphOutColor, progressColor: lotusGraphProgColor)
            self.mainView.layer.addSublayer(lotusCircleGraph.outlineLayer)
            self.mainView.layer.addSublayer(lotusCircleGraph.progressLayer)
        }
        
    }

}
