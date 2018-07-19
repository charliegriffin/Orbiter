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
        //initialize instance variables when the controller switches to this view
        
        //INITALIZE SHIP
        self.screenSize = (self.size.width + self.size.height) * 0.05
        self.ship = Ship(size: self.screenSize!)
        self.ship?.position.x = 0
        self.ship?.position.y = 250
        self.ship?.velocity.dx = ((self.ship?.G)! * (self.ship?.actingMass)! / (self.ship?.position.y)!).squareRoot()
        // virial thm benchmark
        // produces stable orbit
        self.ship?.velocity.dy = 0
        
        self.slingShot = SlingShot()
        self.addChild(self.ship!)
        self.previousTime = -1
        
        //remove the below 4 line to remove background & improve simulator FPS
        let background = Background(frame: (self.view?.frame)!)
        for star in background.backgroundStars {
            self.addChild(star)
        }
        //remove the below 5 lines to get rid of the earth image
        let image = UIImage(named: "planet06-3.png")
        let texture = SKTexture(image: image!)
        let earth = SKSpriteNode(texture: texture)
        earth.position = CGPoint(x: 0, y: 0)
        self.addChild(earth)
        
        print("STARTING APP")
    }
    
    //when you place your finger on the screen
    func touchDown(atPoint pos : CGPoint) {
        //place the ship at the position
        self.ship?.position = pos
        self.ship?.velocity = CGVector(dx: 0, dy: 0)
        //if the slingshot is still slinging when you reposition the ship, get rid of the slingshot first
        if(self.slingShot?.isSlinging)! {
            self.slingShot?.removeFromParent()
        }
        //anchor the slingshot to the ship
        self.slingShot = SlingShot()
        self.slingShot?.attachToShip(ship: self.ship!)
        //add the slingshot to the scene
        self.addChild(self.slingShot!)
    }
    
    //when you drag your finger on the screen
    func touchMoved(toPoint pos : CGPoint) {
        //redraw the slingshot
        self.slingShot?.drawFromShipToFinalPos(finalPos: pos)
    }
    
    //when you lift your finger off the screen
    func touchUp(atPoint pos : CGPoint) {
        //sling the ship
        self.slingShot?.detachFromShip(ship: self.ship!)
        //get rid of the slingshot from the scene
        self.slingShot?.removeFromParent()
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
        if(!(self.slingShot?.isSlinging)!) {
            self.ship?.travelVerlet(forTime: dt)
        }
        self.previousTime = currentTime
    }
}
