//
//  BackgroundStar.swift
//  Orbiter
//
//  Created by Alex Sieber on 7/18/18.
//  Copyright © 2018 Alex Sieber. All rights reserved.
//

import Foundation
import SpriteKit

public class BackgroundStar : SKShapeNode {
    
    private var radius: CGFloat
    
    //required by Swift for implementation
    public override init() {
        self.radius = 10
        super.init()
        self.position.x = 0
        self.position.y = 0
        self.fillColor = .white
    }
    //the desired initializer for a new Ship object with size relative to the screen
    public convenience init(x: CGFloat, y: CGFloat, radius: CGFloat) {
        self.init(circleOfRadius: radius)
        self.position.x = x
        self.position.y = y
        self.radius = radius
        self.fillColor = .white
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
