//
//  LCDHudNode.swift
//  RainCat
//
//  Created by Marc Vandehey on 11/1/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

class LCDHudNode : SKNode {
  var lifeHudNode : LCDHudLives!

  func setup() {
    lifeHudNode = childNode(withName: "display-lives") as! LCDHudLives!
    lifeHudNode.setup()

    //Setup time and score
  }

  func addScore() {

  }

  func resetScore() {

  }

  func update() {
    //Use this to update time
  }
}
