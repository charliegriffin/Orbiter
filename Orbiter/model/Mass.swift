//
//  Mass.swift
//  Orbiter
//
//  Created by Alex Sieber on 7/5/18.
//  Copyright © 2018 Charles Griffin. All rights reserved.
//

import Foundation
import SpriteKit

public var masses: [Mass] = []
public var G : CGFloat = 6.674 * pow(10,-11)

public class Mass: SKSpriteNode {
    
    public var mass: CGFloat
    public var velocity : CGVector
    public var id : Int
    
//    override public func awakeFromNib() {
//        super.awakeFromNib()
//        //custom logic goes here
//    }
    
    init(texture: SKTexture, id: Int) {
        self.mass = 1
        self.velocity = CGVector(dx: 0, dy: 0)
        self.id = id
        //super.init(texture: texture, color: .white, size: texture.size())
        super.init(texture: texture, color: .white, size: texture.size())
        self.position = CGPoint(x: 0, y: 0)
        
        masses.append(self)
    }
    
    init(imageName: String, id: Int) {
        self.mass = 1
        self.velocity = CGVector(dx: 0, dy: 0)
        self.id = id
        let texture = SKTexture(imageNamed: imageName)
        //super.init(texture: texture, color: .white, size: texture.size())
        super.init(texture: texture, color: .white, size: texture.size())
        self.position = CGPoint(x: 0, y: 0)
        
        masses.append(self)
    }
    required public init(coder aDecoder: NSCoder) {
        self.mass = -1
        self.velocity = CGVector(dx: 0, dy: 0)
        self.id = -1
        super.init(coder: aDecoder)!
        
        masses.append(self)
        
        //self.position = CGPoint(x: 0, y: 0)
        //fatalError("init(coder:) has not been implemented")
    }
    //    //it is the ship's responsibility to travel for the specified amount of time
    //    public func travelLinear(forTime dt: CGFloat) {
    //        // Semi-Implicit Euler integrator
    //        let acceleration = calculateGravitationalAcceleration(position: self.position)
    //        self.velocity.dx += acceleration.dx * dt
    //        self.velocity.dy += acceleration.dy * dt
    //        self.position.x += self.velocity.dx * dt
    //        self.position.y += self.velocity.dy * dt
    //    }
    
    public func travelVerlet(forTime dt: CGFloat) {
        let a1 = calculateGravitationalAcceleration(position: self.position)
        let v_mid = CGVector(dx: self.velocity.dx + a1.dx * dt/2.0, dy: self.velocity.dy + a1.dy * dt/2.0)
        // Valid for F independent of v
        let r2 = CGPoint(x: self.position.x + v_mid.dx * dt, y: self.position.y + v_mid.dy * dt)
        let a2 = calculateGravitationalAcceleration(position: r2)
        let v2 = CGVector(dx: v_mid.dx + a2.dx * dt/2, dy: v_mid.dy + a2.dy * dt/2)
        self.position = r2
        self.velocity = v2
        
        if(self.isKind(of: Ship.self)) {
            (self as! Ship).redrawOrientation(forTime: dt)
            (self as! Ship).path.append(self.position)
            if((self as! Ship).path.count == 500){
                (self as! Ship).drawPath()
            }
        }
    }
    
    func calculateGravitationalAcceleration(position: CGPoint) -> CGVector {
        var accelerationVector = CGVector(dx: 0.0, dy: 0.0)
        for ship in masses {
            if (self.id != ship.id){
                let xDist : CGFloat = (ship.position.x - position.x)
                let yDist : CGFloat = (ship.position.y - position.y)
                let dist : CGFloat = (pow(xDist, 2) + pow(yDist, 2)).squareRoot()
                let mag = min(G * ship.mass / pow(dist, 2),10000)
                accelerationVector.dx += mag * xDist/dist
                accelerationVector.dy += mag * yDist/dist
            }
        }
        return accelerationVector
    }
    
    static func handleCollisions(width: CGFloat, height: CGFloat) -> () {
        //boundary collisions
        for mass in masses {
            self.handleBoundaryCollision(mass: mass, elasticity: 1, width: width, height: height)
            //mass-mass collisions
            for otherMass in masses {
                if(otherMass.id != mass.id) {
                    //mass-mass collisions
                    self.handleMassToMassCollision(mass1: mass, mass2: otherMass, elasticity: 1)
                }
            }
        }
    }
    
    //boundary collision logic
    static func handleBoundaryCollision(mass: Mass, elasticity: CGFloat, width: CGFloat, height: CGFloat) -> () {
        let x = mass.position.x
        let y = mass.position.y
        let w = mass.size.width
        let h = mass.size.height
        if(fabs(x) + w >= fabs(width)) {
            mass.velocity.dx *= -1 * elasticity
        }
        if(fabs(y) + h >= fabs(height)) {
            mass.velocity.dy *= -1 * elasticity
        }
    }
    
    //elastic collision logic recommended by Charlie (restitution not incorporated yet)
    static func handleMassToMassCollision(mass1: Mass, mass2: Mass, elasticity: CGFloat) -> () {
        
        let x1 = mass1.position.x
        let y1 = mass1.position.y
        let x2 = mass2.position.x
        let y2 = mass2.position.y
        
        let dx = x2 - x1
        let dy = y2 - y1
        let dr = CGVector(dx: dx, dy: dy)
        let drMag = sqrt(dx * dx + dy * dy)
        
        let w1 = mass1.size.width
        let w2 = mass2.size.width
        
        if(drMag > 0.5 * (w1 + w2)) {
            return
        }
        //        mass.velocity.dx *= -1
        //        mass.velocity.dy *= -1
        
        let m1 = mass1.mass
        let m2 = mass2.mass
        
        let v1 = mass1.velocity
        let v2 = mass2.velocity
        
        let v1xi = mass1.velocity.dx
        let v1yi = mass1.velocity.dy
        let v2xi = mass2.velocity.dx
        let v2yi = mass2.velocity.dy
        
        let gammaV = atan((v1yi - v2yi) / (v1xi - v2xi))
        let pocAngle = GameScene.getThetaForVector(vector: dr)
        let v1Angle = GameScene.getThetaForVector(vector: v1)
        let alpha = v1Angle - pocAngle
        let a = tan(gammaV + alpha)
        
        if(a > 0.5 * .pi && a < 1.5 * .pi) {
            return
        }
        let dv2x = 2 * (v1xi - v2xi + a * (v1yi - v2yi)) / ((1 + a * a) * (1 + m2 / m1))
        
        let v2xf = v2xi + dv2x
        let v2yf = v2yi + a * dv2x
        let v1xf = v1xi - (m2 / m1) * dv2x
        let v1yf = v1yi - a * (m2 / m1) * dv2x
        
        mass1.velocity.dx = v1xf
        mass1.velocity.dy = v1yf
        mass2.velocity.dx = v2xf
        mass2.velocity.dy = v2yf
        
//        mass1.position.x = x2 + drMag * cos(pocAngle)
//        mass1.position.y = y2 + drMag * sin(pocAngle)
//        mass2.position.x = 0
//        mass2.position.y = 0
    }
    
}
