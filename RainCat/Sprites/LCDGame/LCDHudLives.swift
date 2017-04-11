//
//  File.swift
//  RainCat
//
//  Created by Marc Vandehey on 11/1/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

class LCDHudLives : SKNode, Resetable, LCDSetupable {
  private var lifeOne   : SKSpriteNode!
  private var lifeTwo   : SKSpriteNode!
  private var lifeThree : SKSpriteNode!

  private let maxLives = 3
  private var lives = 3

  func setup() {
    lifeOne = childNode(withName: "cat-life-one") as! SKSpriteNode!
    lifeTwo = childNode(withName: "cat-life-two") as! SKSpriteNode!
    lifeThree = childNode(withName: "cat-life-three") as! SKSpriteNode!

    updateDisplay(lives: lives)
  }

  public func decrementLives() {
    lives -= 1

    updateDisplay(lives: lives)
  }

  public func hasLivesRemaining() -> Bool {
    return lives > 0
  }

  public func resetPressed() {
    updateDisplay(lives: maxLives)
  }

  public func resetReleased() {
    lives = maxLives

    updateDisplay(lives: maxLives)
  }

  private func updateDisplay(lives : Int) {
    print("lives updating to \(lives)")

    switch lives {
    case 0:
      flutterFadeOut(node: lifeOne)
    case 1:
      lifeOne.alpha = lcdOnAlpha
      flutterFadeOut(node: lifeTwo)
    case 2:
      lifeOne.alpha = lcdOnAlpha
      lifeTwo.alpha = lcdOnAlpha
      flutterFadeOut(node: lifeThree)
    default:
      lifeOne.alpha = lcdOnAlpha
      lifeTwo.alpha = lcdOnAlpha
      lifeThree.alpha = lcdOnAlpha
    }
  }

  private func flutterFadeOut(node : SKSpriteNode) {
    node.run(SKAction.repeat(SKAction.sequence([SKAction.fadeAlpha(to: lcdOffAlpha, duration: 0.0),
                                       SKAction.wait(forDuration: 0.15),
                                       SKAction.fadeAlpha(to: lcdOnAlpha, duration: 0.0),
                                       SKAction.wait(forDuration: 0.15),
                                       SKAction.fadeAlpha(to: lcdOffAlpha, duration: 0.0)]), count: 2))
  }
}
