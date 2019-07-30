//
//  HomeViewController.swift
//  TenacityV3
//
//  Created by PLL on 7/26/19.
//  Copyright © 2019 PLL. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController: UIViewController{
    
    // --------------------------- EXPERIENCE -----------------------------
    @IBOutlet weak var expBar1: UIImageView!
    @IBOutlet weak var expBar2: UIImageView!
    @IBOutlet weak var expBar3: UIImageView!
    @IBOutlet weak var expBar4: UIImageView!
    
    @IBOutlet weak var expLabel: UILabel!
    @IBOutlet weak var lvlLabel: UILabel!
    
    
    // --------------------------- PROGRESS -----------------------------
    @IBAction func progressHelpButton(_ sender: Any) {
    }
    @IBAction func settingsButton(_ sender: Any) {
    }
    
    // --------------------------- PETS -----------------------------
   
    @IBOutlet weak var homePet: UIButton!
    @IBOutlet weak var petQuoteLabel: UILabel!
    
    
    // --------------------------- GOALS -----------------------------
    @IBAction func goalsHelpButton(_ sender: Any) {
    }
    @IBOutlet weak var breatheFMinuteGoalLabel: UILabel!
    @IBOutlet weak var breatheIMinuteGoalLabel: UILabel!
    @IBOutlet weak var lotusMinuteGoalLabel: UILabel!

    @IBOutlet weak var badge1: UIButton!
    @IBOutlet weak var badge2: UIButton!
    @IBOutlet weak var badge3: UIButton!
    @IBAction func achievementButton(_ sender: Any) {
    }
    
    // --------------------------- QUESTS -----------------------------
    @IBAction func questRerollButton(_ sender: Any) {
    }
    @IBAction func questHelpButton(_ sender: Any) {
    }
    @IBOutlet weak var questDetailsLabel: UILabel!
    @IBOutlet weak var rewardImage: UIImageView!
    
    
    // --------------------------- NUDGES -----------------------------
    @IBAction func nudgeHelpButton(_ sender: Any) {
    }
    @IBOutlet weak var nudge1: UILabel!
    @IBOutlet weak var nudge2: UILabel!
    @IBOutlet weak var nudge3: UILabel!
    @IBOutlet weak var nudge4: UILabel!
    
    // ----------------------------------------------------------------
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
