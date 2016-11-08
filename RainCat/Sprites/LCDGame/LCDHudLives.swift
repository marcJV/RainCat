//
//  File.swift
//  RainCat
//
//  Created by Marc Vandehey on 11/1/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

class LCDHudLives : SKNode {
  private var lifeOne   : SKSpriteNode!
  private var lifeTwo   : SKSpriteNode!
  private var lifeThree : SKSpriteNode!

  func setup() {
    lifeOne = childNode(withName: "cat-life-one") as! SKSpriteNode!
    lifeTwo = childNode(withName: "cat-life-two") as! SKSpriteNode!
    lifeThree = childNode(withName: "cat-life-three") as! SKSpriteNode!

    lifeOne.alpha = lcdOffAlpha
    lifeTwo.alpha = lcdOffAlpha
    lifeThree.alpha = lcdOffAlpha
  }
}
