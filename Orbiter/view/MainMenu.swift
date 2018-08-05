//
//  MainMenu.swift
//  Orbiter
//
//  Created by Alex Sieber on 8/5/18.
//  Copyright © 2018 Alex Sieber. All rights reserved.
//

import Foundation
import UIKit

class MainMenu: UIView {
    
    @IBOutlet weak var levelOneButton: UIButton!
    @IBOutlet weak var levelTwoButton: UIButton!
    @IBOutlet weak var levelThreeButton: UIButton!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func onLevelOneButtonPress(_ sender: Any) {
        print("LEVEL 1")
    }
    
    @IBAction func onLevelTwoButtonPress(_ sender: Any) {
        print("LEVEL 2")
    }
    
    @IBAction func onLevelThreeButtonPress(_ sender: Any) {
        print("LEVEL 3")
    }
    
}


