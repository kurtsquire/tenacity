//
//  Quests.swift
//  TenacityV3
//
//  Created by PLL on 7/17/19.
//  Copyright © 2019 PLL. All rights reserved.
//

import Foundation

class Quest{
    var questString = ""
    var timeStart = Date()
    var timeEnd = Date()
    var experience : Int = 0
    var reward : String = ""
    var complete = false
    
    func checkQuest() -> Bool{
        print("SHOULD NOT SEE THIS")
        return complete
    }
}

class BreatheFocusQuest : Quest{
    var objective : Int = 0
    // 0 = spend x(goalTime) minutes at rate y(goalNum)
    // 1 = spend x time
    // 2 = play x(goalNum) games that last at least (goalTime)y+ mins
    // 3 = no wrong cycles with time set to x(goalTime) /// change to a certain amount of correct // take out or x cycles correc tin a row
    var goalNum : Int = 0
    var goalTime : Int = 0
    var count : Int = 0
    
    init(qs: String, ts: Date, te: Date, exp: Int, r: String, obj: Int, gn: Int, gt: Int) {
        super.init()
        self.questString = qs
        self.timeStart = ts
        self.timeEnd  = te
        self.experience = exp
        self.reward = r
        self.objective = obj
        self.goalNum = gn
        self.goalTime = gt
    }
    
    // need: time ended (Date), time played (int), correct cycles and total cycles (ints), cycle setting (Int)
    func checkQuest(timeFin: Date, timePlayed : Int, correct: Int, total: Int, cycle: Int) -> Bool{
        print("BREATHE FOCUS SHOULD SEE THIS")
        if (self.timeStart <= timeFin && timeFin <= self.timeEnd){
            if (self.objective == 0){
                if (cycle == goalNum){
                    self.count += timePlayed
                    if (count >= goalTime){
                        complete = true
                    }
                }
            }
            else if (self.objective == 1){
                self.count += timePlayed
                if (count >= goalTime){
                    complete = true
                }
            }
            else if (self.objective == 2){
                if (timePlayed >= goalTime){
                    count += 1
                    if (count >= goalNum){
                        complete = true
                    }
                }
            }
            else if (self.objective == 3){
                if (timePlayed >= goalTime){
                    if (correct == total){
                        complete = true
                    }
                }
            }
        }
        return complete
    }
}

class BreatheInfiniteQuest : Quest{ //If combine time and cycles then we will need a 2nd count 3rd goal
    
 
    // : play for x(goalTime) minutes for y(goalNum) cycles of z(goalCycle)
    var goalCycle : Int = 0
    var goalNum : Int = 0
    var goalTime : Int = 0
    //var timeCount : Int = 0
    var cycleCount : Int = 0
    
    init(qs: String, ts: Date, te: Date, exp: Int, r: String, gc: Int, gn: Int, gt: Int) {
        super.init()
        self.questString = qs
        self.timeStart = ts
        self.timeEnd  = te
        self.experience = exp
        self.reward = r
        self.goalCycle = gc
        self.goalNum = gn
        self.goalTime = gt
    }
    
    func checkQuest(timeFin: Date, timePlayed : Int, cycle: [String : Int]) -> Bool{
        print("BREATHE Infinite SHOULD SEE THIS")
        if (self.timeStart <= timeFin && timeFin <= self.timeEnd){
            if (timePlayed >= goalTime){
                if (cycle[String(goalCycle)] ?? 0 >= goalNum){
                    complete = true
                }
            }
            
        }
        return complete
    }
}

class LotusQuest : Quest{
    var objective : Int = 0
    // 0: play x rounds (goalnum)
    // 1: play an x round(goalnum) game without missing
    // 2: play x times(goal num)
    
    var goalNum : Int = 0
    var count : Int = 0
    
    init(qs: String, ts: Date, te: Date, exp: Int, r: String, obj: Int, gn: Int) {
        super.init()
        self.questString = qs
        self.timeStart = ts
        self.timeEnd  = te
        self.experience = exp
        self.reward = r
        self.objective = obj
        self.goalNum = gn
    }
    
    func checkQuest(timeFin : Date, roundsPlayed : Int, accuracy : Double) -> Bool{
        print("LOTUS SHOULD SEE THIS")
        if (self.timeStart <= timeFin && timeFin <= self.timeEnd){
            if (self.objective == 0){
                if (roundsPlayed >= goalNum){
                    complete = true
                }
            }
            else if (self.objective == 1){
                if (roundsPlayed >= goalNum && accuracy == 1){
                    complete = true
                }
            }
            else if (self.objective == 2){
                count += 1
                if (count >= goalNum){
                    complete = true
                }
            }
        }
        return complete
    }
}

class PlayAllQuest : Quest{
    var bfPlayed : Int = 0
    var biPlayed : Int = 0
    var lPlayed : Int = 0
    var goal : Int = 0
    
    init(qs: String, ts: Date, te: Date, exp: Int, r: String, g: Int) {
        super.init()
        self.questString = qs
        self.timeStart = ts
        self.timeEnd  = te
        self.experience = exp
        self.reward = r
        self.goal = g
    }
    
    // game , time end, time played
    func checkQuest(game : String, timeFin : Date, timePlayed : Int) -> Bool{
        print("ALL SHOULD SEE THIS")
        if (self.timeStart <= timeFin && timeFin <= self.timeEnd){
            if (game == "breathe"){
                bfPlayed += timePlayed
            }
            else if (game == "Free Breathe"){
                biPlayed += timePlayed
            }
            else if (game == "lotus"){
                lPlayed += timePlayed
            }
            if (bfPlayed >= goal && biPlayed >= goal && lPlayed >= goal){
                complete = true
            }
        }
            
        return complete
    }
}
