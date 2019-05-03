//
//  ViewController.swift
//  TenacityV2
//
//  Created by PLL on 10/8/18.
//  Copyright © 2018 PLL. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController, WCSessionDelegate {

    @IBOutlet weak var barButtonClear: UIBarButtonItem!
    @IBOutlet weak var barButtonSave: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var nameTextView: UITextField!
    
    @IBOutlet weak var receivedDataTextView: UITextView!
    var notes = [String]()
    var name = "N/A"
    var savePath = ViewController.getDocumentsDirectory().appendingPathComponent("notes").path
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let delete = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteData))
        let send = UIBarButtonItem(title: "Send", style: .plain, target: self, action: #selector(sendData))
        let namelabel = UIBarButtonItem(title: "Name", style: .plain, target: self, action: #selector(changeName))
        
        navigationItem.leftBarButtonItems = [send, delete, namelabel]
        
        //connecting to wc
        if WCSession.isSupported(){
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        
        testUserDefaults()
        namelabel.title = name
        // loading from save
        notes = NSKeyedUnarchiver.unarchiveObject(withFile: savePath) as? [String] ?? [String]()
        
        //changing the text view to match save
        self.receivedDataTextView.text = ""
        for element in self.notes{
            self.receivedDataTextView.text += element
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func clearButtonAction(_ sender: Any) {
        name = "N/A"
        UserDefaults.standard.set(name, forKey: "shared_default")
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        self.name = self.nameTextView.text ?? "N/A"
        UserDefaults.standard.set(name, forKey: "shared_default")
        self.receivedDataTextView.isHidden = false
        self.receivedDataTextView.text = name
        self.nameTextView.isHidden = true
        self.saveButton.setTitle(self.name, for: UIControlState.normal)
        self.barButtonSave.isEnabled = false
        self.barButtonClear.isEnabled = false
    }
    
    func testUserDefaults(){
        let defaults = UserDefaults.standard
        
        if let contents = defaults.string(forKey: "shared_default"){
            if contents != "N/A"{
                name = contents
                return
            }
        }
        self.receivedDataTextView.isHidden = true
        self.nameTextView.isHidden = false
        self.barButtonSave.isEnabled = true
        self.barButtonClear.isEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    
    //handles data we get from watch
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        DispatchQueue.main.async{
            
            var displayText = ""
            var time = ""
            var what = ""
            var correct = ""
            //asks what value is in data
            if let game = userInfo["game"] as? String {
                    if let text1 = userInfo["what"] as? String {
                        what = text1
                    }
                    if let text2 = userInfo["correct"] as? String {
                        correct = text2
                    }
                    if let text3 = userInfo["time"] as? String {
                        time = text3
                    }
                    displayText = (game + "\n" + what + "\n" + correct + "\n" + time + "\n")
                    self.notes.append(displayText)
                    
                    self.receivedDataTextView.text = ""
                    for element in self.notes{
                        self.receivedDataTextView.text += element
                    }
                    
                    NSKeyedArchiver.archiveRootObject(self.notes, toFile: self.savePath)
                }
                
            else{
                self.receivedDataTextView.text += "got something but cant read it"
            }
            
        }
    }
    
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    @objc func sendData(){
    }
    
    @objc func changeName(){
        self.receivedDataTextView.isHidden = true
        self.nameTextView.isHidden = false
        self.barButtonSave.isEnabled = true
        self.barButtonClear.isEnabled = true
    }
    
    @objc func deleteData(){
        notes = [String]()
        self.receivedDataTextView.text = "cleared"
        NSKeyedArchiver.archiveRootObject(self.notes, toFile: self.savePath)
    }
    
    
    

}

