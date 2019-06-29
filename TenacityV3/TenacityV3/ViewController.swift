//
//  ViewController.swift
//  TenacityV3
//
//  Created by PLL on 5/20/19.
//  Copyright © 2019 PLL. All rights reserved.
//

import UIKit
import WatchConnectivity
import RealmSwift
import Firebase

class ViewController: UIViewController, WCSessionDelegate {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var addNameButton: UIButton!
    @IBOutlet weak var addNameItem: UIBarButtonItem!
    
    @IBOutlet weak var addNameTextField: UITextField!
    @IBOutlet weak var textFieldLabel: UILabel!
    @IBOutlet weak var saveItem: UIBarButtonItem!
    
    
    var data = [String]()
    var name = "N/A"
    var savePath = ViewController.getDocumentsDirectory().appendingPathComponent("data").path
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //connecting to wc
        if WCSession.isSupported(){
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        
        // loads data from file
        data = NSKeyedUnarchiver.unarchiveObject(withFile: savePath) as? [String] ?? [String]()
        
        // loads "Name" from UserDefaults
        testUserDefaults()
        // sets label for name
        updateName()
        // changes Add Name Item to unpressable
        if (name != "N/A"){
            addNameItem.isEnabled = false
        }
        else{
            addNameItem.isEnabled = true
        }
        showRecent()
        
        // updates date picker
        
        // testing stuff delete this crap after
        let calendar = Calendar.autoupdatingCurrent
        let today = Date()

        let c = Date(timeIntervalSince1970: 30.0)
        let nextMonth = calendar.date(byAdding: .month, value: 1, to: today)
        let tomorrow = calendar.date(byAdding: .day, value: -5, to: today)
        print("++++++    TESTING DATES    +++++++++++++++++++++")
        print(calendar.isDateInToday(c))
        print(calendar.isDateInToday(today))
        print(calendar.isDateInToday(tomorrow!))
        print(calendar.isDateInToday(nextMonth!))
        print(calendar.isDateInTomorrow(tomorrow!))
        print(calendar.isDate(today, inSameDayAs: tomorrow!))
        print(calendar.isDate(today, equalTo: tomorrow!, toGranularity: .weekOfYear))
        print(calendar.isDate(today, equalTo: c, toGranularity: .weekOfYear))


    }
    
    func showRecent(){
        self.textView.text = ""
        
        if (self.data.count > 10){
            let arraySlice = data.suffix(10)
            let newArray = Array(arraySlice)
            for element in newArray{
                self.textView.text += element
            }
        }
        else{
            for element in self.data{
                self.textView.text += element
            }
        }
    }
    
    func updateName(){
        nameLabel.text = "Name: " + name
    }
    
    // refresh button action
    @IBAction func refreshButton(_ sender: Any) {
        showRecent()
    }
    
    @IBAction func addNameButtonPressed(_ sender: Any) {
        addNameTextField.isHidden = false
        textFieldLabel.isHidden = false
        
        saveItem.isEnabled = true
        addNameItem.isEnabled = false
    }
    
    @IBAction func savePressed(_ sender: Any) {
        if self.addNameTextField.text == ""{
            return
        }
        
        self.name = self.addNameTextField.text ?? "N/A"
        UserDefaults.standard.set(name, forKey: "shared_default")
        
        addNameTextField.isHidden = true
        textFieldLabel.isHidden = true
        saveItem.isEnabled = false
        
        //nameLabel.text = "Name: " + name
        updateName()
        
        
        self.view.endEditing(true)
        // saves name to data
        self.data.append((self.name + ":::\n"))
        NSKeyedArchiver.archiveRootObject(self.data, toFile: self.savePath)
    }
    
