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
        
        if WCSession.isSupported(){
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        
        notes = NSKeyedUnarchiver.unarchiveObject(withFile: savePath) as? [String] ?? [String]()
        
        self.receivedDataTextView.text = ""
        for element in self.notes{
            self.receivedDataTextView.text += element
        }
        
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
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        DispatchQueue.main.async{
            if let game = userInfo["game"] as? String {
                if game == "lotus" {
                    if let text = userInfo["swipes"] as? String {
                        if let text2 = userInfo["press"] as? String {
                            self.notes.append(text + "\n" + text2 + "\n")
                            
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

