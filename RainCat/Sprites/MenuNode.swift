//
//  MenuNode.swift
//  RainCat
//
//  Created by Marc Vandehey on 9/20/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

public class MenuNode : SKNode, Touchable {
  private var startButton : SKSpriteNode! = nil
  private let highScoreNode = SKLabelNode(fontNamed: "PixelDigivolve")

  private let startButtonTexture = SKTexture(imageNamed: "survival_button")
  private let startButtonPressedTexture = SKTexture(imageNamed: "survival_button_pressed")

  private var versesButton : SKSpriteNode!
  private let versesButtonTexture = SKTexture(imageNamed: "verses_button")
  private let versesButtonPressedTexture = SKTexture(imageNamed: "verses_button_pressed")

  public var startGameAction : (() -> ())?
  public var versesAction : (() -> ())?

  private var selectedButton : SKNode?

  public func setup() {
    //Setup start button
    let appTitleNode = ShadowLabelNode(fontNamed: "PixelDigivolve")
    appTitleNode.text = "RainCat"
    appTitleNode.fontSize = 110

    addChild(appTitleNode)

    startButton = SKSpriteNode(texture: startButtonTexture)
    startButton.position = CGPoint(x: 0, y: appTitleNode.position.y - appTitleNode.fontSize - startButton.size.height / 2)
    addChild(startButton)

    versesButton = SKSpriteNode(texture: versesButtonTexture)
    versesButton.position = CGPoint(x: 0, y: startButton.position.y - startButton.size.height / 2 - versesButton.size.height / 2 - 20)
    addChild(versesButton)

    //Setup high score node
    let defaults = UserDefaults.standard

    let highScore = defaults.integer(forKey: ScoreKey)

    highScoreNode.text = "\(highScore)"
    highScoreNode.fontSize = 90
    highScoreNode.verticalAlignmentMode = .top
    highScoreNode.position = CGPoint(x: 0, y: startButton.size.height / 2 - 65)
    highScoreNode.zPosition = 1

    addChild(highScoreNode)
  }

  public func touchBeganAtPoint(touch: UITouch) {
    let point = touch.location(in: self)

    if selectedButton != nil {
      handleStartButtonHover(isHovering: false)
      handleVersesButtonHover(isHovering: false)
    }

    if startButton.contains(point) {
      selectedButton = startButton
      
      handleStartButtonHover(isHovering: true)
    } else if versesButton.contains(point) {
      selectedButton = versesButton

      handleVersesButtonHover(isHovering: true)
    }
  }

  public func touchMovedToPoint(touch: UITouch) {
    let point = touch.location(in: self)

    if selectedButton == startButton {
      handleStartButtonHover(isHovering: startButton.contains(point))
    } else if selectedButton == versesButton {
      handleVersesButtonHover(isHovering: versesButton.contains(point))
    }
  }

  public func touchEndedAtPoint(touch: UITouch) {
    let point = touch.location(in: self)

    if selectedButton == startButton && startButton.contains(point) && startGameAction != nil {
      handleStartButtonHover(isHovering: false)

      startGameAction!()
    } else if selectedButton == versesButton && versesButton.contains(point) && versesAction != nil {
      handleVersesButtonHover(isHovering: false)

      versesAction!()
    }

    selectedButton = nil
  }

  public func touchCancelledAtPoint(touch: UITouch) {
    selectedButton = nil
    
    handleStartButtonHover(isHovering: false)
  }

  func handleStartButtonHover(isHovering : Bool) {
    if isHovering {
      startButton.texture = startButtonPressedTexture
    } else {
      startButton.texture = startButtonTexture
    }
  }

  func handleVersesButtonHover(isHovering : Bool) {
    if isHovering {
      versesButton.texture = versesButtonPressedTexture
    } else {
      versesButton.texture = versesButtonTexture
    }
  }
}
