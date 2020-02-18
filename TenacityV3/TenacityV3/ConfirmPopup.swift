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
    
    
    let breathePicArray = ["Breathe Classic", "Breathe Fire", "Breathe Cloud", "Breathe Diamond", "Egg 1", "Egg 2", "Egg 3", "Egg 4", "Egg 5", "Egg 6"]
    let lotusPicArray = ["Lotus Flower", "Lotus Square", "Lotus Heart", "Lotus Circle"]
    let breatheColorArray = ["Breathe Teal", "Breathe Saffron", "Breathe Cherry", "Breathe Lavender"]
    let lotusColorArray = ["Lotus Cassic", "Lotus Forest", "Lotus Outrun", "Lotus Pool Party"]
    
    var breathePic = 0
    var breatheColor = 0
    var lotusPic = 0
    var lotusColor = 0
    
    var mtxOwnedBreathe = [0]
    var mtxOwnedBreatheC = [0]
    var mtxOwnedLotus = [0]
    var mtxOwnedLotusC = [0]
    
    var pointCost = 250
    
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var currentPointsLabel: UILabel!
    @IBOutlet weak var confirmationLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        testUserDefaults()
        currentPointsLabel.text = "Current Points: " + String(points)
        
        if mtxNum == 0{
            confirmationLabel.text = "Confirm Purchase of " + breathePicArray[mtxTemp]
        }
        else if mtxNum == 1{
            confirmationLabel.text = "Confirm Purchase of " + lotusPicArray[mtxTemp]
        }
        else if mtxNum == 2{
            confirmationLabel.text = "Confirm Purchase of " + breatheColorArray[mtxTemp]
        }
        else if mtxNum == 3{
            confirmationLabel.text = "Confirm Purchase of " + lotusColorArray[mtxTemp]
        }
    }
    
    
    @IBAction func buyButtonPressed(_ sender: UIButton) {
        if points >= pointCost{
            points -= pointCost
            UserDefaults.standard.set(points, forKey: "points")
            if mtxNum == 0{
                mtxOwnedBreathe.append(mtxTemp)
                UserDefaults.standard.set(mtxOwnedBreathe, forKey: "mtxOwnedBreathe")
                
            }
            else if mtxNum == 1{
                mtxOwnedLotus.append(mtxTemp)
                UserDefaults.standard.set(mtxOwnedLotus, forKey: "mtxOwnedLotus")
            }
            else if mtxNum == 2{
                mtxOwnedBreatheC.append(mtxTemp)
                UserDefaults.standard.set(mtxOwnedBreatheC, forKey: "mtxOwnedBreatheC")
            }
            else if mtxNum == 3{
                mtxOwnedLotusC.append(mtxTemp)
                UserDefaults.standard.set(mtxOwnedLotusC, forKey: "mtxOwnedLotusC")
            }
            PurchaseManager.shared.firstVC.testUserDefaults()
            PurchaseManager.shared.firstVC.updateLabelsOpen()
            dismiss(animated: true)
        }
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    override func testUserDefaults(){
        let defaults = UserDefaults.standard
        
        points = defaults.integer(forKey: "points")
        
        //checks which mtx are already owned
        mtxOwnedBreathe = defaults.array(forKey: "mtxOwnedBreathe") as? [Int] ?? [0]
        mtxOwnedBreatheC = defaults.array(forKey: "mtxOwnedBreatheC") as? [Int] ?? [0]
        mtxOwnedLotus = defaults.array(forKey: "mtxOwnedLotus") as? [Int] ?? [0]
        mtxOwnedLotusC = defaults.array(forKey: "mtxOwnedLotusC") as? [Int] ?? [0]
    }
}
