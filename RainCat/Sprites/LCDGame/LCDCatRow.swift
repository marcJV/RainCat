//
//  LCDCatRow.swift
//  RainCat
//
//  Created by Marc Vandehey on 11/7/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

class LCDCatRow : SKNode {
  var catPosition1 : SKSpriteNode!
  var catPosition2 : SKSpriteNode!
  var catPosition3 : SKSpriteNode!
  var catPosition4 : SKSpriteNode!
  var catPosition5 : SKSpriteNode!
  var catPosition6 : SKSpriteNode!

  func setup() {
    catPosition1 = childNode(withName: "cat-pos-one") as! SKSpriteNode!
    catPosition2 = childNode(withName: "cat-pos-two") as! SKSpriteNode!
    catPosition3 = childNode(withName: "cat-pos-three") as! SKSpriteNode!
    catPosition4 = childNode(withName: "cat-pos-four") as! SKSpriteNode!
    catPosition5 = childNode(withName: "cat-pos-five") as! SKSpriteNode!
    catPosition6 = childNode(withName: "cat-pos-six") as! SKSpriteNode!

    catPosition1.alpha = lcdOffAlpha
    catPosition2.alpha = lcdOffAlpha
    catPosition3.alpha = lcdOffAlpha
    catPosition4.alpha = lcdOffAlpha
    catPosition5.alpha = lcdOffAlpha
    catPosition6.alpha = lcdOffAlpha
  }
}
