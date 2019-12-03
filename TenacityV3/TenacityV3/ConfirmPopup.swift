//
//  ConfirmPopup.swift
//  TenacityV3
//
//  Created by Richie on 11/21/19.
//  Copyright © 2019 PLL. All rights reserved.
//

import Foundation
import UIKit


class ConfirmPopupViewController: PhoneViewController {
    
    
    let breathePicArray = ["Breathe Classic", "Breathe Fire", "Breathe Cloud", "Breathe Diamond"]
    let lotusPicArray = ["Lotus Flower", "Lotus Square", "Lotus Heart", "Lotus Circle"]
    let breatheColorArray = ["Breathe Teal", "Breathe Saffron", "Breathe Cherry", "Breathe Lavender"]
    let lotusColorArray = ["Lotus Cassic", "Lotus Forest", "Lotus Outrun", "Lotus Pool Party"]
    
    var breathePic = 0
    var breatheColor = 0
    var lotusPic = 0
    var lotusColor = 0
    
    
    @IBOutlet weak var currentPointsLabel: UILabel!
    @IBOutlet weak var confirmationLabel: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        testUserDefaults()
        print(mtxNum)
        currentPointsLabel.text = "Current Points: " + String(points)
        
        
        if mtxNum == 0{
            confirmationLabel.text = "Confirm Purchase of " + breathePicArray[breathePic]
        }
        else if mtxNum == 1{
            confirmationLabel.text = "Confirm Purchase of " + lotusPicArray[lotusPic]
        }
        else if mtxNum == 2{
            confirmationLabel.text = "Confirm Purchase of " + breatheColorArray[breatheColor]
        }
        else if mtxNum == 3{
            confirmationLabel.text = "Confirm Purchase of " + lotusColorArray[lotusColor]
        }
        
        
    }
    
    
    @IBAction func buyButtonPressed(_ sender: UIButton) {
    }
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    override func testUserDefaults(){
        let defaults = UserDefaults.standard
        
        points = defaults.integer(forKey: "points")
        
        breathePic = defaults.integer(forKey: "breathePic")
        breatheColor = defaults.integer(forKey: "breatheColor")
        lotusPic = defaults.integer(forKey: "lotusPic")
        lotusColor = defaults.integer(forKey: "lotusColor")
    }
    
}
