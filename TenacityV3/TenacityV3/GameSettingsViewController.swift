//
//  GameSettingsViewController.swift
//  TenacityV3
//
//  Created by PLL on 7/30/19.
//  Copyright © 2019 PLL. All rights reserved.
//

import UIKit
import WatchConnectivity

var mtxNum = 0 //lets purchase screen know which cosmeticgroup was last selected
var mtxTemp = 0

class GameSettingsViewController: PhoneViewController{
    
    // 1 = breathe classic, 2 = breathe fire, 3 = breathe cloud, 4 = breathe diamond, 5 = breathe teal, 6 = breathe saffron, 7 = breathe cherry, 8 = breathe lavender, 9 = lotus flower, 10 = lotus squares, 11 = lotus hearts, 12 = lotus circles, 13 = lotus classic, 14 = lotus forest, 15 = lotus outrun, 16 = lotus poolparty
    var mtxOwnedBreathe = [0]
    var mtxOwnedBreatheC = [0]
    var mtxOwnedLotus = [0]
    var mtxOwnedLotusC = [0]
    
    var mtxCost = 5
    
    var breathePic = 0
    var breatheColor = 0
    var lotusPic = 0
    var lotusColor = 0
    //var breatheEgg = 0
    
    @IBOutlet var breathePicLabels: [UILabel]!
    @IBOutlet var breatheColorLabels: [UILabel]!
    @IBOutlet var lotusPicLabels: [UILabel]!
    @IBOutlet var lotusColorLabels: [UILabel]!
    
    var cosmeticsTutorialCompleted = false
    
    // changes the top font to white (time and battery life wifi etc)
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // takes out top bar
        navigationController?.setNavigationBarHidden(true, animated: false)
        testUserDefaults()
        updateLabelsOpen()
        print("hi viewwillappear")
        
