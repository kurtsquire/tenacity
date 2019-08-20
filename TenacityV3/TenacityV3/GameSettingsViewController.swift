//
//  GameSettingsViewController.swift
//  TenacityV3
//
//  Created by PLL on 7/30/19.
//  Copyright © 2019 PLL. All rights reserved.
//

import UIKit
import WatchConnectivity

class GameSettingsViewController: PhoneViewController{
    
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
    }
    
    @IBAction func lotus(_ sender: Any) {
        sendData(theme: "heart", game: "breathe")
    }
    @IBAction func squares(_ sender: Any) {
        sendData(theme: "square", game: "lotus")
    }
    @IBAction func diamond(_ sender: Any) {
        sendData(theme: "diamond", game: "breathe")
    }
    @IBAction func fire(_ sender: Any) {
        sendData(theme: "fire", game: "breathe")
    }
    @IBAction func cloud(_ sender: Any) {
        sendData(theme: "cloud", game: "breathe")
    }
    @IBAction func redB(_ sender: Any) {
        sendData(theme: "", game: "breathe", color: 1)
    }
    
    func sendData(theme : String, game : String, color : Int = -1){
        let session = WCSession.default
        if session.activationState == .activated{
            let data = ["theme": theme, "game": game, "color" : color] as [String : Any]
            session.transferUserInfo(data)
        }
    }
}
