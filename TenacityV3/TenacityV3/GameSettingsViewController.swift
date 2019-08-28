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
        sendData(theme: "lotus", game: "lotus")
        saveToRealm(what: "lotus: equip lotus theme")
    }
    @IBAction func squares(_ sender: Any) {
        sendData(theme: "square", game: "lotus")
        saveToRealm(what: "lotus: equip square theme")
    }
    @IBAction func heart(_ sender: Any) {
        sendData(theme: "heart", game: "lotus")
        saveToRealm(what: "lotus: equip heart theme")
    }
    @IBAction func circle(_ sender: Any) {
        sendData(theme: "circle", game: "lotus")
        saveToRealm(what: "lotus: equip circle theme")
    }
    
    
    @IBAction func diamond(_ sender: Any) {
        sendData(theme: "diamond", game: "breathe")
        saveToRealm(what: "breathe: equip diamond theme")
    }
    @IBAction func fire(_ sender: Any) {
        sendData(theme: "fire", game: "breathe")
        saveToRealm(what: "breathe: equip fire theme")
    }
    @IBAction func cloud(_ sender: Any) {
        sendData(theme: "cloud", game: "breathe")
        saveToRealm(what: "breathe: equip cloud theme")
    }
    @IBAction func classic(_ sender: Any) {
        sendData(theme: "classic", game: "breathe")
        saveToRealm(what: "breathe: equip classic theme")
    }
    @IBAction func redB(_ sender: Any) {
        sendData(theme: "", game: "breathe", color: 1)
        saveToRealm(what: "breathe: equip red color")
    }
    @IBAction func blueB(_ sender: Any) {
        sendData(theme: "", game: "breathe", color: 0)
        saveToRealm(what: "breathe: equip blue color")
    }
    @IBAction func pinkB(_ sender: Any) {
        sendData(theme: "", game: "breathe", color: 2)
        saveToRealm(what: "breathe: equip pink color")
    }
    @IBAction func greenB(_ sender: Any) {
        sendData(theme: "", game: "breathe", color: 3)
        saveToRealm(what: "breathe: equip green color")
    }
    @IBAction func lotusOG(_ sender: Any) {
        sendData(theme: "", game: "lotus", color: 0)
        saveToRealm(what: "lotus: equip lotus color")
    }
    @IBAction func lotusForest(_ sender: Any) {
        sendData(theme: "", game: "lotus", color: 1)
        saveToRealm(what: "lotus: equip forest color")
    }
    @IBAction func lotusOutrun(_ sender: Any) {
        sendData(theme: "", game: "lotus", color: 2)
        saveToRealm(what: "lotus: equip outrun color")
    }
    @IBAction func lotusPool(_ sender: Any) {
        sendData(theme: "", game: "lotus", color: 3)
        saveToRealm(what: "lotus: equip pool party color")
    }
    
    
    
    func sendData(theme : String, game : String, color : Int = -1){
        let session = WCSession.default
        if session.activationState == .activated{
            let data = ["theme": theme, "game": game, "color" : color] as [String : Any]
            session.transferUserInfo(data)
        }
    }
}
