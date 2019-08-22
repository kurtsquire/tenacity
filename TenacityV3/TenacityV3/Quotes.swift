//
//  Quotes.swift
//  TenacityV3
//
//  Created by Richie on 8/22/19.
//  Copyright © 2019 PLL. All rights reserved.
//

import Foundation

class Quotes{
    let quotesList: [String] = ["Just breathe naturally", "Breath is the target. Attention is the arrow. Aim.", "Walk with the breath as you would walk with a baby brother on the sidewalk, with a gentle but sure hand so he doesn’t run into the street. When the mind strays, guide it back with the same care you’d have for that child, sometimes with just a nudge, and other times with strength as it’s needed.", "Awareness of breathing is not about using a lot of willpower to grab and squeeze the mind in one place. Instead it’s letting the mind be open and relaxed, like you would taking in a beautiful sunset.", "Half of life is just showing up. Breathe!"]
    
    func randomQuote() -> String{
        return quotesList.randomElement()!
    }
    
}
