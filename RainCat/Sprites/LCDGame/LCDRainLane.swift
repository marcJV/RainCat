//
//  LCDRainLane.swift
//  RainCat
//
//  Created by Marc Vandehey on 11/1/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

class LCDRainLane : SKNode {
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

  //Move the raindrop down one raindrop level
  func update() {
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

  func addRaindrop() {
    needsRaindrop = true
  }

  func removeUmbrellaLevelRaindrop() {
    raindropNodeNine.alpha = lcdOffAlpha

    //TODO play sound?
  }

  func hasCatLevel() -> Bool {
    return raindropNodeTen.alpha == lcdOnAlpha
  }

  func testLights() {
   raindropNodeOne.run(SKAction.repeatForever(SKAction.sequence([
      SKAction.fadeAlpha(to: 0.05, duration: 0.25),
      SKAction.fadeAlpha(to: 1, duration: 0.25),
      SKAction.wait(forDuration: 4.5)
      ])))

    raindropNodeTwo.run(SKAction.repeatForever(SKAction.sequence([
      SKAction.wait(forDuration: 0.5),
      SKAction.fadeAlpha(to: 0.05, duration: 0.25),
      SKAction.fadeAlpha(to: 1, duration: 0.25),
      SKAction.wait(forDuration: 4)
      ])))

    raindropNodeThree.run(SKAction.repeatForever(SKAction.sequence([
      SKAction.wait(forDuration: 1),
      SKAction.fadeAlpha(to: 0.05, duration: 0.25),
      SKAction.fadeAlpha(to: 1, duration: 0.25),
      SKAction.wait(forDuration: 3.5)
      ])))

    raindropNodeFour.run(SKAction.repeatForever(SKAction.sequence([
      SKAction.wait(forDuration: 1.5),
      SKAction.fadeAlpha(to: 0.05, duration: 0.25),
      SKAction.fadeAlpha(to: 1, duration: 0.25),
      SKAction.wait(forDuration: 3)
      ])))

    raindropNodeFive.run(SKAction.repeatForever(SKAction.sequence([
      SKAction.wait(forDuration: 2.0),
      SKAction.fadeAlpha(to: 0.05, duration: 0.25),
      SKAction.fadeAlpha(to: 1, duration: 0.25),
      SKAction.wait(forDuration: 2.5)
      ])))

    raindropNodeSix.run(SKAction.repeatForever(SKAction.sequence([
      SKAction.wait(forDuration: 2.5),
      SKAction.fadeAlpha(to: 0.05, duration: 0.25),
      SKAction.fadeAlpha(to: 1, duration: 0.25),
      SKAction.wait(forDuration: 2.0)
      ])))

    raindropNodeSeven.run(SKAction.repeatForever(SKAction.sequence([
      SKAction.wait(forDuration: 3.0),
      SKAction.fadeAlpha(to: 0.05, duration: 0.25),
      SKAction.fadeAlpha(to: 1, duration: 0.25),
      SKAction.wait(forDuration: 1.5)
      ])))

    raindropNodeEight.run(SKAction.repeatForever(SKAction.sequence([
      SKAction.wait(forDuration: 3.5),
      SKAction.fadeAlpha(to: 0.05, duration: 0.25),
      SKAction.fadeAlpha(to: 1, duration: 0.25),
      SKAction.wait(forDuration: 1.0)
      ])))

    raindropNodeNine.run(SKAction.repeatForever(SKAction.sequence([
      SKAction.wait(forDuration: 4.0),
      SKAction.fadeAlpha(to: 0.05, duration: 0.25),
      SKAction.fadeAlpha(to: 1, duration: 0.25),
      SKAction.wait(forDuration: 0.5)
      ])))

    raindropNodeTen.run(SKAction.repeatForever(SKAction.sequence([
      SKAction.wait(forDuration: 4.5),
      SKAction.fadeAlpha(to: 0.05, duration: 0.25),
      SKAction.fadeAlpha(to: 1, duration: 0.25)
      ])))
  }
}
