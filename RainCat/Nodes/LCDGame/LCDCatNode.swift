//
//  LCDCatNode.swift
//  RainCat
//
//  Created by Marc Vandehey on 3/29/17.
//  Copyright © 2017 Thirteen23. All rights reserved.
//

import SpriteKit

class LCDCatNode : SKNode, Resetable, LCDSetupable {
  private var catLeft : SKSpriteNode!
  private var catRight : SKSpriteNode!
  private var backgroundSprite : SKSpriteNode!

  func setup() {
    backgroundSprite = childNode(withName: "cat-background") as! SKSpriteNode!
    catLeft = childNode(withName: "cat-left") as! SKSpriteNode!
    catRight = childNode(withName: "cat-right") as! SKSpriteNode!

    reset()
  }

  func resetPressed() {
    catLeft.alpha = 0
    catRight.alpha = 0

    backgroundSprite.alpha = lcdOnAlpha
  }

  func resetReleased() {
    reset()
  }

  private func reset() {
    backgroundSprite.alpha = lcdOffAlpha
    catLeft.alpha = 0
    catRight.alpha = 0

    catLeft.removeAllActions()
    catRight.removeAllActions()
  }

  func update(hasCat : Bool, facingLeft : Bool) {
    if hasCat {
      catLeft.alpha = facingLeft ? lcdOnAlpha : 0
      catRight.alpha = !facingLeft ? lcdOnAlpha : 0
    } else {
      catLeft.alpha = 0
      catRight.alpha = 0
    }
  }
}
