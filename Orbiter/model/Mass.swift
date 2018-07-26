//
//  Mass.swift
//  Orbiter
//
//  Created by Alex Sieber on 7/5/18.
//  Copyright © 2018 Charles Griffin. All rights reserved.
//

import Foundation
import SpriteKit

public class Mass: SKSpriteNode {
    
    //public var masses: [Mass] = []
    
    public var mass: CGFloat
    public var velocity : CGVector
    public var id : Int
    
    init(imageName: String, id: Int) {
        self.mass = 1
        self.velocity = CGVector(dx: 0, dy: 0)
        self.id = id
        let texture = SKTexture(imageNamed: imageName)
        //super.init(texture: texture, color: .white, size: texture.size())
        super.init(texture: texture, color: .white, size: texture.size())
        self.position = CGPoint(x: 0, y: 0)
        
        //masses.append(self)
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
