//
//  HudNode.swift
//  RainCat
//
//  Created by Marc Vandehey on 9/2/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

class HudNode : SKNode, Palettable {
  weak var quitNavigation : QuitNavigation?
  private let scoreNode = SKLabelNode(fontNamed: BASE_FONT_NAME)
  private let highRoundScoreNode = SKLabelNode(fontNamed: BASE_FONT_NAME)
  private(set) var score : Int = 0
  private var highScore : Int = 0

  private var highRoundScore : Int = 0

  private var showingHighScore = false

  private var quitButton : TwoPaneButton!

  private var highScoreColor = SKColor.white

  //Setup hud here
  public func setup(size: CGSize, palette : ColorPalette, highScore: Int) {
    self.highScore = highScore

    scoreNode.text = "\(score)"
    scoreNode.fontSize = 70
    scoreNode.position = CGPoint(x: size.width / 2, y: size.height - 100)
    scoreNode.zPosition = 1

    addChild(scoreNode)

    highRoundScoreNode.text = "\(highRoundScore)"
    highRoundScoreNode.fontSize = 50
    highRoundScoreNode.position = CGPoint(x: 40, y: size.height - 60)
    highRoundScoreNode.horizontalAlignmentMode = .left

    addChild(highRoundScoreNode)

    quitButton = TwoPaneButton(color: UIColor.clear, size: CGSize(width: 80, height: 35))
    quitButton.setup(text: "Quit", fontSize: 20)
    quitButton.elevation = 5
    quitButton.position = CGPoint(x: size.width - quitButton.size.width - 25, y: size.height - quitButton.size.height - 5)
    quitButton.zPosition = 1000
    quitButton.addTarget(self, selector: #selector(quit), forControlEvents: .TouchUpInside)

    highScoreColor = palette.groundColor

    addChild(quitButton)
  }

  public func quit() {
    if let quit = quitNavigation {
      quit.quitPressed()
    }
  }

  public func addPoint() {
    score += 1

    updateScoreboard()

    if score > highScore {
      highScore = score

      if !showingHighScore {
        showingHighScore = true

        scoreNode.run(SKAction.scale(to: 1.5, duration: 0.25))
        scoreNode.run(ColorAction().colorTransitionAction(fromColor: SKColor.white, toColor: highScoreColor, duration: colorChangeDuration))

        highRoundScoreNode.run(ColorAction().colorTransitionAction(fromColor: SKColor.white, toColor: highScoreColor, duration: colorChangeDuration))
      }
    }

    if score > highRoundScore {
      highRoundScore = score

      highRoundScoreNode.text = "\(highRoundScore)"
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

  public func updatePalette(palette: ColorPalette) {
    highScoreColor = palette.groundColor

    if showingHighScore {
      scoreNode.run(ColorAction().colorTransitionAction(fromColor: scoreNode.fontColor!, toColor: palette.groundColor, duration: colorChangeDuration))
    }
  }
}
