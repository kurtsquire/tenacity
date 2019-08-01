//
//  LotusStatsViewController.swift
//  TenacityV3
//
//  Created by PLL on 7/30/19.
//  Copyright © 2019 PLL. All rights reserved.
//

import UIKit
import RealmSwift

class LotusStatsViewController: UIViewController{
    
    @IBOutlet weak var minuteGoalLabel: UILabel!
    @IBOutlet weak var timePlayedLabel: UILabel!
    @IBOutlet weak var roundsPlayedLabel: UILabel!
    @IBOutlet weak var swipesLabel: UILabel!
    
    
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
        print(today.timeIntervalSince1970)
        startTime = calendar.startOfDay(for: today)
        
        //creates a date at the beginning of the week to compare
        let weekComponents = calendar.dateComponents([.month, .yearForWeekOfYear, .weekOfYear], from: today)
        weekStartTime = calendar.date(from: weekComponents)!
    }
    
    override func viewDidAppear(_ animated: Bool) { //openign back up the tab (works from other tabs)
        super.viewDidAppear(animated)
        
        refreshRealmData()
    }
    
    
    func refreshRealmData(){
        let realm = try! Realm()
        
        let lw = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@", "lotus", weekStartTime)
        let lx = realm.objects(GameDataModel.self).filter("gameTitle = %@ AND sessionDate >= %@", "lotus", startTime)
        
        
        var lotusRoundsToday = 0
        var lotusRoundsWeek = 0
        
        //calculating lotus rounds today
        for item in lx{
            lotusRoundsToday += item.lotusRoundsPlayed
        }
        //calculating lotus rounds this week
        for item in lw{
            lotusRoundsWeek += item.lotusRoundsPlayed
        }
        
        DispatchQueue.main.async {
            self.minuteGoalLabel.text = "not yet"
            //self.timePlayedLabel.text = "Week: " + String(breatheFTimeWeek) + "\nToday: " + String(breatheFTimeToday)
            self.roundsPlayedLabel.text = "Week:\n" + String(lotusRoundsWeek) + "\nToday:\n" + String(lotusRoundsToday)
        }
        
    }

}
