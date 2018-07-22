//
//  Ship.swift
//  Orbiter
//
//  Created by Alex Sieber on 7/5/18.
//  Copyright © 2018 Charles Griffin. All rights reserved.
//

import Foundation
import SpriteKit

public class Ship: SKShapeNode {
    
    public var mass: CGFloat
    public var size: CGFloat
    public var velocity : CGVector
    public var actingMass : CGFloat = 1000000000000000000  // lol gravity is weak
    var actingPosition = CGPoint(x: 0, y: 0)
    public var G : CGFloat = 6.674 * pow(10,-11)
    
    //required by Swift for implementation
    public override init() {
        self.mass = 1
        self.size = 1
        self.velocity = CGVector(dx: 0, dy: 0)
        super.init()
        self.position = CGPoint(x: 0, y: 0)
        self.fillColor = .brown
    }
    //the desired initializer for a new Ship object with size relative to the screen
    public convenience init(size: CGFloat) {
        self.init(rectOf: CGSize.init(width: size, height: size), cornerRadius: size * 0.3)
        //self.init
        self.mass = 1
        self.size = size
        self.velocity = CGVector(dx: 0, dy: 0)
        self.position = CGPoint(x: 0, y: 0)
        self.fillColor = .brown
    }
    //required by Swift
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //it is the ship's responsibility to travel for the specified amount of time
    public func travelLinear(forTime dt: CGFloat) {
        // Semi-Implicit Euler integrator
        let acceleration = calculateGravitationalAcceleration(position: self.position)
        self.velocity.dx += acceleration.dx * dt
        self.velocity.dy += acceleration.dy * dt
        self.position.x += self.velocity.dx * dt
        self.position.y += self.velocity.dy * dt
    }
    
    public func travelVerlet(forTime dt: CGFloat) {
        let a1 = calculateGravitationalAcceleration(position: self.position)
        let v_mid = CGVector(dx: self.velocity.dx + a1.dx * dt/2.0, dy: self.velocity.dy + a1.dy * dt/2.0)
        // Valid for F independent of v
        
        let r2 = CGPoint(x: self.position.x + v_mid.dx * dt, y: self.position.y + v_mid.dy * dt)
        let a2 = calculateGravitationalAcceleration(position: r2)
        let v2 = CGVector(dx: v_mid.dx + a2.dx * dt/2, dy: v_mid.dy + a2.dy * dt/2)
        
        self.position = r2
        self.velocity = v2
    }
    
    func calculateGravitationalAcceleration(position: CGPoint) -> CGVector {

        let xDist : CGFloat = (actingPosition.x - position.x)
        let yDist : CGFloat = (actingPosition.y - position.y)
        let dist : CGFloat = (pow(xDist, 2) + pow(yDist, 2)).squareRoot()
        let magnitude : CGFloat = min(G * actingMass / pow(dist, 2),10000)
        
        return CGVector(dx: magnitude * xDist/dist, dy: magnitude * yDist/dist)
    }
    
    public func thrust(forTime dt: CGFloat, towardPoint point: CGPoint) {
        
        if(point == nil) {
            return
        }
        let dx = point.x - self.position.x
        let dy = point.y - self.position.y
        
        if(dx == 0 && dy == 0) { //double check logic here
            return
        }
        let vx = self.velocity.dx
        let vy = self.velocity.dy
        
        let aMax = CGFloat(6500) //maximum engine strength
        
        let u = CGFloat(0.9) //stability coefficient (favors final deceleration)
        let v = CGFloat(2.5) //reactivity coefficient (favors initial acceleration)
        
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