        if !cosmeticsTutorialCompleted{
            let storyBoard: UIStoryboard = UIStoryboard(name: "GameCosmetics", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "Cosmetics Popup")

            self.present(newViewController, animated: true, completion: nil)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidLoad() {
        PurchaseManager.shared.firstVC = self
        //testUserDefaults()
        //updateLabelsOpen()
    }
    
    // If mtx not owned open up purchase popup
    
    @IBAction func openPurchaseConfirmationBreathePic(_ sender: UIButton) {
        if !(mtxOwnedBreathe.contains(sender.tag)){
            let storyBoard: UIStoryboard = UIStoryboard(name: "GameCosmetics", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "confirmPurchasePopup")
            self.present(newViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func openPurchaseConfirmationEgg(_ sender: UIButton) {
        if !(mtxOwnedBreathe.contains(sender.tag)){
            let storyBoard: UIStoryboard = UIStoryboard(name: "GameCosmetics", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "confirmPurchasePopup")
            self.present(newViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func openPurchaseConfirmationBreatheColor(_ sender: UIButton) {
        if !(mtxOwnedBreatheC.contains(sender.tag)){
            let storyBoard: UIStoryboard = UIStoryboard(name: "GameCosmetics", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "confirmPurchasePopup")
            self.present(newViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func openPurchaseConfirmationLotusPic(_ sender: UIButton) {
        if !(mtxOwnedLotus.contains(sender.tag)){
            let storyBoard: UIStoryboard = UIStoryboard(name: "GameCosmetics", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "confirmPurchasePopup")
            self.present(newViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func openPurchaseConfirmationLotusColor(_ sender: UIButton) {
        if !(mtxOwnedLotusC.contains(sender.tag)){
            let storyBoard: UIStoryboard = UIStoryboard(name: "GameCosmetics", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "confirmPurchasePopup")
            self.present(newViewController, animated: true, completion: nil)
        }
    }
    // --------------------------------------- BREATHE PICS -------------------------------------
    
    // one button press only do x if cosmetic is unlocked
    // otherwise bring up shop screen?
    
    @IBAction func classic(_ sender: UIButton) {
        if mtxOwnedBreathe.contains(sender.tag){
            saveToRealm(what: "breathe: equip classic theme")
            breathePic = sender.tag
            sendAppContext()
            self.updateLabels(group: self.breathePicLabels, num: sender.tag)
            UserDefaults.standard.set(sender.tag, forKey: "breathePic")
        }
        mtxTemp = sender.tag
        mtxNum = 0
    }
    @IBAction func fire(_ sender: UIButton) {
        if mtxOwnedBreathe.contains(sender.tag){
            saveToRealm(what: "breathe: equip fire theme")
            breathePic = sender.tag
            sendAppContext()
            self.updateLabels(group: self.breathePicLabels, num: sender.tag)
            UserDefaults.standard.set(sender.tag, forKey: "breathePic")
        }
        mtxTemp = sender.tag
        mtxNum = 0
    }
    @IBAction func cloud(_ sender: UIButton) {
        if mtxOwnedBreathe.contains(sender.tag){
            saveToRealm(what: "breathe: equip cloud theme")
            breathePic = sender.tag
            sendAppContext()
            self.updateLabels(group: self.breathePicLabels, num: sender.tag)
            UserDefaults.standard.set(sender.tag, forKey: "breathePic")
        }
        mtxTemp = sender.tag
        mtxNum = 0
    }
    @IBAction func diamond(_ sender: UIButton) {
        if mtxOwnedBreathe.contains(sender.tag){
            saveToRealm(what: "breathe: equip diamond theme")
            breathePic = sender.tag
            sendAppContext()
            self.updateLabels(group: self.breathePicLabels, num: sender.tag)
            UserDefaults.standard.set(sender.tag, forKey: "breathePic")
        }
        mtxTemp = sender.tag
        mtxNum = 0
    }
    
    
    // --------------------------------------- BREATHE EGGS -------------------------------------
    
    @IBAction func egg_1(_ sender: UIButton) {
        if mtxOwnedBreathe.contains(sender.tag){//4
            saveToRealm(what: "breathe: equip egg 1")
            breathePic = sender.tag
            sendAppContext()
            self.updateLabels(group: self.breathePicLabels, num: sender.tag)
            UserDefaults.standard.set(sender.tag, forKey: "breathePic")
        }
        mtxTemp = sender.tag
        mtxNum = 0
    }
    @IBAction func egg_2(_ sender: UIButton) {
        if mtxOwnedBreathe.contains(sender.tag){//5
            saveToRealm(what: "breathe: equip egg 2")
            breathePic = sender.tag
            sendAppContext()
            self.updateLabels(group: self.breathePicLabels, num: sender.tag)
            UserDefaults.standard.set(sender.tag, forKey: "breathePic")
        }
        mtxTemp = sender.tag
        mtxNum = 0
    }
    
    @IBAction func egg_3(_ sender: UIButton) {
        if mtxOwnedBreathe.contains(sender.tag){//6
            saveToRealm(what: "breathe: equip egg 3")
            breathePic = sender.tag
            sendAppContext()
            self.updateLabels(group: self.breathePicLabels, num: sender.tag)
            UserDefaults.standard.set(sender.tag, forKey: "breathePic")
        }
        mtxTemp = sender.tag
        mtxNum = 0
    }
    
    @IBAction func egg_4(_ sender: UIButton) {
        if mtxOwnedBreathe.contains(sender.tag){//7
            saveToRealm(what: "breathe: equip egg 4")
            breathePic = sender.tag
            sendAppContext()
            self.updateLabels(group: self.breathePicLabels, num: sender.tag)
            UserDefaults.standard.set(sender.tag, forKey: "breathePic")
        }
        mtxTemp = sender.tag
        mtxNum = 0
    }
    
    @IBAction func egg_5(_ sender: UIButton) {
        if mtxOwnedBreathe.contains(sender.tag){//8
            saveToRealm(what: "breathe: equip egg 5")
            breathePic = sender.tag
            sendAppContext()
            self.updateLabels(group: self.breathePicLabels, num: sender.tag)
            UserDefaults.standard.set(sender.tag, forKey: "breathePic")
        }
        mtxTemp = sender.tag
        mtxNum = 0
    }
    
    @IBAction func egg_6(_ sender: UIButton) {
        if mtxOwnedBreathe.contains(sender.tag){//9
            saveToRealm(what: "breathe: equip egg 6")
            breathePic = sender.tag
            sendAppContext()
            self.updateLabels(group: self.breathePicLabels, num: sender.tag)
            UserDefaults.standard.set(sender.tag, forKey: "breathePic")
        }
        mtxTemp = sender.tag
        mtxNum = 0
    }
    
    // --------------------------------------- BREATHE COLORS -------------------------------------
    
    @IBAction func redB(_ sender: UIButton) {
        if mtxOwnedBreatheC.contains(sender.tag){
            saveToRealm(what: "breathe: equip red color")
            breatheColor = sender.tag
            sendAppContext()
            self.updateLabels(group: self.breatheColorLabels, num: sender.tag)
            UserDefaults.standard.set(sender.tag, forKey: "breatheColor")
            
        }
        mtxNum = 2
        mtxTemp = sender.tag
    }
    @IBAction func blueB(_ sender: UIButton) {
        if mtxOwnedBreatheC.contains(sender.tag){
            saveToRealm(what: "breathe: equip blue color")
            breatheColor = sender.tag
            sendAppContext()
            self.updateLabels(group: self.breatheColorLabels, num: sender.tag)
            UserDefaults.standard.set(sender.tag, forKey: "breatheColor")
            
        }
        mtxNum = 2
        mtxTemp = sender.tag
    }
    @IBAction func saffronB(_ sender: UIButton) {
        if mtxOwnedBreatheC.contains(sender.tag){
            saveToRealm(what: "breathe: equip pink color")
            breatheColor = sender.tag
            sendAppContext()
            self.updateLabels(group: self.breatheColorLabels, num: sender.tag)
            UserDefaults.standard.set(sender.tag, forKey: "breatheColor")
            
        }
        mtxNum = 2
        mtxTemp = sender.tag
    }
    @IBAction func lavenderB(_ sender: UIButton) {
        if mtxOwnedBreatheC.contains(sender.tag){
            saveToRealm(what: "breathe: equip green color")
            breatheColor = sender.tag
            sendAppContext()
            self.updateLabels(group: self.breatheColorLabels, num: sender.tag)
            UserDefaults.standard.set(sender.tag, forKey: "breatheColor")
            
        }
        mtxNum = 2
        mtxTemp = sender.tag
    }
    
    
    // --------------------------------------- LOTUS PICS -------------------------------------
    
    @IBAction func lotus(_ sender: UIButton) {
        if mtxOwnedLotus.contains(sender.tag){
            saveToRealm(what: "lotus: equip lotus theme")
            lotusPic = sender.tag
            sendAppContext()
            self.updateLabels(group: self.lotusPicLabels, num: sender.tag)
            UserDefaults.standard.set(sender.tag, forKey: "lotusPic")
        }
        mtxNum = 1
        mtxTemp = sender.tag
    }
    @IBAction func squares(_ sender: UIButton) {
        if mtxOwnedLotus.contains(sender.tag){
            saveToRealm(what: "lotus: equip square theme")
            lotusPic = sender.tag
            sendAppContext()
            self.updateLabels(group: self.lotusPicLabels, num: sender.tag)
            UserDefaults.standard.set(sender.tag, forKey: "lotusPic")
        }
        mtxNum = 1
        mtxTemp = sender.tag
    }
    @IBAction func heart(_ sender: UIButton) {
        if mtxOwnedLotus.contains(sender.tag){
            saveToRealm(what: "lotus: equip heart theme")
            lotusPic = sender.tag
            sendAppContext()
            self.updateLabels(group: self.lotusPicLabels, num: sender.tag)
            UserDefaults.standard.set(sender.tag, forKey: "lotusPic")
        }
        mtxNum = 1
        mtxTemp = sender.tag
    }
    @IBAction func circle(_ sender: UIButton) {
        if mtxOwnedLotus.contains(sender.tag){
            saveToRealm(what: "lotus: equip circle theme")
            lotusPic = sender.tag
            sendAppContext()
            self.updateLabels(group: self.lotusPicLabels, num: sender.tag)
            UserDefaults.standard.set(sender.tag, forKey: "lotusPic")
        }
        mtxNum = 1
        mtxTemp = sender.tag
    }
    
    // --------------------------------------- LOTUS COLORS -------------------------------------
    
    @IBAction func lotusOG(_ sender: UIButton) {
        if mtxOwnedLotusC.contains(sender.tag){
            saveToRealm(what: "lotus: equip lotus color")
            lotusColor = sender.tag
            sendAppContext()
            self.updateLabels(group: self.lotusColorLabels, num: sender.tag)
            UserDefaults.standard.set(sender.tag, forKey: "lotusColor")
        }
        mtxNum = 3
        mtxTemp = sender.tag
    }
    @IBAction func lotusForest(_ sender: UIButton) {
        if mtxOwnedLotusC.contains(sender.tag){
            saveToRealm(what: "lotus: equip forest color")
            lotusColor = sender.tag
            sendAppContext()
            self.updateLabels(group: self.lotusColorLabels, num: sender.tag)
            UserDefaults.standard.set(sender.tag, forKey: "lotusColor")
        }
        mtxNum = 3
        mtxTemp = sender.tag
    }
    @IBAction func lotusOutrun(_ sender: UIButton) {
        if mtxOwnedLotusC.contains(sender.tag){
            saveToRealm(what: "lotus: equip outrun color")
            lotusColor = sender.tag
            sendAppContext()
            self.updateLabels(group: self.lotusColorLabels, num: sender.tag)
            UserDefaults.standard.set(sender.tag, forKey: "lotusColor")
        }
        mtxNum = 3
        mtxTemp = sender.tag
    }
    @IBAction func lotusPool(_ sender: UIButton) {
        if mtxOwnedLotusC.contains(sender.tag){
            saveToRealm(what: "lotus: equip pool party color")
            lotusColor = sender.tag
            sendAppContext()
            self.updateLabels(group: self.lotusColorLabels, num: sender.tag)
            UserDefaults.standard.set(sender.tag, forKey: "lotusColor")
        }
        mtxNum = 3
        mtxTemp = sender.tag
    }
    
    // -----------------------------------------------------------------------------------------
    
    func sendAppContext(){
        let session = WCSession.default
        
        if session.activationState == .activated {
            
            let data = ["lpic": lotusPic, "lcol": lotusColor, "bpic": breathePic, "bcol": breatheColor]
            
            do {
                try session.updateApplicationContext(data)
            } catch {
                print("Alert! Updating app context failed")
            }
        }
    }
    
    func updateLabels(group : Array<UILabel>, num : Int){
        DispatchQueue.main.async {
            for i in group{
                if i.tag != num{
                    if group == self.breathePicLabels{
                        if self.mtxOwnedBreathe.contains(i.tag){
                            i.text = "owned"
                            i.textColor = UIColor.lightText
                        }
                    }
                    else if group == self.breatheColorLabels{
                        if self.mtxOwnedBreatheC.contains(i.tag){
                            i.text = "owned"
                            i.textColor = UIColor.lightText
                        }
                    }
                    else if group == self.lotusPicLabels{
                        if self.mtxOwnedLotus.contains(i.tag){
                            i.text = "owned"
                            i.textColor = UIColor.lightText
                        }
                    }
                    else if group == self.lotusColorLabels{
                        if self.mtxOwnedLotusC.contains(i.tag){
                            i.text = "owned"
                            i.textColor = UIColor.lightText
                        }
                    }
                }
                else{
                    i.text = "Equipped"
                    i.textColor = UIColor.green
                }
            }
        }
    }
    
    func updateLabelsOpen(){
        for i in breathePicLabels{
            // set equipped label
            if (i.tag == breathePic){
                i.text = "Equipped"
                i.textColor = UIColor.green
            }
            // set need to buy labels
            else if !(mtxOwnedBreathe.contains(i.tag)){
                i.text = String(mtxCost) + "$"
                i.textColor = UIColor.systemYellow
            }
            // set rest of owned mtx
            else {
                i.text = "owned"
                i.textColor = UIColor.lightText
            }
        }
        for i in breatheColorLabels{
            if (i.tag == breatheColor){
                i.text = "Equipped"
                i.textColor = UIColor.green
            }
            else if !(mtxOwnedBreatheC.contains(i.tag)){
                i.text = String(mtxCost) + "$"
                i.textColor = UIColor.systemYellow
            }
            else {
                i.text = "owned"
                i.textColor = UIColor.lightText
            }
        }
        for i in lotusPicLabels{
            if (i.tag == lotusPic){
                i.text = "Equipped"
                i.textColor = UIColor.green
            }
            else if !(mtxOwnedLotus.contains(i.tag)){
                i.text = String(mtxCost) + "$"
                i.textColor = UIColor.systemYellow
            }
            else {
                i.text = "owned"
                i.textColor = UIColor.lightText
            }
        }
        for i in lotusColorLabels{
            if (i.tag == lotusColor){
                i.text = "Equipped"
                i.textColor = UIColor.green
            }
            else if !(mtxOwnedLotusC.contains(i.tag)){
                i.text = String(mtxCost) + "$"
                i.textColor = UIColor.systemYellow
            }
            else {
                i.text = "owned"
                i.textColor = UIColor.lightText
            }
        }
    }
    
    override func testUserDefaults(){
        let defaults = UserDefaults.standard
        
        breathePic = defaults.integer(forKey: "breathePic")
        breatheColor = defaults.integer(forKey: "breatheColor")
        
        lotusPic = defaults.integer(forKey: "lotusPic")
        lotusColor = defaults.integer(forKey: "lotusColor")
        
        mtxOwnedBreathe = defaults.array(forKey: "mtxOwnedBreathe") as? [Int] ?? [0]
        mtxOwnedBreatheC = defaults.array(forKey: "mtxOwnedBreatheC") as? [Int] ?? [0]
        mtxOwnedLotus = defaults.array(forKey: "mtxOwnedLotus") as? [Int] ?? [0]
        mtxOwnedLotusC = defaults.array(forKey: "mtxOwnedLotusC") as? [Int] ?? [0]
        
        cosmeticsTutorialCompleted = defaults.bool(forKey: "cosmeticsTutorialCompleted")
    }
    
}


class PurchaseManager {

    static let shared = PurchaseManager()
    var firstVC = GameSettingsViewController()
}
