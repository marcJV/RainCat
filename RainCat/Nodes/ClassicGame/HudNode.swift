//
//  HudNode.swift
//  RainCat
//
//  Created by Marc Vandehey on 9/2/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

class HudNode : SKNode, Palettable {
  private let scoreNode = SKLabelNode(fontNamed: BASE_FONT_NAME)
  private(set) var score : Int = 0
  private var highScore : Int = 0
  private var showingHighScore = false

  private(set) var quitButtonPressed = false

  private var quitButton : TwoPaneButton!

  private var highScoreColor = SKColor.white

  var quitButtonAction : (() -> ())?

  //Setup hud here
  public func setup(size: CGSize, palette : ColorPalette) {
    let defaults = UserDefaults.standard

    highScore = defaults.integer(forKey: ScoreKey)

    scoreNode.text = "\(score)"
    scoreNode.fontSize = 70
    scoreNode.position = CGPoint(x: size.width / 2, y: size.height - 100)
    scoreNode.zPosition = 1

    addChild(scoreNode)

    quitButton = TwoPaneButton(color: UIColor.clear, size: CGSize(width: 80, height: 35))
    quitButton.setup(text: "Quit", fontSize: 20)
    quitButton.elevation = 5
    quitButton.position = CGPoint(x: size.width - quitButton.size.width - 25, y: size.height - quitButton.size.height - 5)
    quitButton.zPosition = 1000
    quitButton.addTarget(self, selector: #selector(quit(_:)), forControlEvents: .TouchUpInside)

    highScoreColor = palette.groundColor

    addChild(quitButton)
  }

  public func quit(_ sender:AnyObject) {
    quitButtonAction!()
  }

  public func addPoint() {
    score += 1

    updateScoreboard()

    if score > highScore {
      highScore = score

      let defaults = UserDefaults.standard
      defaults.set(score, forKey: ScoreKey)
      defaults.synchronize()

      if !showingHighScore {
        showingHighScore = true

        scoreNode.run(SKAction.scale(to: 1.5, duration: 0.25))
        scoreNode.run(ColorAction().colorTransitionAction(fromColor: SKColor.white, toColor: highScoreColor, duration: colorChangeDuration))

      }
    }
  }

  public func resetPoints() {
    score = 0

    updateScoreboard()

    if showingHighScore {
      showingHighScore = false

      scoreNode.run(SKAction.scale(to: 1.0, duration: 0.25))
      scoreNode.run(ColorAction().colorTransitionAction(fromColor: scoreNode.fontColor!, toColor: SKColor.white, duration: colorChangeDuration))
    }
  }

  private func updateScoreboard() {
    scoreNode.text = "\(score)"
  }

  func touchBeganAtPoint(point: CGPoint) {
    let containsPoint = quitButton.contains(point)

    if quitButtonPressed && !containsPoint {
      //Cancel the last click
      quitButtonPressed = false
//      quitButton.setUntouched()
    } else if containsPoint {
//      quitButton.setTouched()
      quitButtonPressed = true
    }
  }

  func touchMovedToPoint(point: CGPoint) {
    if quitButtonPressed {
      if quitButton.contains(point) {
//        quitButton.setUntouched()
      } else {
//        quitButton.setTouched()
      }
    }
  }

  func touchEndedAtPoint(point: CGPoint) {
    if quitButton.contains(point) && quitButtonAction != nil {
      quitButtonAction!()
    }

//    quitButton.setUntouched()
  }

  public func updatePalette(palette: ColorPalette) {
    highScoreColor = palette.groundColor

    if showingHighScore {
      scoreNode.run(ColorAction().colorTransitionAction(fromColor: scoreNode.fontColor!, toColor: palette.groundColor, duration: colorChangeDuration))
    }
  }
}
