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

  private var versusButton : SKSpriteNode!
  private let versusButtonTexture = SKTexture(imageNamed: "versus_button")
  private let versusButtonPressedTexture = SKTexture(imageNamed: "versus_button_pressed")

  public var startGameAction : (() -> ())?
  public var versusAction : (() -> ())?

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

    versusButton = SKSpriteNode(texture: versusButtonTexture)
    versusButton.position = CGPoint(x: 0, y: startButton.position.y - startButton.size.height / 2 - versusButton.size.height / 2 - 20)
    addChild(versusButton)

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

  public func touchBegan(touch: UITouch) {
    let point = touch.location(in: self)

    if selectedButton != nil {
      handleStartButtonHover(isHovering: false)
      handleVersesButtonHover(isHovering: false)
    }

    if startButton.contains(point) {
      selectedButton = startButton
      
      handleStartButtonHover(isHovering: true)
    } else if versusButton.contains(point) {
      selectedButton = versusButton

      handleVersesButtonHover(isHovering: true)
    }
  }

  public func touchMoved(touch: UITouch) {
    let point = touch.location(in: self)

    if selectedButton == startButton {
      handleStartButtonHover(isHovering: startButton.contains(point))
    } else if selectedButton == versusButton {
      handleVersesButtonHover(isHovering: versusButton.contains(point))
    }
  }

  public func touchEnded(touch: UITouch) {
    let point = touch.location(in: self)

    if selectedButton == startButton && startButton.contains(point) && startGameAction != nil {
      handleStartButtonHover(isHovering: false)

      startGameAction!()
    } else if selectedButton == versusButton && versusButton.contains(point) && versusAction != nil {
      handleVersesButtonHover(isHovering: false)

      versusAction!()
    }

    selectedButton = nil
  }

  public func touchCancelled(touch: UITouch) {
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
      versusButton.texture = versusButtonPressedTexture
    } else {
      versusButton.texture = versusButtonTexture
    }
  }

  func clearActions() {
    startGameAction = nil
    versusAction = nil
  }
}
