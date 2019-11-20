//
//  TutorialViewController.swift
//  TenacityV3
//
//  Created by Richie on 11/15/19.
//  Copyright © 2019 PLL. All rights reserved.
//

import Foundation
import UIKit


class TutorialViewController: PhoneViewController{
    
    var tutorialCompleted = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // puts in top bar
        testUserDefaults()
        if tutorialCompleted{
            navigationController?.setNavigationBarHidden(false, animated: false)
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // takes out top bar again
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func testUserDefaults(){
        let defaults = UserDefaults.standard
        tutorialCompleted = defaults.bool(forKey: "tutorialCompleted")
        print(tutorialCompleted)
    }
    
    @IBAction func tutorialEndButtonAction(_ sender: Any) {
        //tutorialCompleted = true
        //UserDefaults.standard.set(true, forKey: "tutorialCompleted")
        //print("true")
        // save that tutorial is finished
    }
    
    @IBAction func reset(_ sender: Any) {
        tutorialCompleted = false
        UserDefaults.standard.set(false, forKey: "tutorialCompleted")
        
    }
    @IBAction func finish(_ sender: Any) {
        tutorialCompleted = true
        UserDefaults.standard.set(true, forKey: "tutorialCompleted")
        
    }
}
