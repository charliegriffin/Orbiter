//
//  Slingshot.swift
//  Orbiter
//
//  Created by Alex Sieber on 7/5/18.
//  Copyright © 2018 Charles Griffin. All rights reserved.
//

import Foundation
import SpriteKit

public class SlingShot: SKShapeNode {
    
    //the sping constant of this slingshot
    public var k: CGFloat
    //the endpoints of the slingshot (ship is at final)
    public var initPos: CGPoint
    public var finalPos: CGPoint
    //theta always just equal to the arctan of finalPos & initPos
    public var theta: CGFloat
    public var prevTheta: CGFloat
    //radius always just equal to the distance between finalPos & initPos
    public var radius: CGFloat
    //isSlinging used to determine whether or not the slingshot is currently slinging the ship
    public var isSlinging: Bool
    
    //this required slingshot initializer
    public override init() {
        self.k = 5
        self.initPos = CGPoint(x: 0, y: 0)
        self.finalPos = CGPoint(x: 0, y: 0)
        self.theta = 0
        self.prevTheta = 0
        self.radius = 0
        self.isSlinging = false
        super.init()
        self.strokeColor = .yellow
        self.path = CGMutablePath()
    }
    
    //this method was required for implementation
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //anchor the initial position of the slingshot to a point
    public func attachToInitPos(initPos: CGPoint) {
        //redraw the slingshot
        let path = self.path as! CGMutablePath
        self.initPos = initPos
        self.isSlinging = false
        path.move(to: self.initPos)
        self.path = path
    }
    
    //stretch the slingshot from its initial anchor point position to the current location of the ship
    public func stretchFromInitPosToShip(ship: Ship) {
        //redraw the slingshot
        var path = self.path as! CGMutablePath
        path = CGMutablePath()
        path.move(to: self.initPos)
        self.finalPos = ship.position
        path.addLine(to: self.finalPos)
        self.path = path

        self.prevTheta = self.theta
        
        let slingX = self.initPos.x - self.finalPos.x
        let slingY = self.initPos.y - self.finalPos.y
        //set theta to a value between 0 and 2 pi
        if(slingX >= 0 && slingY >= 0) {
            self.theta = atan( slingY / slingX )
        } else if(slingX <= 0 && slingY >= 0) {
            self.theta = .pi + atan( slingY / slingX )
        } else if(slingX <= 0 && slingY <= 0) {
            self.theta = .pi + atan( slingY / slingX )
        } else {
            self.theta = .pi * 2 + atan( slingY / slingX )
        }
        //set the radius variable
        let slingDist = sqrt(slingX * slingX + slingY * slingY)
        self.radius = slingDist
        //redraw the slingshot's width depending upon how far it's being stretched
        self.lineWidth = ship.size * (0.2 / (1 + (slingDist / ship.size)))
    }
    
    //sling the ship for the specified amount of time
    public func accelerateShip(ship: Ship, forTime dt: CGFloat) {
        
        self.isSlinging = true
        //set variables used for motion equations
        let t = dt
        let m = ship.mass
        let w = sqrt(self.k/m)
        let r = self.radius
        let vx0 = ship.velocity.dx
        let vy0 = ship.velocity.dy
        
        //get the ship's intial position and velocity magnitudes
        let p0 = r
        let v0 = sqrt( vx0 * vx0 + vy0 * vy0 )
        //physics equations for motion of a mass on a spring
        let p =  p0 * cos(w * t) + v0 * sin(w * t) / w
        let v = -w * p0 * sin(w * t) + v0 * cos(w * t)
        
        //ship.travel(forTime: dt)
        
        //update the ship's position according to the above equation
//        ship.position.x -= p0 * cos(self.theta) - p * cos(self.theta)
//        ship.position.y -= p0 * sin(self.theta) - p * sin(self.theta)
        
        //update the ship's velocity according to the above equation
        ship.velocity.dx += v0 * cos(self.theta) - v * cos(self.theta)
        ship.velocity.dy += v0 * sin(self.theta) - v * sin(self.theta)
        
        //set the slingshot's radius to the new magnitude
        self.radius = p
        //redraw the slingshot
        self.stretchFromInitPosToShip(ship: ship)
        
        //when the ship "crosses" the initial anchor point of the slingshot, release it
        if(abs(.pi - abs(self.prevTheta - self.theta)) <= 0.1) {
            self.isSlinging = false
        }
    }
    
}
