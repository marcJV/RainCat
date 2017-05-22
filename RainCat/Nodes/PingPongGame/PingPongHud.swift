//
//  PingPongHud.swift
//  RainCat
//
//  Created by Marc Vandehey on 9/19/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

public class PingPongHud : SKNode {
  weak var pingPongNavigation : PingPongNavigation?

  private var playerOneScoreNode = SKLabelNode(fontNamed: BASE_FONT_NAME)
  private var playerTwoScoreNode = SKLabelNode(fontNamed: BASE_FONT_NAME)
  private var messageNode = ShadowLabelNode(fontNamed: BASE_FONT_NAME)

  private var quitButton : TwoPaneButton!
  private var rematchButton : TwoPaneButton!
  private var quitZeroPosition : CGFloat = 0
  private var quitHidePosition : CGFloat = 0

  private var showingRematchButton = false

  private var showingQuit = true

  private(set) var playerOneScore = 0
  private(set) var playerTwoScore = 0

  private let highScoreColor = SKColor(red:1.00, green:1.00, blue:0.69, alpha:1.0)

  public func setup(size: CGSize) {
    addChild(playerOneScoreNode)
    addChild(playerTwoScoreNode)

    playerOneScoreNode.horizontalAlignmentMode = .center
    playerTwoScoreNode.horizontalAlignmentMode = .center

    playerOneScoreNode.fontSize = 50
    playerTwoScoreNode.fontSize = 50

    playerOneScoreNode.zPosition = 1000
    playerTwoScoreNode.zPosition = 1000

    playerOneScoreNode.position = CGPoint(x: size.width / 2 - 90, y: size.height * 0.9)
    playerTwoScoreNode.position = CGPoint(x: size.width / 2 + 90, y: size.height * 0.9)

    playerOneScoreNode.text = "\(playerOneScore)"
    playerTwoScoreNode.text = "\(playerTwoScore)"

    quitButton = TwoPaneButton(text: "Quit", textSize: 20, size: CGSize(width: 95, height: 45))
    quitButton.elevation = 5

    let margin : CGFloat = 15
    quitZeroPosition = quitButton.size.height + margin
    quitHidePosition = -20
    quitButton.position = CGPoint(x: size.width / 2 - quitButton.size.width / 2, y: quitZeroPosition)
    quitButton.addTarget(self, selector: #selector(quitSelected), forControlEvents: .TouchUpInside)
    quitButton.zPosition = 1000

    addChild(quitButton)

    messageNode.alpha = 0
    messageNode.fontSize = 65
    messageNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
    messageNode.zPosition = 1000
    addChild(messageNode)

    rematchButton = TwoPaneButton(text: "Rematch?", textSize: 40, size: CGSize(width: 300, height: 70))
    rematchButton.alpha = 0
    rematchButton.addTarget(self, selector: #selector(rematchSelected), forControlEvents: .TouchUpInside)
    rematchButton.position = CGPoint(x: size.width / 2 - rematchButton.size.width / 2,
                                     y: messageNode.position.y - rematchButton.size.height / 2 - margin * 2)
    rematchButton.zPosition = 1000
    addChild(rematchButton)
  }

  public func incrementPlayerOne() {
    showQuitButton()
    
    playerOneScore += 1

    playerOneScoreNode.text = "\(playerOneScore)"

    if playerOneScore > playerTwoScore {
      playerOneScoreNode.run(ColorAction().colorTransitionAction(fromColor: playerOneScoreNode.fontColor!, toColor: highScoreColor, duration: colorChangeDuration))
      playerOneScoreNode.run(SKAction.scale(to: 1.5, duration: 0.25))
    } else if playerTwoScore <= playerOneScore {
      playerTwoScoreNode.run(ColorAction().colorTransitionAction(fromColor: playerTwoScoreNode.fontColor!, toColor: SKColor.white, duration: colorChangeDuration))
      playerTwoScoreNode.run(SKAction.scale(to: 1.0, duration: 0.25))
    }
  }

  public func incrementPlayerTwo() {
    showQuitButton()

    playerTwoScore += 1

    playerTwoScoreNode.text = "\(playerTwoScore)"

    if playerTwoScore > playerOneScore {
      playerTwoScoreNode.run(ColorAction().colorTransitionAction(fromColor: playerTwoScoreNode.fontColor!, toColor: highScoreColor, duration: colorChangeDuration))
      playerTwoScoreNode.run(SKAction.scale(to: 1.5, duration: 0.25))
    } else if playerOneScore <= playerTwoScore {
      playerOneScoreNode.run(ColorAction().colorTransitionAction(fromColor: playerOneScoreNode.fontColor!, toColor: SKColor.white, duration: colorChangeDuration))
      playerOneScoreNode.run(SKAction.scale(to: 1.0, duration: 0.25))
    }
  }

  func quitSelected() {
    if let nav = pingPongNavigation {
      nav.quitPressed()
    }
  }

  func rematchSelected() {
    if let nav = pingPongNavigation {
      nav.restartPressed()
    }
  }

  func showQuitButton() {
    if !showingQuit {
      quitButton.moveTo(y: quitZeroPosition)
    }

    showingQuit = true
  }

  func hideQuitButton() {
    if showingQuit {
      quitButton.moveTo(y: quitHidePosition)
    }

    showingQuit = false
  }

  func showMessage(message : String) {
    showMessageIndefinitely(message: message)

    messageNode.run(SKAction.fadeOut(withDuration: 2))
  }

  func showMessageIndefinitely(message : String) {
    messageNode.text = message

    messageNode.alpha = 1
  }

  func hideMessage() {
    messageNode.run(SKAction.fadeOut(withDuration: 0.25))
  }

  func showRematchButton() {
    showingRematchButton = true

    rematchButton.alpha = 1
  }

  func hideRematchButton() {
    showingRematchButton = false

    rematchButton.alpha = 0
  }

  func resetScore() {
    playerOneScore = 0
    playerTwoScore = 0

    playerOneScoreNode.text = "\(playerOneScore)"
    playerTwoScoreNode.text = "\(playerTwoScore)"

    playerOneScoreNode.run(ColorAction().colorTransitionAction(fromColor: playerOneScoreNode.fontColor!, toColor: SKColor.white, duration: colorChangeDuration))
    playerOneScoreNode.run(SKAction.scale(to: 1.0, duration: 0.25))

    playerTwoScoreNode.run(ColorAction().colorTransitionAction(fromColor: playerTwoScoreNode.fontColor!, toColor: SKColor.white, duration: colorChangeDuration))
    playerTwoScoreNode.run(SKAction.scale(to: 1.0, duration: 0.25))
  }
}
