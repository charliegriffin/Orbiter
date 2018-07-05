//
//  GameScene.swift
//  Orbiter
//
//  Created by Alex Sieber on 7/5/18.
//  Copyright © 2018 Charles Griffin. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    
    private var ship : Ship?
    private var slingshot : Slingshot?
    
    override func didMove(to view: SKView) {
        
        // Create shape node to use during mouse interaction
        let screenSize = (self.size.width + self.size.height) * 0.05
        self.ship = Ship(size: screenSize)
        self.addChild(self.ship!)
        self.slingshot = Slingshot()
        print("STARTING SCENE")
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
        self.slingshot = Slingshot()
        self.slingshot?.attachToInitPos(initPos: pos)
        self.addChild(self.slingshot!)
        self.ship!.position = pos
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
        self.ship!.position = pos
        self.slingshot?.stretchFromInitPosToShip(ship: self.ship!)
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
        self.slingshot?.printSlingDistance()
        self.slingshot?.removeFromParent()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        if let label = self.label {
        //            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        //        }
        
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
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
