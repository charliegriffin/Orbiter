//
//  ViewController.swift
//  Orbiter
//
//  Created by Charles Griffin on 7/1/18.
//  Copyright © 2018 Charles Griffin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var position : Double = 0
    var velocity : Double = 1
    var mass : Double = 1
    var timeStep : Double = 0.025
    var actingMass : Double = 10000
    var actingPosition : Double = -1
    var G : Double = 6.674 * pow(10,-11)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print("started")
        print("initial values")
        print("position \(position)")
        print("velocity \(velocity)")
        for _ in 1...100 {
            findNextPosition()
            print("position \(position)")
            print("velocity \(velocity)")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func findNextPosition() {
        // Euler algorithm
        // TODO: Connect with the particle object
        // TODO: Improve to Leapfrog integration
        position = position + velocity*timeStep
        velocity = velocity + calculateGravitationalAcceleration()*timeStep
    }
    
    func calculateGravitationalAcceleration() -> Double {
        // assuming force on one object from another
        // F = Gm1m2/r^2
        let direction : Double = (actingPosition - position) < 0 ? -1 : 1
        return direction * G * actingMass / pow((actingPosition - position),2)
        
    }
    
    

}

