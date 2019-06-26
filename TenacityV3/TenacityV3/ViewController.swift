//
//  ViewController.swift
//  TenacityV3
//
//  Created by PLL on 5/20/19.
//  Copyright © 2019 PLL. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController, WCSessionDelegate {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var addNameButton: UIButton!
    @IBOutlet weak var addNameItem: UIBarButtonItem!
    
    @IBOutlet weak var addNameTextField: UITextField!
    @IBOutlet weak var textFieldLabel: UILabel!
    @IBOutlet weak var saveItem: UIBarButtonItem!
    
    typealias mytuple = (game: String, what: String, correct: String, time: String, setting: String)
    
    var data = [String]()
    var dataT = [mytuple]()
    var name = "N/A"
    var savePath = ViewController.getDocumentsDirectory().appendingPathComponent("data").path
    
    var todaysDate = Date()
    
    
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
        
        
        //
        
        
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
    
    //handles data we get from watch
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        DispatchQueue.main.async{
            
            var displayText = ""
            
            //asks what value is in data
            if let game = userInfo["game"] as? String {
                let what = userInfo["what"] as! String
                let correct = userInfo["correct"] as! String
                let time = userInfo["time"] as! String
                let settings = userInfo["settings"] as! String
                displayText = (game + "\n" + what + "\n" + correct + "\n" + time + "\n" + settings + ";;;\n")
                
                let testTuple = (game, what, correct, time, settings)
                
                //self.data.append(displayText)
                self.dataT.append(testTuple)
                print(self.dataT)
                NSKeyedArchiver.archiveRootObject(self.data, toFile: self.savePath)
            }
                
            else{
                self.textView.text += "got something but cant read it"
            }
            
        }
    }
    
    
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
    }
    
    
    ///////////////////////////////
    
    
    @IBOutlet weak var testTextView: UITextView!
    @IBAction func testButtonPressed(_ sender: Any) {
        self.testTextView.text = ""
        for i in dataT{
            if i.0 == "lotus"{
                let result = ((i.time as NSString).integerValue)
                print(result)
                let dataDate = Date(timeIntervalSince1970: TimeInterval(result))
                self.testTextView.text += String(dataDate.timeIntervalSince1970) + "\n"
            }
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
    
    //////////////////////////////////////////////////////////

}

