//
//  Ship.swift
//  Orbiter
//
//  Created by Alex Sieber on 7/5/18.
//  Copyright © 2018 Charles Griffin. All rights reserved.
//

import Foundation
import SpriteKit

struct CartesianVector {
    var x : CGFloat
    var y : CGFloat
}

public class Ship: SKShapeNode {
    
    public var mass: CGFloat
    public var size: CGFloat
    public var velocity : CGVector
    public var actingMass : CGFloat = 1000000000000000000  // lol gravity is weak
    var actingPosition = CartesianVector(x: 0, y: 0)
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
        self.mass = 1
        self.size = size
        //self.velocity = CGVector(dx: -100, dy: -100)
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
        self.velocity.dx += acceleration.x * dt
        self.velocity.dy += acceleration.y * dt
        self.position.x += self.velocity.dx * dt
        self.position.y += self.velocity.dy * dt
    }
    
    public func travelVerlet(forTime dt: CGFloat) {
        let a1 = calculateGravitationalAcceleration(position: self.position)
        let v_mid = self.velocity.dx + a1.x * dt/2.0
        // Valid for F independent of v
        
        let x2 = self.position.x + v_mid * dt
        let y2 = x2
        let a2 = calculateGravitationalAcceleration(position: CGPoint(x: x2, y: y2))
        let v2 = v_mid + a2.x * dt/2
    }
    
    func calculateGravitationalAcceleration(position: CGPoint) -> CartesianVector {

        let xDist : CGFloat = (actingPosition.x - self.position.x)
        let yDist : CGFloat = (actingPosition.y - self.position.y)
        let dist : CGFloat = (pow(xDist, 2) + pow(yDist, 2)).squareRoot()
        let magnitude : CGFloat = min(G * actingMass / pow(dist, 2),10000)
        
        print(dist)
        // Min function meant to avoid exrreme behavior where collisions would happen (asymptotic r)
        return CartesianVector(x: magnitude * xDist/dist, y: magnitude * yDist/dist)
    }
    
}
