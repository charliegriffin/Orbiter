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
    
    private var ship : Ship?
    private var slingShot : SlingShot?
    //screenSize is a constant representing the size of the screen
    private var screenSize : CGFloat?
    //previousTime used for calculating change in time (dt) between each frame (usually ~1/60 seconds)
    private var previousTime : TimeInterval?
    
    override func didMove(to view: SKView) {
        //initialize instance variables when sthe controller switches to this view
        self.screenSize = (self.size.width + self.size.height) * 0.05
        self.ship = Ship(size: self.screenSize!)
        self.slingShot = SlingShot()
        self.addChild(self.ship!)
        self.previousTime = -1
        print("STARTING APP")
    }
    
    //when you place your finger on the screen
    func touchDown(atPoint pos : CGPoint) {
        
        //place the ship at the position
        self.ship?.position = pos
        self.ship?.velocity.dx = 0
        self.ship?.velocity.dy = 0
        
        //if the slingshot is still slinging when you reposition the ship, get rid of the slingshot first
        if(self.slingShot?.isSlinging)! {
            self.slingShot?.removeFromParent()
        }
        //anchor the slingshot to the point you touched
        self.slingShot = SlingShot()
        self.slingShot?.attachToInitPos(initPos: pos)
        //add the slingshot to the scene
        self.addChild(self.slingShot!)
    }
    
    //when you touch a point on the screen
    func touchMoved(toPoint pos : CGPoint) {
        //update the ship's position
        self.ship?.position = pos
        //redraw the slingshot
        self.slingShot?.stretchFromInitPosToShip(ship: self.ship!)
    }
    
    //when you lift your finger off the screen
    func touchUp(atPoint pos : CGPoint) {
        //don't sling the ship unless you drag it greater than X pixels from its initial position: TODO: PUT IN MODEL
        if(self.slingShot?.radius.isLess(than: self.screenSize! / 10))! {
            //self.slingShot?.isSlinging = false
        } else {
            self.slingShot?.isSlinging = true
        }
        //get rid of the slingshot from the scene if it isn't currently slinging
        if(!(self.slingShot?.isSlinging)!) {
            self.slingShot?.removeFromParent()
        }
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
        //use previous time for calculating change in time (dt) between each frame (usually ~1/60 seconds)
        let dt = CGFloat(currentTime - self.previousTime!)
        
        //animate the ship when it's slinging (accelerating)
        if(self.slingShot?.isSlinging)! {
            //change the ship's position & velocity accordingly
            self.slingShot?.slingShip(ship: self.ship!, forTime: dt)
            
        } else { //animate the ship when it's not slinging (constant velocity)
            
            //below varibales only used for checking whether or not the slingshot is done slinging
            let vx = self.ship?.velocity.dx
            let vy = self.ship?.velocity.dy
            let v = sqrt(vx! * vx! + vy! * vy!)
            
            //if the slingshot is done slinging and the ship is flying away
            if(!(self.slingShot?.isSlinging)! && v > 0) {
                //remove the slingshot node from the scene
                self.slingShot?.removeFromParent()
            }
            
//            //this is ideally how the planets would alter the ship's velocity (not position) accordingly
//            for(planet in planets) {
//                planet.gravitateShip(ship: self.ship!, forTime: dt)
//            }
            
            //NOTE #1: it should be the ship's responsibility to travel (change its position based on its velocity) for a given amount of time since it knows its position & velocity at any given instance (frame)
            //NOTE #2: we don't want the ship affected by gravity while we are slinging
            //NOTE #3: gravity shouldn't edit the ships position, that is the ship's job. It should only alter the velocity. That way, the ship discretely travels linearly between each frame; Gravity doesn't NEED to change the ship's position -- that's the way the code is structured at the moment
            
            
        }
        //change the ship's position accordingly based on its current velocity
        self.ship?.travel(forTime: dt)
        
        self.previousTime = currentTime
    }
}
