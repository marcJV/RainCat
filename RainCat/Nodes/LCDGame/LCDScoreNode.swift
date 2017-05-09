//
//  LCDScoreNode.swift
//  RainCat
//
//  Created by Marc Vandehey on 3/29/17.
//  Copyright © 2017 Thirteen23. All rights reserved.
//

import SpriteKit

class LCDScoreNode : SKSpriteNode, Resetable, LCDSetupable {
  private var hundredsSpot : LCDNumberNode!
  private var tensSpot : LCDNumberNode!
  private var onesSpot : LCDNumberNode!

  private(set) var score = 0

  func setup() {
    hundredsSpot = childNode(withName: "score-hundreds") as! LCDNumberNode!
    tensSpot = childNode(withName: "score-tens") as! LCDNumberNode!
    onesSpot = childNode(withName: "score-ones") as! LCDNumberNode!

    for child in children {
      if let setupable = child as? LCDSetupable {
        setupable.setup()
      }
    }

    reset()
  }

  public func incrementScore() {
    score += 1

    updateDisplay(score: score)
  }

  public func resetPressed() {
    updateDisplay(score: 888)
  }

  public func resetReleased() {
    reset()
  }

  private func reset() {
    score = 0

    updateDisplay(score: 0)
  }

  func updateDisplay(score : Int) {
    var tempScore = score

    let ones = tempScore % 10
    tempScore -= ones

    let tens = tempScore % 100
    tempScore -= tens

    hundredsSpot.updateDisplay(number: (tempScore % 1000) / 100)
    tensSpot.updateDisplay(number: tens / 10)
    onesSpot.updateDisplay(number: ones)
  }
}
