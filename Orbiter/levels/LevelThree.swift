//
//  GameScene.swift
//  Orbiter
//
//  Created by Alex Sieber on 7/7/18.
//  Copyright © 2018 Alex Sieber. All rights reserved.
//

import SpriteKit
import GameplayKit

var outPath : CGMutablePath = CGMutablePath();
var inPath : CGMutablePath = CGMutablePath();

class LevelThree: SKScene {
    
    private var ship : Ship?
    private var mars : Mass?
    private var fingerPoint : CGPoint?
    private var screenWidth : CGFloat?
    private var screenHeight : CGFloat?
    
    private var slingShot : SlingShot?
    
    var hasStarted : Bool = false;
    
    
    
    
    
    
    override func didMove(to view: SKView) {
        //initialize instance variables when the controller switches to this view
        self.screenWidth = view.frame.width
        self.screenHeight = view.frame.height 
        
        //make sure the child actually is of the Ship class
        if let shipNode : Ship = self.childNode(withName: "shipNode") as? Ship {
            //make the declared variable equal to shipNode
            self.ship = shipNode
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
        
        //initalize scoring boundaries
        var boundary : [CGPoint] = []
        let innerRadius : Double = 400
        boundary.append(CGPoint(x: 0.0,y: innerRadius))
        boundary.append(CGPoint(x: innerRadius, y: 0.0))
        boundary.append(CGPoint(x: 0.0,y: -innerRadius))
        boundary.append(CGPoint(x: -innerRadius,y: 0.0))
        boundary.append(CGPoint(x: 0.0,y: innerRadius))
        
        let myLine:SKShapeNode = SKShapeNode(path:inPath)
        
        inPath.addLines(between: (boundary))
        
        myLine.path = inPath
        myLine.strokeColor = SKColor.white
        
        myLine.name = "boundaryNode"
        self.addChild(myLine)
        
        self.slingShot = SlingShot()
        
        var outBoundary : [CGPoint] = []
        let outerRadius : Double = 450
        outBoundary.append(CGPoint(x: 0.0,y: outerRadius))
        outBoundary.append(CGPoint(x: outerRadius, y: 0.0))
        outBoundary.append(CGPoint(x: 0.0,y: -outerRadius))
        outBoundary.append(CGPoint(x: -outerRadius,y: 0.0))
        outBoundary.append(CGPoint(x: 0.0,y: outerRadius))
        
        let myOutLine:SKShapeNode = SKShapeNode(path:outPath)
        
        outPath.addLines(between: (outBoundary))
        
        myOutLine.path = outPath
        myOutLine.strokeColor = SKColor.white
        
        myOutLine.name = "outBoundaryNode"
        self.addChild(myOutLine)
        
        // Scoring stuff
        let winner = SKLabelNode(fontNamed: "Chalkduster")
        winner.text = "Score: \(0.0)"
        winner.fontSize = 65
        winner.fontColor = SKColor.white
        // TODO: put label in proper spot
        winner.position = CGPoint(x: frame.midX, y: frame.midY)
        winner.name = "scoreLabel"
        
        addChild(winner)
        
        self.slingShot = SlingShot()
        
        print("STARTING APP")
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
        for child in self.children {
            if (child.name == "pathNode"){
                child.removeFromParent()
            }
        }
        
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
        self.hasStarted = true
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
        
        
        if (self.hasStarted && !((self.slingShot?.isSlinging)!)){
            self.ship?.travelVerlet(forTime: dt)
            self.mars?.travelVerlet(forTime: dt)
            
            Mass.handleCollisions(width: CGFloat(self.screenWidth!), height: CGFloat(self.screenHeight!))
        }

        
    }
    
}
