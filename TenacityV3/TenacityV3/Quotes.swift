//
//  Quotes.swift
//  TenacityV3
//
//  Created by Richie on 8/22/19.
//  Copyright © 2019 PLL. All rights reserved.
//

import Foundation

class Quotes{
    let quotesList: [String] = ["Welcome back! Breathe.",
                                "There’s no need to tightly grip your breath. Place your attention on the breath like your hand is in a stream. Feel the water pass. Let the water come to you.",
                                "Rest your attention lightly, like a butterfly rests on a flower. Can you feel just one breath? Feel without concern for what's gone by, without leaning forward for even the very next breath. Just this one.",
                                "Breath is the target. Attention is the arrow. Aim.",
                                "Only a gentle touch is needed to place attention on the breath, like touching a feather to a bubble.",
                                "Slowly and gently place attention on your breath, approaching it as you might a shy animal sunning itself on a log in a forest clearing. Ever so quietly and gently, with the lightest of touches.",
                                "Ride the waves of your own breathing, as if your attention were a leaf floating on gently lapping waves on a lake. Feeling the full duration of this breath moving into and out of the body.",
                                "You’re practicing not to get anywhere, but to enjoy breathing, to appreciate the simple experience of being alive.",
                                "Imagine your attention were a guitar string. If it’s too tight, it will sound sharp; if it’s too slack, it won’t make music. Tune your mind so it’s neither tense nor sleepy and enjoy the music.",
                                "Just breathe naturally.",
                                "Greet your breath as a welcome visitor, taking interest and letting it come and go. No need to change.",
                                "Breathing connects us with life on this planet. Think of the animals that crawl, walk, hop, run, swim, and fly who breathe in the same air as you breathe.","Close your hand in a tight fist. Now open your palm, like receiving a gift. Let your attention be like an open hand and your breath the gift.",
                                "Get up close and personal with the breath. The breath is not an idea, it’s what you feel. Movement, coolness, pressure. These are words but it isn’t words. It’s the bare sensations, which you are experiencing.",
                                "Awareness of breathing is not about using a lot of willpower to grab and squeeze the mind in one place. Instead it’s letting the mind be open and relaxed, like when taking in a beautiful sunset.",
                                "Showing up is half the battle. Breathe.",
                                "Let your thoughts drift like clouds in the sky, let them pass and change. Breathe.",
                                "Attention is strengthened every time you focus back on your breath.","Wherever you go, your breath is with you. Experiment throughout the day by focusing on your breath.",
                                "As we live, our breath follows our movements—fast and heavy, slow and measured. You can choose to listen to your breath at any moment.","Thoughts and feelings may buzz around your mind like insects. Be curious about the experience. If you let them be, they will not sting or bite. They may even fly away on their own.",
                                "You have the power to shape your mind. Be patient and consistent.",
                                "As you rest at home in your breath, notice how thoughts and feelings come and go - they don’t live there. You can greet them, acknowledge them, and let them go.",
                                "Be kind to yourself, even in the midst of your most difficult learning moments.",
                                "Thoughts and feelings come and go like waves in the ocean. See if you can relax and let the waves of thoughts and feelings pass over you. All that remains is the ocean.",
                                "You are doing very well!","I see the progress you’re making!",
                                "“I change my thoughts, I change my world.” – Norman Vincent Peale",
                                "Patiently practice controlling your attention. Like training a puppy, your mind will run away. Gently return your attention back to your breathing.","Find and feel each breath in your body. Breathe in a rhythm.",
                                "Listen to your body. Notice how you feel after breathing.",
                                "You are not trying to make things turn out the way you want them. You are trying to know what is happening as it is.",
                                "I accept where I am in this training process and I can begin again, over and over.",
                                "Simply breathing a few minutes each day can increase your outlook and health.",
                                "Are you proud of yourself?","Awareness of the breath is staying with the actual breath as it’s happening. One breath at a time.",
                                "We sometimes define ourselves by our thoughts and emotions. When you’re feeling blue, you might believe you’re a sad person. But hitting your funny bone doesn’t make you a sore elbow.",
                                "Training helps the mind observe and reflect without getting lost in the chaos. What is the relationship between you, your thoughts, and your emotions?","Recognizing your mind wandering and rebuilding your focus is exactly what strengthens attention and neural pathways.",
                                "Practice breathing and slowly reduce how much control your rhythm. Let your breath do the work for you. Simply be alert and allow your breathing to happen.","“Be the change you wish to see in the world.” – Gandhi"]
    
    func randomQuote() -> String{
        return quotesList.randomElement()!
    }
    
}
