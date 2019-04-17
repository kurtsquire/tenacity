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

    @IBOutlet weak var receivedDataTextView: UITextView!
    var notes = [String]()
    var savePath = ViewController.getDocumentsDirectory().appendingPathComponent("notes").path
    
    @IBAction func clearDataButtonPress(_ sender: Any) {
        notes = [String]()
        self.receivedDataTextView.text = "notes emptied"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //connecting to wc
        if WCSession.isSupported(){
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        
        // loading from save
        notes = NSKeyedUnarchiver.unarchiveObject(withFile: savePath) as? [String] ?? [String]()
        
        
        //changing the text view to match save
        self.receivedDataTextView.text = ""
        for element in self.notes{
            self.receivedDataTextView.text += element
        }
        
        let timestamp = NSDate().timeIntervalSince1970
        self.receivedDataTextView.text += String(timestamp)
        // Do any additional setup after loading the view, typically from a nib.
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
        print("Phone session did become inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("Phone session did deactivate")
        //WCSession.default().activate()   for multiple watches
    }
    
    //handles data we get from watch
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        DispatchQueue.main.async{
            
            var displayText = ""
            var time = ""
            //asks what value is in game
            if let game = userInfo["game"] as? String {
                
                //if it is lotus
                if game == "lotus" {
                    if let text = userInfo["swipes"] as? String {
                        if let text2 = userInfo["press"] as? String {
                            
                            displayText = ("lotus\n" + text + "\n" + text2 + "\n")
                            self.notes.append(displayText)
                            
                            self.receivedDataTextView.text = ""
                            for element in self.notes{
                                self.receivedDataTextView.text += element
                            }
                            
                            NSKeyedArchiver.archiveRootObject(self.notes, toFile: self.savePath)
                        }
                        
                    }
                    if let text = userInfo["what"] as? String {
                        if let text2 = userInfo["correct"] as? String {
                            
                            if let text3 = userInfo["time"] as? String {
                                time = text3
                            }
                            
                            displayText = ("lotus\n" + text + "\n" + text2 + "\n")
                            displayText += (time + "\n")
                            self.notes.append(displayText)
                            
                            self.receivedDataTextView.text = ""
                            for element in self.notes{
                                self.receivedDataTextView.text += element
                            }
                            
                            NSKeyedArchiver.archiveRootObject(self.notes, toFile: self.savePath)
                        }
                        
                    }
                    
                }
                else if game == "breathe" {}
                
            }
            else{
                self.receivedDataTextView.text = "got something but cant read it"
            }
            
        }
    }
    
    static func getDocumentsDirectory() -> URL {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0]
    }
    

}

