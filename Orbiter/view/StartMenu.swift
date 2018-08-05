//
//  StartMenu.swift
//  Orbiter
//
//  Created by Alex Sieber on 8/5/18.
//  Copyright © 2018 Alex Sieber. All rights reserved.
//

import GameplayKit
import SpriteKit

class StartMenu: SKScene {
    
    private var levelOneButton : SKSpriteNode?
    private var levelTwoButton : SKSpriteNode?
    private var levelThreeButton : SKSpriteNode?
    private var fingerPoint : CGPoint?
    private var screenWidth : CGFloat?
    private var screenHeight : CGFloat?
    private var viewController : GameViewController?
    
    override func didMove(to view: SKView) {
        //initialize size variables
        self.screenWidth = view.frame.width
        self.screenHeight = view.frame.height
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.viewController = appDelegate.window?.rootViewController as! GameViewController?
        
        //make sure the child actually is of the Mass class
        if let levelOneButtonNode : SKSpriteNode = self.childNode(withName: "levelOneButtonNode") as? SKSpriteNode {
            //make the declared variable equal to earthNode
            self.levelOneButton = levelOneButtonNode
        }
        //make sure the child actually is of the Mass class
        if let levelTwoButtonNode : SKSpriteNode = self.childNode(withName: "levelTwoButtonNode") as? SKSpriteNode {
            //make the declared variable equal to earthNode
            self.levelTwoButton = levelTwoButtonNode
        }
        //make sure the child actually is of the Mass class
        if let levelThreeButtonNode : SKSpriteNode = self.childNode(withName: "levelThreeButtonNode") as? SKSpriteNode {
            //make the declared variable equal to earthNode
            self.levelThreeButton = levelThreeButtonNode
        }
        
        print("STARTING APP")
    }
    
    //when you place your finger on the screen
    func touchDown(atPoint pos : CGPoint) {
        self.fingerPoint = pos
    }
    
    //when you drag your finger on the screen
    func touchMoved(toPoint pos : CGPoint) {
        self.fingerPoint = pos
    }
    
    //when you lift your finger off the screen
    func touchUp(atPoint pos : CGPoint) {
        
        if(self.levelOneButton?.frame.contains(pos))! {
            
            print("LEVEL 1")
            
            if let view = self.viewController?.view as! SKView? {
                // Load the SKScene from 'GameScene.sks'
                if let scene = SKScene(fileNamed: "LevelOne") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    // Present the scene
                    view.presentScene(scene)
                }
                view.ignoresSiblingOrder = true
                view.showsFPS = true
                view.showsNodeCount = true
            }
            
        }
        if(self.levelTwoButton?.frame.contains(pos))! {
            
            print("LEVEL 2")
            
            if let view = self.viewController?.view as! SKView? {
                // Load the SKScene from 'GameScene.sks'
                if let scene = SKScene(fileNamed: "LevelTwo") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    // Present the scene
                    view.presentScene(scene)
                }
                view.ignoresSiblingOrder = true
                view.showsFPS = true
                view.showsNodeCount = true
            }
        }
        if(self.levelThreeButton?.frame.contains(pos))! {
            
            print("LEVEL 3")
            
            if let view = self.viewController?.view as! SKView? {
                // Load the SKScene from 'GameScene.sks'
                if let scene = SKScene(fileNamed: "LevelThree") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    // Present the scene
                    view.presentScene(scene)
                }
                view.ignoresSiblingOrder = true
                view.showsFPS = true
                view.showsNodeCount = true
            }
        }
        
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
        
        
    }
}
