//
//  Slingshot.swift
//  Orbiter
//
//  Created by Alex Sieber on 7/5/18.
//  Copyright © 2018 Charles Griffin. All rights reserved.
//

import Foundation
import SpriteKit

public class Slingshot: SKShapeNode {
    
    public var k: CGFloat
    public var initPos: CGPoint
    public var finalPos: CGPoint
    
    public override init() {
        self.k = 5
        self.initPos = CGPoint(x: 0, y: 0)
        self.finalPos = CGPoint(x: 0, y: 0)
        super.init()
        self.strokeColor = .yellow
        self.path = CGMutablePath()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func attachToInitPos(initPos: CGPoint) {
        
        let path = self.path as! CGMutablePath
        self.initPos = initPos
        path.move(to: self.initPos)
        self.path = path
    }
    
    public func stretchFromInitPosToShip(ship: Ship) {
        
        var path = self.path as! CGMutablePath
        path = CGMutablePath()
        path.move(to: self.initPos)
        self.finalPos = ship.position
        path.addLine(to: self.finalPos)
        self.path = path
        
        let slingX = self.finalPos.x - self.initPos.x
        let slingY = self.finalPos.y - self.initPos.y
        let slingDist = sqrt(slingX * slingX + slingY * slingY)
        
        self.lineWidth = ship.size * (0.2 / (1 + (slingDist / 250)))
    }
    
    //just for troubleshooting
    public func printSlingDistance() {
        
        let slingX = self.finalPos.x - self.initPos.x
        let slingY = self.finalPos.y - self.initPos.y
        let slingDist = sqrt(slingX * slingX + slingY * slingY)
        
        print("Sling Distance: ", slingDist)
    }
    
}