    //    //handles data we get from watch
    //    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
    //        DispatchQueue.main.async{
    //
    //            var displayText = ""
    //            var time = ""
    //            var what = ""
    //            var correct = ""
    //            var settings = ""
    //            //asks what value is in data
    //            if let game = userInfo["game"] as? String {
    //                if let text1 = userInfo["what"] as? String {
    //                    what = text1
    //                }
    //                if let text2 = userInfo["correct"] as? String {
    //                    correct = text2
    //                }
    //                if let text3 = userInfo["time"] as? String {
    //                    time = text3
    //                }
    //                if let text4 = userInfo["settings"] as? String {
    //                    settings = text4
    //                }
    //                displayText = (game + "\n" + what + "\n" + correct + "\n" + time + "\n" + settings + ";;;\n")
    //
    //                self.data.append(displayText)
    //
    //                NSKeyedArchiver.archiveRootObject(self.data, toFile: self.savePath)
    //            }
    //
    //            else{
    //                self.textView.text += "got something but cant read it"
    //            }
    //
    //        }
    //    }
    
    
    //function to recieve user info --> also used to store received data into realm
    //NOTE TO SELF: edit code--> function has to many things going on here edit code to make it simple and modular
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        
        //Initialize Realm instance
        let realm = try! Realm()
        
        //recieve user info
        //Unpack dictionary data into temp variables
        //var time: Double
        //var date: Date
        //var what = ""
        //var correct = ""
        //var settings = ""
        
        //Asks what value is in data
        if let game = userInfo["game"] as? String {
            let what = userInfo["what"] as! String
            let correct = userInfo["correct"] as! String
            let date = userInfo["date"] as! Date
            let time = userInfo["time"] as! Double
            let settings = userInfo["settings"] as! String
            
            if (game == "lotus"){
                print("lotus")
            }
            
            //GameDataModel Realm Objects --> initialize new instances --> store data to save
            let gameDataModel = GameDataModel()
            gameDataModel.gameTitle = game
            gameDataModel.gameDataType = what
            gameDataModel.gameDataAccuracy = correct
            gameDataModel.sessionDate = date
            gameDataModel.sessionEpoch = time
            gameDataModel.gameSettings = settings
            
            //Write to Realm
            
            //RealmManager.writeObject(gameDataModel)
            
            do{
                try realm.write {
                    realm.add(gameDataModel)
                }
            }catch{
                print("Error saving data to Realm \(error)")
            }
            
        }
        
//        // firebase connection
//        let db = Database.database().reference()
//
//        db.setValue(what)
        
        
        
        //let x = realm.objects(GameDataModel.self)
        let x = realm.objects(GameDataModel.self).filter("gameTitle = 'breathe'")
        var y = String(x.count) + "\n"
        for i in x{
            y += i.gameTitle + ", " + i.gameDataType + ", " + i.gameDataAccuracy + ", "
            y += String(i.sessionEpoch) + ", " + i.gameSettings + "\n"
        }
        
        DispatchQueue.main.async {
            self.textView.text = y
        }
        
    }
    
    
 //////////////////////////////////////////////////////////
    
    func testUserDefaults(){
        let defaults = UserDefaults.standard
        
        if let contents = defaults.string(forKey: "shared_default"){
            if contents != "N/A"{
                name = contents
                return
            }
        }
    }
    
    @IBAction func trashPressed(_ sender: Any) {
        data = [String]()
        name = "N/A"
        
        UserDefaults.standard.set(name, forKey: "shared_default")
        NSKeyedArchiver.archiveRootObject(self.data, toFile: self.savePath)
        
        updateName()
        showRecent()
        
        // deletes realm
        deleteRealm()
    }
    
    
    func deleteRealm(){
        let realm = try! Realm()
        //RealmManager.deleteDatabase()
        let x = realm.objects(GameDataModel.self)
        try! realm.write {
            realm.delete(x)
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    /// Save to File //////////////
    
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
    //// WatchConnectivity Stuff  ////////////////////////////
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        DispatchQueue.main.async{
            if activationState == .activated {
                
                if session.isWatchAppInstalled{
                    //self.receivedDataTextView.text = "watch app is installed and is connected!"
                }
            }
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        //WCSession.default().activate()   for multiple watches
    }
    
   
    
}

