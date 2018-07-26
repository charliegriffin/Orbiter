//
//  GameScene.swift
//  Orbiter
//
//  Created by Alex Sieber on 7/7/18.
//  Copyright © 2018 Alex Sieber. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var fingerPoint : CGPoint?
    
    private var masses : [Mass] = []
    public var G : CGFloat = 6.674 * pow(10,-11)
    
    private var ship : Ship?
    private var earth : Mass?
    private var moon : Mass?
    private var slingShot : SlingShot?
    
    private var screenWidth : CGFloat?
    private var screenHeight : CGFloat?
    private var previousTime : TimeInterval?
    
    override func didMove(to view: SKView) {
        //initialize instance variables when the controller switches to this view
        self.screenWidth = view.frame.width
        self.screenHeight = view.frame.height
        print(self.screenWidth, self.screenHeight)
        
        //INITIALIZE EARTH
        self.earth = Mass(imageName: "earth.png", id: 1)
        self.earth?.mass = 1000000000000000000
        self.earth?.position.x = 0
        self.earth?.position.y = 0
        self.earth?.velocity.dx = 0        // virial thm benchmark
        // produces stable orbit
        self.earth?.velocity.dy = 0
        self.addChild(self.earth!)
        
        //INITIALIZE MOON
        self.moon = Mass(imageName: "moon.png", id: 2)
        self.moon?.mass = 0.107
        self.moon?.position.x = 0
        //self.moon?.position.y = 1.524 * 250
        self.moon?.position.y = 1.524 * 200
        self.moon?.velocity.dx = ((self.G) * (self.earth?.mass)! / (self.moon?.position.y)!).squareRoot()
        self.moon?.velocity.dy = 0
        self.addChild(self.moon!)
        
        //INITALIZE SHIP
        self.ship = Ship(imageName: "spaceship.png", id: 0)
        self.ship?.position.x = 0
        self.ship?.position.y = 175
        self.ship?.mass = 0.0000000001
        self.ship?.velocity.dx = -((self.G) * (self.earth?.mass)! / (self.ship?.position.y)!).squareRoot()
        // virial thm benchmark
        // produces stable orbit
        self.ship?.velocity.dy = 0
        self.addChild(self.ship!)
        
        self.slingShot = SlingShot()
        self.previousTime = -1
        
        //INITIALIZE BACKGROUND STARS
        //remove the below 4 line to remove background & improve simulator FPS
        let background = Background(frame: (self.view?.frame)!)
        for star in background.backgroundStars {
            self.addChild(star)
        }
        self.masses.append(self.ship!)
        self.masses.append(self.earth!)
        self.masses.append(self.moon!)
        
        self.fingerPoint = nil
        
        print("STARTING APP")
    }
    
    //when you place your finger on the screen
    func touchDown(atPoint pos : CGPoint) {
        
        self.ship?.isThrusting = true
        self.fingerPoint = pos
        
        //UNCOMMENT BELOW & COMMENT OUT ABOVE FOR SLINGSHOT
        
        //        //place the ship at the position
        //        self.ship?.position = pos
        //        self.ship?.velocity = CGVector(dx: 0, dy: 0)
        //        //if the slingshot is still slinging when you reposition the ship, get rid of the slingshot first
        //        if(self.slingShot?.isSlinging)! {
        //            self.slingShot?.removeFromParent()
        //        }
        //        //anchor the slingshot to the ship
        //        self.slingShot = SlingShot()
        //        self.slingShot?.attachToShip(ship: self.ship!)
        //        //add the slingshot to the scene
        //        self.addChild(self.slingShot!)
    }
    
    //when you drag your finger on the screen
    func touchMoved(toPoint pos : CGPoint) {
        
        self.fingerPoint = pos
        
        //UNCOMMENT BELOW & COMMENT OUT ABOVE FOR SLINGSHOT
        
        //        //redraw the slingshot
        //        self.slingShot?.drawFromShipToFinalPos(finalPos: pos)
    }
    
    //when you lift your finger off the screen
    func touchUp(atPoint pos : CGPoint) {
        
        self.ship?.isThrusting = false
        self.fingerPoint = nil
        
        //UNCOMMENT BELOW & COMMENT OUT ABOVE FOR SLINGSHOT
        
        //        //sling the ship
        //        self.slingShot?.detachFromShip(ship: self.ship!)
        //        //get rid of the slingshot from the scene
        //        self.slingShot?.removeFromParent()
    }
    
    //the below 4 methods were not added by Alex
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    //update the model data and redraw the scene at the beginning of each new frame (every 1/60 of a second)
    override func update(_ currentTime: TimeInterval) {
        
        if(previousTime == -1) {
            self.previousTime = currentTime
            print("INITIALIZING PREVIOUS TIME")
            return
        }
        let dt : CGFloat = 0.01
        
        //only let gravity effect the ship when it's not slinging
        //        if(!(self.slingShot?.isSlinging)!) {
        //            self.ship?.travelVerlet(forTime: dt)
        //        }
        
        self.travelVerlet(forTime: dt)
        
        self.handleCollisions()
        
        //update ship orientation (put into a method for the ship)
        let shipDirection = getThetaForVector(vector: (self.ship?.velocity)!)
        let rotate = SKAction.rotate(toAngle: shipDirection, duration: TimeInterval(dt))
        self.ship?.run(rotate)
        
        //        self.ship?.travelVerlet(forTime: dt)
        //        self.earth?.travelVerlet(forTime: dt)
        //        self.moon?.travelVerlet(forTime: dt)
        
        //        for mass in (self.earth?.masses)! {
        //            mass.travelVerlet(forTime: dt)
        //        }
        
        self.previousTime = currentTime
    }
    
    //generalized this function to make all masses, including the ship, travel for dt at once
    public func travelVerlet(forTime dt: CGFloat) {
        //for each mass in the scene
        for mass in self.masses {
            //if it's the ship
            if(mass.isKind(of: Ship.self)) {
                //and it's slinging
                if(self.slingShot?.isSlinging)! {
                    //Don't be effected by gravity
                } else {
                    //and it's thrusting
                    if(self.ship?.isThrusting)! {
                        //let it thrust
                        self.ship?.thrust(forTime: dt, towardPoint: self.fingerPoint!)
                    }
                    //then let it be effected by gravity as well
                    let a1 = calculateGravitationalAcceleration(position: mass.position)
                    let v_mid = CGVector(dx: mass.velocity.dx + a1.dx * dt/2.0, dy: mass.velocity.dy + a1.dy * dt/2.0)
                    // Valid for F independent of v
                    let r2 = CGPoint(x: mass.position.x + v_mid.dx * dt, y: mass.position.y + v_mid.dy * dt)
                    let a2 = calculateGravitationalAcceleration(position: r2)
                    let v2 = CGVector(dx: v_mid.dx + a2.dx * dt/2, dy: v_mid.dy + a2.dy * dt/2)
                    
                    mass.position = r2
                    mass.velocity = v2
                }
            } else {
                //if it's not the ship, simply let it travel according to gravity
                let a1 = calculateGravitationalAcceleration(position: mass.position)
                let v_mid = CGVector(dx: mass.velocity.dx + a1.dx * dt/2.0, dy: mass.velocity.dy + a1.dy * dt/2.0)
                // Valid for F independent of v
                let r2 = CGPoint(x: mass.position.x + v_mid.dx * dt, y: mass.position.y + v_mid.dy * dt)
                let a2 = calculateGravitationalAcceleration(position: r2)
                let v2 = CGVector(dx: v_mid.dx + a2.dx * dt/2, dy: v_mid.dy + a2.dy * dt/2)
                
                mass.position = r2
                mass.velocity = v2
            }
        }
    }
    
    func calculateGravitationalAcceleration(position: CGPoint) -> CGVector {
        
        var accelerationVector = CGVector(dx: 0.0, dy: 0.0)
        
        for mass in self.masses {
            
            if(mass.position != position) {
                let xDist : CGFloat = (mass.position.x - position.x)
                let yDist : CGFloat = (mass.position.y - position.y)
                let dist : CGFloat = (pow(xDist, 2) + pow(yDist, 2)).squareRoot()
                let mag = min(G * mass.mass / pow(dist, 2),10000)
                accelerationVector.dx += mag * xDist/dist
                accelerationVector.dy += mag * yDist/dist
            }
        }
        return accelerationVector
    }
    
    func handleCollisions() -> () {
        //boundary collisions
        for mass in self.masses {
            
            self.handleBoundaryCollision(mass: mass, elasticity: 1)
            
            //mass-mass collisions
            for otherMass in self.masses {
                if(otherMass.id != mass.id) {
                    //mass-mass collisions
                    self.handleMassToMassCollision(mass1: mass, mass2: otherMass, elasticity: 1)
                }
            }
        }
    }
    
    //boundary collision logic
    func handleBoundaryCollision(mass: Mass, elasticity: CGFloat) -> () {
        
        let x = mass.position.x
        let y = mass.position.y
        
        let w = mass.size.width
        let h = mass.size.height
        
        if(fabs(x) + w >= fabs(CGFloat(self.screenWidth!))) {
            mass.velocity.dx *= -1 * elasticity
        }
        if(fabs(y) + h >= fabs(CGFloat(self.screenHeight!))) {
            mass.velocity.dy *= -1 * elasticity
        }
    }
    
    //elastic collision logic recommended by Charlie (restitution not incorporated yet)
    func handleMassToMassCollision(mass1: Mass, mass2: Mass, elasticity: CGFloat) -> () {
        
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
        
        if(drMag > (w1 + w2) / 2) {
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
        let pocAngle = self.getThetaForVector(vector: dr)
        let v1Angle = self.getThetaForVector(vector: v1)
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
    }
    
    //returns theta between 0 and 2pi for any vector
    func getThetaForVector(vector: CGVector) -> CGFloat {
        
        var vx = vector.dx
        var vy = vector.dy
        
        let zero = CGFloat(0)
        var theta = CGFloat(0)
        
        if(self.slingShot?.isSlinging)! {
            vx = (self.slingShot?.vector.dx)!
            vy = (self.slingShot?.vector.dy)!
        }
        
        if(vx == 0 && vy == 0) {
            return theta
        }
        
        if(vx >= zero && vy >= zero) {
            theta = atan( vy / vx )
        } else if(vx <= 0 && vy >= 0) {
            theta = .pi + atan( vy / vx )
        } else if(vx <= 0 && vy <= 0) {
            theta = .pi + atan( vy / vx )
        } else {
            theta = .pi * 2 + atan( vy / vx )
        }
        theta -= .pi / 2
        return theta
    }
}
