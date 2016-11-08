//
//  LCDUmbrellaRow.swift
//  RainCat
//
//  Created by Marc Vandehey on 11/7/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

class LCDUmbrellaRow : SKNode {
  private var umbrella1 : SKSpriteNode!
  private var umbrella2 : SKSpriteNode!
  private var umbrella3 : SKSpriteNode!
  private var umbrella4 : SKSpriteNode!
  private var umbrella5 : SKSpriteNode!
  private var umbrella6 : SKSpriteNode!

  private(set) var umbrellaLocation = 2

  func setup() {
    umbrella1 = childNode(withName: "umbrella-pos-one") as! SKSpriteNode!
    umbrella2 = childNode(withName: "umbrella-pos-two") as! SKSpriteNode!
    umbrella3 = childNode(withName: "umbrella-pos-three") as! SKSpriteNode!
    umbrella4 = childNode(withName: "umbrella-pos-four") as! SKSpriteNode!
    umbrella5 = childNode(withName: "umbrella-pos-five") as! SKSpriteNode!
    umbrella6 = childNode(withName: "umbrella-pos-six") as! SKSpriteNode!

    umbrella1.alpha = lcdOffAlpha
    umbrella2.alpha = lcdOffAlpha
    umbrella4.alpha = lcdOffAlpha
    umbrella5.alpha = lcdOffAlpha
    umbrella6.alpha = lcdOffAlpha
  }

  func moveLeft() {
    if umbrellaLocation > 0 {
      umbrellaLocation -= 1
    }

    updateLeds()
  }

  func moveRight() {
    if umbrellaLocation < 5 {
      umbrellaLocation += 1
    }

    updateLeds()
  }

  func updateLeds() {
    umbrella1.alpha = umbrellaLocation == 0 ? lcdOnAlpha : lcdOffAlpha
    umbrella2.alpha = umbrellaLocation == 1 ? lcdOnAlpha : lcdOffAlpha
    umbrella3.alpha = umbrellaLocation == 2 ? lcdOnAlpha : lcdOffAlpha
    umbrella4.alpha = umbrellaLocation == 3 ? lcdOnAlpha : lcdOffAlpha
    umbrella5.alpha = umbrellaLocation == 4 ? lcdOnAlpha : lcdOffAlpha
    umbrella6.alpha = umbrellaLocation == 5 ? lcdOnAlpha : lcdOffAlpha
  }
}
