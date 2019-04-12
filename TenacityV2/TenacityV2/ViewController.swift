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

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if WCSession.isSupported(){
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var receivedDataTextView: UITextView!
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
        DispatchQueue.main.async{
            if activationState == .activated {
                
                if session.isWatchAppInstalled{
                    self.receivedDataTextView.text = "watch app is installed and is connected!"
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
                            self.receivedDataTextView.text = text + "\n" + text2
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
    

}

