//
//  WatchViewController.swift
//  TenacityV3 WatchKit Extension
//
//  Created by Richie on 8/21/19.
//  Copyright © 2019 PLL. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class WatchViewController: WKInterfaceController, WCSessionDelegate {
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if WCSession.isSupported(){
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        if WCSession.isSupported(){
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
//    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
//
//        let theme = (userInfo["theme"] as? String)!
//        let game = (userInfo["game"] as? String)!
//        let color = (userInfo["color"] as? Int)!
//
//        if (color == -1){
//            if (game == "breathe"){
//                UserDefaults.standard.set(theme, forKey: "breatheTheme")
//            }
//            else if (game == "lotus"){
//                UserDefaults.standard.set(theme, forKey: "lotusTheme")
//            }
//        }
//        else{
//            if (game == "breathe"){
//                UserDefaults.standard.set(color, forKey: "breatheColor")
//            }
//            else if (game == "lotus"){
//                UserDefaults.standard.set(color, forKey: "lotusColor")
//            }
//        }
//    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        
        let game = (message["game"] as? String)!
        let type = (message["type"] as? String)!
        let num = (message["num"] as? Int)!
        let breathePics = ["classic", "fire", "cloud", "diamond"]
        let lotusPics = ["lotus", "square", "heart", "circle"]
        
        if (type == "pic"){
            if (game == "breathe"){
                UserDefaults.standard.set(breathePics[num], forKey: "breatheTheme")
            }
            else if (game == "lotus"){
                UserDefaults.standard.set(lotusPics[num], forKey: "lotusTheme")
            }
        }
        else if (type == "color"){
            if (game == "breathe"){
                UserDefaults.standard.set(num, forKey: "breatheColor")
            }
            else if (game == "lotus"){
                UserDefaults.standard.set(num, forKey: "lotusColor")
            }
        }
        
        replyHandler(["game": game, "type": type, "num": num])
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        if applicationContext.count == 4{
            let breathePics = ["classic", "fire", "cloud", "diamond"]
            let lotusPics = ["lotus", "square", "heart", "circle"]
            
            UserDefaults.standard.set(breathePics[applicationContext["bpic"] as! Int], forKey: "breatheTheme")
            UserDefaults.standard.set(lotusPics[applicationContext["lpic"] as! Int], forKey: "lotusTheme")
            UserDefaults.standard.set(applicationContext["bcol"], forKey: "breatheColor")
            UserDefaults.standard.set(applicationContext["lcol"], forKey: "lotusColor")
        }
        else if applicationContext.count == 1{
            print("recieved pet")
            UserDefaults.standard.set(applicationContext["pet"] as! String, forKey: "equippedPet")
        }
    }
    
    
}
