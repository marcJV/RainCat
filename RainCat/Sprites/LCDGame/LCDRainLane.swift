//
//  LCDRainLane.swift
//  RainCat
//
//  Created by Marc Vandehey on 11/1/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

class LCDRainLane : SKNode, Resetable, LCDUpdateable, LCDSetupable {
  private var raindropNodeOne   : SKSpriteNode!
  private var raindropNodeTwo   : SKSpriteNode!
  private var raindropNodeThree : SKSpriteNode!
  private var raindropNodeFour  : SKSpriteNode!
  private var raindropNodeFive  : SKSpriteNode!
  private var raindropNodeSix   : SKSpriteNode!
  private var raindropNodeSeven : SKSpriteNode!
  private var raindropNodeEight : SKSpriteNode!
  private var raindropNodeNine  : SKSpriteNode!
  private var raindropNodeTen   : SKSpriteNode!

  private(set) var needsRaindrop = false
  private var shouldUpdate = true

  func setup() {
    raindropNodeOne = childNode(withName: "rain-pos-one") as! SKSpriteNode!
    raindropNodeTwo = childNode(withName: "rain-pos-two") as! SKSpriteNode!
    raindropNodeThree = childNode(withName: "rain-pos-three") as! SKSpriteNode!
    raindropNodeFour = childNode(withName: "rain-pos-four") as! SKSpriteNode!
    raindropNodeFive = childNode(withName: "rain-pos-five") as! SKSpriteNode!
    raindropNodeSix = childNode(withName: "rain-pos-six") as! SKSpriteNode!
    raindropNodeSeven = childNode(withName: "rain-pos-seven") as! SKSpriteNode!
    raindropNodeEight = childNode(withName: "rain-pos-eight") as! SKSpriteNode!
    raindropNodeNine = childNode(withName: "rain-pos-nine") as! SKSpriteNode!
    raindropNodeTen = childNode(withName: "rain-pos-ten") as! SKSpriteNode!

    raindropNodeOne.alpha = lcdOffAlpha
    raindropNodeTwo.alpha = lcdOffAlpha
    raindropNodeThree.alpha = lcdOffAlpha
    raindropNodeFour.alpha = lcdOffAlpha
    raindropNodeFive.alpha = lcdOffAlpha
    raindropNodeSix.alpha = lcdOffAlpha
    raindropNodeSeven.alpha = lcdOffAlpha
    raindropNodeEight.alpha = lcdOffAlpha
    raindropNodeNine.alpha = lcdOffAlpha
    raindropNodeTen.alpha = lcdOffAlpha
  }

  func resetPressed() {
    shouldUpdate = false

    raindropNodeTen.removeAllActions()

    for child in children {
      if let resetable = child as? SKSpriteNode {
        resetable.alpha = lcdOnAlpha
      }
    }
  }

  func resetReleased() {
    needsRaindrop = false

    for child in children {
      if let resetable = child as? SKSpriteNode {
        resetable.alpha = lcdOffAlpha
      }
    }

    shouldUpdate = true
  }

  //Move the raindrop down one raindrop level
  func update() {
    if(shouldUpdate) {
      raindropNodeTen.alpha = raindropNodeNine.alpha
      raindropNodeNine.alpha = raindropNodeEight.alpha
      raindropNodeEight.alpha = raindropNodeSeven.alpha
      raindropNodeSeven.alpha = raindropNodeSix.alpha
      raindropNodeSix.alpha = raindropNodeFive.alpha
      raindropNodeFive.alpha = raindropNodeFour.alpha
      raindropNodeFour.alpha = raindropNodeThree.alpha
      raindropNodeThree.alpha = raindropNodeTwo.alpha
      raindropNodeTwo.alpha = raindropNodeOne.alpha
      raindropNodeOne.alpha = needsRaindrop ? lcdOnAlpha : lcdOffAlpha

      needsRaindrop = false
    }
  }

  func addRaindrop() {
    needsRaindrop = true && shouldUpdate
  }

  func checkUmbrellaHit() -> Bool {
    if(shouldUpdate) {
      let hadRaindrop = raindropNodeNine.alpha == lcdOnAlpha
      raindropNodeNine.alpha = lcdOffAlpha

      //TODO play sound?

      return hadRaindrop
    }

    return false
  }

  func blinkRaindrop() {
    raindropNodeTen.run(SKAction.repeatForever(SKAction.sequence([SKAction.fadeAlpha(to: lcdOffAlpha, duration: 0.0),
                                                                  SKAction.wait(forDuration: 0.25),
                                                                  SKAction.fadeAlpha(to: lcdOnAlpha, duration: 0.0),
                                                                  SKAction.wait(forDuration: 0.25)])))
  }

  func hasCatLevel() -> Bool {
    return shouldUpdate && raindropNodeTen.alpha == lcdOnAlpha
  }
}
