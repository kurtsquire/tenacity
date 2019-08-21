//
//  InterfaceController.swift
//  TenacityV3 WatchKit Extension
//
//  Created by PLL on 5/20/19.
//  Copyright © 2019 PLL. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate {

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if WCSession.isSupported(){
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String) -> Any? {
        return "from Menu"
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {

        let theme = (userInfo["theme"] as? String)!
        let game = (userInfo["game"] as? String)!
        let color = (userInfo["color"] as? Int)!
        
        print(theme)
        print(color)
        if (color == -1){
            if (game == "breathe"){
                UserDefaults.standard.set(theme, forKey: "breatheTheme")
            }
            else if (game == "lotus"){
                UserDefaults.standard.set(theme, forKey: "lotusTheme")
            }
        }
        else{
            if (game == "breathe"){
                UserDefaults.standard.set(color, forKey: "breatheColor")
            }
            else if (game == "lotus"){
                UserDefaults.standard.set(color, forKey: "lotusColor")
            }
        }
        
        

        
    }

}
