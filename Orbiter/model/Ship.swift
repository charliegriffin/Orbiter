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
    var actingMass : CGFloat = 10000000000000000
    var actingPosition : CGFloat = 0
    var G : CGFloat = 6.674 * pow(10,-11)
    
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
        //basic kinematic equations for the ship flying away (or sitting still)
        self.position.x += self.velocity.dx * dt
        self.position.y += self.velocity.dy * dt
        self.velocity.dx += calculateGravitationalAcceleration() * dt
        print(calculateGravitationalAcceleration())
//        self.velocity.dy += self.velocity.dx + calculateGravitationalAcceleration() * dt
//        print("position \(self.position)")
        print("velocity \(self.velocity)")
    }
    
    func calculateGravitationalAcceleration() -> CGFloat {
        let direction : CGFloat = (actingPosition - self.position.x) < 0 ? -1 : 1
//        print("direction \(direction)")
        return direction * G * actingMass / pow((actingPosition - self.position.x),2)
    }
    
}
