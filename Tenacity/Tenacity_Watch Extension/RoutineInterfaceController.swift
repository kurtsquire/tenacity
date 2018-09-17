//
//  RoutineInterfaceController.swift
//  Tenacity_Watch Extension
//
//  Created by PLL on 8/30/18.
//  Copyright © 2018 PLL. All rights reserved.
//

import Foundation
import WatchKit

var ToDo = [Date:[(String,Bool)]] ()
class RoutineInterfaceController: WKInterfaceController {
    var date = Date()
    @IBOutlet var CurrentDate: WKInterfaceLabel!
    @IBOutlet var ToDoList: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: Date())
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "dd-MMM-yyyy"
        let myStringafd = formatter.string(from: yourDate!)
        
        ToDo[date] = [("game1",true),("game2",false),("game3",true)]
        let daoof = ToDo[date]
        
        CurrentDate.setText(myStringafd)
        var str = String()
        for tuple in (daoof)!{
            let appendstr = "\(tuple.0): \(tuple.1) \n"
            str = "\(str) \(appendstr)"
        }
        //ToDoList.setText(str)
    }
    
}
