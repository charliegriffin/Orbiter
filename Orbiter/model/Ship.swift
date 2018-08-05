//
//  Ship.swift
//  Orbiter
//
//  Created by Alex Sieber on 7/5/18.
//  Copyright © 2018 Charles Griffin. All rights reserved.
//

import Foundation
import SpriteKit

public class Ship: Mass {
    
    public var isThrusting : Bool = false
    
    public override init(texture: SKTexture, id: Int) {
        super.init(texture: texture, id: id)
        self.isThrusting = false
    }
    
    public override init(imageName: String, id: Int) {
        super.init(imageName: imageName, id: id)
        self.isThrusting = false
    }
    
    required public init(coder aDecoder: NSCoder) {
        self.isThrusting = false
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    public func redrawOrientation(forTime dt: CGFloat) {
        //update ship orientation (put into a method for the ship)
        let shipDirection = GameScene.getThetaForVector(vector: self.velocity)
        let rotate = SKAction.rotate(toAngle: shipDirection, duration: TimeInterval(dt))
        self.run(rotate)
    }
    
    public func thrust(forTime dt: CGFloat, towardPoint point: CGPoint) {
        
        //        if(point == nil) {
        //            return
        //        }
        let dx = point.x - self.position.x
        let dy = point.y - self.position.y
        
        if(dx == 0 && dy == 0) { //double check logic here
            return
        }
        let vx = self.velocity.dx
        let vy = self.velocity.dy
        
        let aMax = CGFloat(5000) //maximum engine strength (6500)
        
        let u = CGFloat(0.9) //stability coefficient (favors final deceleration & velocity control)
        let v = CGFloat(2.5) //reactivity coefficient (favors initial acceleration & point attraction)
        
        //alex sigmoid thrust functions
        var ax = (2 * aMax) / (1 + pow( CGFloat(M_E), u * vx - v * dx )) - aMax
        var ay = (2 * aMax) / (1 + pow( CGFloat(M_E), u * vy - v * dy )) - aMax
        
        var a = sqrt(ax * ax + ay * ay)
        var c = CGFloat(1)
        
        if(a > aMax) {
            c = sqrt((aMax * aMax) / (a * a)) //supply/demand ratio
            ax *= c
            ay *= c
            a = sqrt(ax * ax + ay * ay)
        }
        //print(ax, ay, a, c)
        self.velocity.dx += ax * dt
        self.velocity.dy += ay * dt
        self.position.x += self.velocity.dx * dt
        self.position.y += self.velocity.dy * dt        
    }
    
}
