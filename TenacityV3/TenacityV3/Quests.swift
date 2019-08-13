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
    
    func checkQuest(data : Dictionary<String, Any>) -> Bool{
        print("SHOULD NOT SEE THIS")
        return complete
    }
    
    func getProgress() -> Dictionary<String, Any>{
        print("SHOULD NOT SEE THIS")
        return [:]
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
    
    init(qs: String, ts: Date, te: Date, exp: Int, r: String, obj: Int, gn: Int, gt: Int, ct: Int = 0, c: Bool = false) {
        super.init()
        self.questString = qs
        self.timeStart = ts
        self.timeEnd  = te
        self.experience = exp
        self.reward = r
        self.objective = obj
        self.goalNum = gn
        self.goalTime = gt
        self.count = ct
        self.complete = c
    }
    
    // need: time ended (Date), time played (int), correct cycles and total cycles (ints), cycle setting (Int)
    
//    func checkQuest(timeFin: Date, timePlayed : Int, correct: Int, total: Int, cycle: Int) -> Bool{  //OLD
//        print("BREATHE FOCUS SHOULD SEE THIS")
//        if (self.timeStart <= timeFin && timeFin <= self.timeEnd){
//            if (self.objective == 0){
//                if (cycle == goalNum){
//                    self.count += timePlayed
//                    if (count >= goalTime){
//                        complete = true
//                    }
//                }
//            }
//            else if (self.objective == 1){
//                self.count += timePlayed
//                if (count >= goalTime){
//                    complete = true
//                }
//            }
//            else if (self.objective == 2){
//                if (timePlayed >= goalTime){
//                    count += 1
//                    if (count >= goalNum){
//                        complete = true
//                    }
//                }
//            }
//            else if (self.objective == 3){
//                if (timePlayed >= goalTime){
//                    if (correct == total){
//                        complete = true
//                    }
//                }
//            }
//        }
//        return complete
//    }
    
    override func checkQuest(data: Dictionary<String, Any>) -> Bool{
        if ((data["game"] as! String) == "breathe focus"){
            if (self.timeStart <= (data["timeEnd"] as! Date) && (data["timeEnd"] as! Date) <= self.timeEnd){
                if (self.objective == 0){
                    if ((data["cycle"] as! Int) == goalNum){
                        self.count += (data["timePlayed"] as! Int)
                        if (count >= goalTime){
                            complete = true
                        }
                    }
                }
                else if (self.objective == 1){
                    self.count += (data["timePlayed"] as! Int)
                    if (count >= goalTime){
                        complete = true
                    }
                }
                else if (self.objective == 2){
                    if ((data["timePlayed"] as! Int) >= goalTime){
                        count += 1
                        if (count >= goalNum){
                            complete = true
                        }
                    }
                }
                else if (self.objective == 3){
                    if ((data["timePlayed"] as! Int) >= goalTime){
                        if ((data["correct"] as! Int) == (data["total"] as! Int)){
                            complete = true
                        }
                    }
                }
            }
        }
        return complete
    }
    
    override func getProgress() -> Dictionary<String, Any>{
        return ["count": count]
    }
}

class BreatheInfiniteQuest : Quest{
    
    // : play for x(goalTime) minutes for y(goalNum) cycles of z(goalCycle)
    var goalCycle : Int = 0
    var goalNum : Int = 0
    var goalTime : Int = 0
    //var timeCount : Int = 0
    //var cycleCount : Int = 0
    
    init(qs: String, ts: Date, te: Date, exp: Int, r: String, gc: Int, gn: Int, gt: Int, c: Bool = false) {
        super.init()
        self.questString = qs
        self.timeStart = ts
        self.timeEnd  = te
        self.experience = exp
        self.reward = r
        self.goalCycle = gc
        self.goalNum = gn
        self.goalTime = gt
        self.complete = c
    }
    
//    func checkQuest(timeFin: Date, timePlayed : Int, cycle: [String : Int]) -> Bool{  //OLD
//        print("BREATHE Infinite SHOULD SEE THIS")
//        if (self.timeStart <= timeFin && timeFin <= self.timeEnd){
//            if (timePlayed >= goalTime){
//                if (cycle[String(goalCycle)] ?? 0 >= goalNum){
//                    complete = true
//                }
//            }
//
//        }
//        return complete
//    }
    
    override func checkQuest(data: Dictionary<String, Any>) -> Bool{
        if ((data["game"] as! String) == "breathe infinite"){
            if (self.timeStart <= (data["timeEnd"] as! Date) && (data["timeEnd"] as! Date) <= self.timeEnd){
                if ((data["timePlayed"] as! Int) >= goalTime){
                    if ((data["cycle"] as! Dictionary<String, Int>)[String(goalCycle)] ?? 0 >= goalNum){
                        complete = true
                    }
                }
                
            }
        }
        return complete
    }
    
