//
//  PingPongHud.swift
//  RainCat
//
//  Created by Marc Vandehey on 9/19/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

public class PingPongHud : SKNode {
  private var playerOneScoreNode = SKLabelNode(fontNamed: BASE_FONT_NAME)
  private var playerTwoScoreNode = SKLabelNode(fontNamed: BASE_FONT_NAME)
  private var messageNode = ShadowLabelNode(fontNamed: BASE_FONT_NAME)

  private(set) var quitButtonPressed = false

  private var quitButton : SKSpriteNode!
  private let quitButtonTexture = SKTexture(imageNamed: "quit_button")
  private let quitButtonPressedTexture = SKTexture(imageNamed: "quit_button_pressed")

  var quitButtonAction : (() -> ())?

  private var rematchButton : SKSpriteNode!
  private let rematchTexture = SKTexture(imageNamed: "rematch_button")
  private let rematchPressedTexture = SKTexture(imageNamed: "rematch_button_pressed")

  private var showingRematchButton = false
  private var rematchButtonPressed = false

  var rematchButtonAction : (() ->())?

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

    quitButton = SKSpriteNode(texture: quitButtonTexture)
    let margin : CGFloat = 15
    quitButton.position = CGPoint(x: size.width / 2, y: quitButton.size.height / 2 + margin)
    quitButton.zPosition = 1000

    addChild(quitButton)

    messageNode.alpha = 0
    messageNode.fontSize = 65
    messageNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
    messageNode.zPosition = 1000
    addChild(messageNode)

    rematchButton = SKSpriteNode(texture: rematchTexture)
    rematchButton.alpha = 0
    rematchButton.position = CGPoint(x: size.width / 2,
                                     y: quitButton.position.y + (quitButton.size.height / 2) + (rematchButton.size.height / 2) + margin * 2)
    rematchButton.zPosition = 1000
    addChild(rematchButton)
  }

  public func incrementPlayerOne() {
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

  public func touchBeganAtPoint(point: CGPoint) {
    let quitContainsPoint = quitButton.contains(point)

    if quitButtonPressed && !quitContainsPoint {
      //Cancel the last click
      quitButtonPressed = false
      quitButton.texture = quitButtonTexture
    } else if quitContainsPoint {
      quitButton.texture = quitButtonPressedTexture
      quitButtonPressed = true
    }

    let rematchContainsPoint = rematchButton.contains(point)
    if showingRematchButton && rematchButtonPressed && !rematchContainsPoint {
      rematchButtonPressed = false
      rematchButton.texture = rematchTexture
    } else if rematchContainsPoint {
      rematchButtonPressed = true
      rematchButton.texture = rematchPressedTexture
    }
  }

  public func touchMovedToPoint(point: CGPoint) {
    if quitButtonPressed {
      if quitButton.contains(point) {
        quitButton.texture = quitButtonPressedTexture
      } else {
        quitButton.texture = quitButtonTexture
      }
    } else if rematchButtonPressed {
      if rematchButton.contains(point) {
        rematchButton.texture = rematchPressedTexture
      } else {
        rematchButton.texture = rematchTexture
      }
    }
  }

  public func touchEndedAtPoint(point: CGPoint) {
    if quitButtonPressed && quitButton.contains(point) && quitButtonAction != nil {
      quitButtonAction!()
    } else if showingRematchButton && rematchButtonPressed && rematchButton.contains(point) && rematchButtonAction != nil {
      rematchButtonAction!()
    }

    rematchButtonPressed = false
    quitButtonPressed = false

    quitButton.texture = quitButtonTexture
    rematchButton.texture = rematchTexture
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
