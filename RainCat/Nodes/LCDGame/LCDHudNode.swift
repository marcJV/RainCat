//
//  LCDHudNode.swift
//  RainCat
//
//  Created by Marc Vandehey on 11/1/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

class LCDHudNode : SKNode, Resetable, LCDSetupable {
  private var lifeHudNode : LCDHudLives!
  private var lcdTimeNode : LCDTimeNode!
  private var lcdScoreNode : LCDScoreNode!

  func setup() {
    lifeHudNode = childNode(withName: "display-lives") as! LCDHudLives!
    lcdTimeNode = childNode(withName: "display-time") as! LCDTimeNode!
    lcdScoreNode = childNode(withName: "display-score") as! LCDScoreNode!

    for child in children {
      if let setupable = child as? LCDSetupable {
        setupable.setup()
      }
    }
  }

  func catHit() {
    lifeHudNode.decrementLives()
  }

  func hasLivesRemaining() -> Bool {
    return lifeHudNode.hasLivesRemaining()
  }

  func getScore() -> Int {
    return lcdScoreNode.score
  }

  func addScore() -> Int {
    lcdScoreNode.incrementScore()

    if UserDefaultsManager.sharedInstance.lcdHighScore < lcdScoreNode.score {
      UserDefaultsManager.sharedInstance.updateLCDHighScore(highScore: lcdScoreNode.score)
    }

    return lcdScoreNode.score
  }

  func resetScore() {
    lcdScoreNode.resetPressed()
  }

  func resetPressed() {
    for child in children {
      if let resetable = child as? Resetable {
        resetable.resetPressed()
      }
    }
  }

  func resetReleased() {
    for child in children {
      if let resetable = child as? Resetable {
        resetable.resetReleased()
      }
    }
  }

  func update() {
    //Use this to update time
    lcdTimeNode.update()
  }
}