    override func getProgress() -> Dictionary<String, Any>{
        return [:]
    }
}

class LotusQuest : Quest{
    var objective : Int = 0
    // 0: play x rounds (goalnum)
    // 1: play an x round(goalnum) game without missing
    // 2: play x times(goal num)
    
    var goalNum : Int = 0
    var count : Int = 0
    
    init(qs: String, ts: Date, te: Date, exp: Int, r: String, obj: Int, gn: Int, ct: Int = 0, c: Bool = false) {
        super.init()
        self.questString = qs
        self.timeStart = ts
        self.timeEnd  = te
        self.experience = exp
        self.reward = r
        self.objective = obj
        self.goalNum = gn
        self.count = ct
        self.complete = c
    }
    
//    func checkQuest(timeFin : Date, roundsPlayed : Int, accuracy : Double) -> Bool{  //OLD
//        print("LOTUS SHOULD SEE THIS")
//        if (self.timeStart <= timeFin && timeFin <= self.timeEnd){
//            if (self.objective == 0){
//                if (roundsPlayed >= goalNum){
//                    complete = true
//                }
//            }
//            else if (self.objective == 1){
//                if (roundsPlayed >= goalNum && accuracy == 1){
//                    complete = true
//                }
//            }
//            else if (self.objective == 2){
//                count += 1
//                if (count >= goalNum){
//                    complete = true
//                }
//            }
//        }
//        return complete
//    }
    
    override func checkQuest(data: Dictionary<String, Any>) -> Bool{
        if ((data["game"] as! String) == "lotus"){
            if (self.timeStart <= (data["timeEnd"] as! Date) && (data["timeEnd"] as! Date) <= self.timeEnd){
                if (self.objective == 0){
                    if ((data["rounds"] as! Int) >= goalNum){
                        complete = true
                    }
                }
                else if (self.objective == 1){
                    if ((data["rounds"] as! Int) >= goalNum && (data["correct"] as! Int) == (data["rounds"] as! Int)){
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
        }
        return complete
    }
    
    override func getProgress() -> Dictionary<String, Any>{
        return ["count": count]
    }
}

class PlayAllQuest : Quest{
    var bfPlayed : Int = 0
    var biPlayed : Int = 0
    var lPlayed : Int = 0
    var goal : Int = 0
    
    init(qs: String, ts: Date, te: Date, exp: Int, r: String, g: Int, bfp: Int = 0, bip: Int = 0, lp: Int = 0, c: Bool = false) {
        super.init()
        self.questString = qs
        self.timeStart = ts
        self.timeEnd  = te
        self.experience = exp
        self.reward = r
        self.goal = g
        self.bfPlayed = bfp
        self.biPlayed = bip
        self.lPlayed = lp
        self.complete = c
    }
    
    // game , time end, time played
    
//    func checkQuest(game : String, timeFin : Date, timePlayed : Int) -> Bool{  //OLD
//        print("ALL SHOULD SEE THIS")
//        if (self.timeStart <= timeFin && timeFin <= self.timeEnd){
//            if (game == "breathe"){
//                bfPlayed += timePlayed
//            }
//            else if (game == "Free Breathe"){
//                biPlayed += timePlayed
//            }
//            else if (game == "lotus"){
//                lPlayed += timePlayed
//            }
//            if (bfPlayed >= goal && biPlayed >= goal && lPlayed >= goal){
//                complete = true
//            }
//        }
//
//        return complete
//    }
    
    override func checkQuest(data: Dictionary<String, Any>) -> Bool{
        if (self.timeStart <= (data["timeEnd"] as! Date) && (data["timeEnd"] as! Date) <= self.timeEnd){
            if ((data["game"] as! String) == "breathe focus"){
                bfPlayed += (data["timePlayed"] as! Int)
            }
            else if ((data["game"] as! String) == "breathe infinite"){
                biPlayed += (data["timePlayed"] as! Int)
            }
            else if ((data["game"] as! String) == "lotus"){
                lPlayed += (data["timePlayed"] as! Int)
            }
            if (bfPlayed >= goal && biPlayed >= goal && lPlayed >= goal){
                complete = true
            }
        }
        return complete
    }
    
    override func getProgress() -> Dictionary<String, Any> {
        return ["bfplayed": bfPlayed, "biPlayed": biPlayed, "lPlayed": lPlayed]
    }
}
