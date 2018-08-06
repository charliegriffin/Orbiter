//
//  GameScene.swift
//  Orbiter
//
//  Created by Alex Sieber on 7/7/18.
//  Copyright © 2018 Alex Sieber. All rights reserved.
//

import SpriteKit
import GameplayKit

class LevelThree: SKScene {
    
    private var ship : Ship?
    private var mars : Mass?
    private var fingerPoint : CGPoint?
    private var screenWidth : CGFloat?
    private var screenHeight : CGFloat?
    
    
    
    override func didMove(to view: SKView) {
        //initialize instance variables when the controller switches to this view
        self.screenWidth = view.frame.width
        self.screenHeight = view.frame.height
        
        //make sure the child actually is of the Ship class
        if let shipNode : Ship = self.childNode(withName: "shipNode") as? Ship {
            //make the declared variable equal to shipNode
            self.ship = shipNode
            print(self.ship?.parent)
        }
        //make sure the child actually is of the Mass class
        if let marsNode : Mass = self.childNode(withName: "marsNode") as? Mass {
            //make the declared variable equal to earthNode
            self.mars = marsNode
        }
        //initialize non-default earth values
        self.mars?.mass = 1000000000000000000
        self.mars?.id = 1
        //initialize non-default ship values
        self.ship?.mass = 0.000000000000000001
        self.ship?.id = 0
        self.ship?.velocity.dx = 0.9*((G) * (self.mars?.mass)! / (self.ship?.position.y)!).squareRoot()
        
        print("STARTING APP")
    }
    
    //when you place your finger on the screen
    func touchDown(atPoint pos : CGPoint) {
//        self.ship?.isThrusting = true
        self.fingerPoint = pos
        
        self.ship?.drawPath()
    
    }
    
    //when you drag your finger on the screen
    func touchMoved(toPoint pos : CGPoint) {
        self.fingerPoint = pos
    }
    
    //when you lift your finger off the screen
    func touchUp(atPoint pos : CGPoint) {
        self.ship?.isThrusting = false
        self.fingerPoint = nil
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
        
        let dt : CGFloat = 0.01
        
        if(self.ship?.isThrusting)! {
            self.ship?.thrust(forTime: dt, towardPoint: self.fingerPoint!)
        }
        self.ship?.travelVerlet(forTime: dt)
        self.mars?.travelVerlet(forTime: dt)
        
        Mass.handleCollisions(width: CGFloat(self.screenWidth!), height: CGFloat(self.screenHeight!))
    }
    
}
