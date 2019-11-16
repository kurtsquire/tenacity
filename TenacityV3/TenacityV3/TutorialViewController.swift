//
//  TutorialViewController.swift
//  TenacityV3
//
//  Created by Richie on 11/15/19.
//  Copyright © 2019 PLL. All rights reserved.
//

import Foundation
import UIKit

var tutorialCompleted = true
class TutorialViewController: PhoneViewController{
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // puts in top bar
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
    
    @IBAction func tutorialEndButtonAction(_ sender: Any) {
        tutorialCompleted = true
        print("end tutorial")
        // save that tutorial is finished
    }
}
