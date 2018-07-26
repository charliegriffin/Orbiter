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
    
    public var k: CGFloat //how "strong" the slingshot will be
    public var isSlinging: Bool
    public var startPoint: CGPoint
    public var vector: CGVector
    
    //this required slingshot initializer
    public override init() {
        self.k = 2
        self.isSlinging = false
        self.startPoint = CGPoint(x: 0, y: 0)
        self.vector = CGVector(dx: 0, dy: 0)
        super.init()
        self.strokeColor = .yellow
        self.lineWidth = 10
        self.path = CGMutablePath()
    }
    
    //this method was required for implementation
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //anchor the start point of the slingshot to that of the ship
    public func attachToShip(ship: Ship) {
        self.isSlinging = true
        self.startPoint = ship.position
        self.vector = CGVector(dx: 0, dy: 0)
    }
    
    //redraw the slingshot when you move your finger around
    public func drawFromShipToFinalPos(finalPos: CGPoint) {
        //model the vecotr data
        let dx = finalPos.x - self.startPoint.x
        let dy = finalPos.y - self.startPoint.y
        self.vector = CGVector(dx: dx, dy: dy)
        //redraw the slingshot
        var path = self.path as! CGMutablePath
        path = CGMutablePath()
        path.move(to: self.startPoint)
        path.addLine(to: finalPos)
        self.path = path
    }
    
    //sling the ship
    public func detachFromShip(ship: Ship) {
        self.isSlinging = false
        //provide the ship with its initial velocity
        ship.velocity = CGVector(dx: k * self.vector.dx, dy: k * self.vector.dy)
        //reset the slingshot data
        self.startPoint = CGPoint(x: 0, y: 0)
        self.vector = CGVector(dx: 0, dy: 0)
    }
    
}
