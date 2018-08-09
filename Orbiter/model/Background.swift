//
//  Background.swift
//  Orbiter
//
//  Created by Alex Sieber on 7/19/18.
//  Copyright © 2018 Alex Sieber. All rights reserved.
//

import Foundation
import SpriteKit

public class Background {
    
    public var backgroundStars: [BackgroundStar] = [BackgroundStar]()
    
    public init(frame: CGRect) {
    
        let w = frame.width
        let h = frame.height
        self.backgroundStars = [BackgroundStar]()
        
        for _ in 1...250 {
            let xRand = (2 * CGFloat(drand48()) - 1) * w
            let yRand = (2 * CGFloat(drand48()) - 1) * h
            let radiusRand =  (w / 150) + (w / 300) * (2 * CGFloat(drand48()) - 1)
            self.backgroundStars.append(BackgroundStar(x: xRand, y: yRand, radius: radiusRand))
        }
        
        var count = 0
        
        for star in self.backgroundStars {
            
            count = (count + 1) % 2
            
            if(count == 0) {
                let periodRand = Double(1.5 + (2 * CGFloat(drand48()) - 1) * 0.45)
                let fadeOut = SKAction.fadeOut(withDuration: periodRand)
                let fadeIn = SKAction.fadeIn(withDuration: periodRand)
                let pulse = SKAction.sequence([fadeOut,fadeIn])
                let pulseForever = SKAction.repeatForever(pulse)
                star.run(pulseForever)
            }
        }
    }

}
