//
//  TutorialsViewController.swift
//  TenacityV3
//
//  Created by Richie on 12/9/19.
//  Copyright © 2019 PLL. All rights reserved.
//

import Foundation
import UIKit


class HomeTutorialsViewController: PhoneViewController{
    var homeTutorialCompleted = false
    
    @IBAction func DoneButton(_ sender: Any) {
        homeTutorialCompleted = true
        UserDefaults.standard.set(homeTutorialCompleted, forKey: "homeTutorialCompleted")
        dismiss(animated: true)
    }
}

class CompanionTutorialsViewController: PhoneViewController{
    var companionTutorialCompleted = false
    
    @IBAction func DoneButton(_ sender: Any) {
        companionTutorialCompleted = true
        UserDefaults.standard.set(companionTutorialCompleted, forKey: "companionTutorialCompleted")
        dismiss(animated: true)
    }
}

class StatsTutorialsViewController: PhoneViewController{
    var statsTutorialCompleted = false
    
    @IBAction func DoneButton(_ sender: Any) {
        statsTutorialCompleted = true
        UserDefaults.standard.set(statsTutorialCompleted, forKey: "statsTutorialCompleted")
        dismiss(animated: true)
    }
}

class NudgesTutorialsViewController: PhoneViewController{
    var nudgesTutorialCompleted = false
    
    @IBAction func DoneButton(_ sender: Any) {
        nudgesTutorialCompleted = true
        UserDefaults.standard.set(nudgesTutorialCompleted, forKey: "nudgesTutorialCompleted")
        dismiss(animated: true)
    }
}

class CosmeticsTutorialsViewController: PhoneViewController{
    var cosmeticsTutorialCompleted = false
    
    @IBAction func DoneButton(_ sender: Any) {
        cosmeticsTutorialCompleted = true
        UserDefaults.standard.set(cosmeticsTutorialCompleted, forKey: "cosmeticsTutorialCompleted")
        dismiss(animated: true)
    }
}
