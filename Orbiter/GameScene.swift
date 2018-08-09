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
    private var earth : Mass?
    private var moon : Mass?
    private var slingShot : SlingShot?
    
    private var screenWidth : CGFloat?
    private var screenHeight : CGFloat?
    private var fingerPoint : CGPoint?
    private var previousTime : TimeInterval?
    
    override func didMove(to view: SKView) {
        //initialize instance variables when the controller switches to this view
        self.screenWidth = view.frame.width
        self.screenHeight = view.frame.height
        print(self.screenWidth as Any, self.screenHeight as Any)
        
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
        self.moon?.velocity.dx = ((G) * (self.earth?.mass)! / (self.moon?.position.y)!).squareRoot()
        self.moon?.velocity.dy = 0
        self.addChild(self.moon!)
        
        //INITALIZE SHIP
        self.ship = Ship(imageName: "spaceship.png", id: 0)
        self.ship?.position.x = 0
        self.ship?.position.y = 175
        self.ship?.mass = 0.0000000001
        self.ship?.velocity.dx = -((G) * (self.earth?.mass)! / (self.ship?.position.y)!).squareRoot()
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
        self.fingerPoint = nil
        print("STARTING APP")
    }
    
    //when you place your finger on the screen
    func touchDown(atPoint pos : CGPoint) {
        
//        self.ship?.isThrusting = true
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
        
        //travelVerlet(forTime: dt)
        
        if(self.ship?.isThrusting)! {
            self.ship?.thrust(forTime: dt, towardPoint: self.fingerPoint!)
        }
        
        self.ship?.travelVerlet(forTime: dt)
        self.earth?.travelVerlet(forTime: dt)
        self.moon?.travelVerlet(forTime: dt)
        
        Mass.handleCollisions(width: CGFloat(self.screenWidth!), height: CGFloat(self.screenHeight!))
        
        //        for mass in (self.earth?.masses)! {
        //            mass.travelVerlet(forTime: dt)
        //        }
        
        self.previousTime = currentTime
    }
    
    //returns theta between 0 and 2pi for any vector
    public static func getThetaForVector(vector: CGVector) -> CGFloat {
        
        var vx = vector.dx
        var vy = vector.dy
        
        let zero = CGFloat(0)
        var theta = CGFloat(0)
        
        //        if(self.slingShot?.isSlinging)! {
        //            vx = (self.slingShot?.vector.dx)!
        //            vy = (self.slingShot?.vector.dy)!
        //        }
        
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
