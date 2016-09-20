//
//  PlayerSelectNode.swift
//  RainCat
//
//  Created by Marc Vandehey on 9/20/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

public class PlayerSelectNode : SKNode, Touchable {

  private var startButton : SKSpriteNode! = nil
  private let startButtonTexture = SKTexture(imageNamed: "button_start")
  private let startButtonPressedTexture = SKTexture(imageNamed: "button_start_pressed")

  private var backButton : SKSpriteNode! = nil
  private let backButtonTexture = SKTexture(imageNamed: "back_button")
  private let backButtonPressedTexture = SKTexture(imageNamed: "back_button_pressed")

  private let umbrella1 = UmbrellaSprite.newInstance(palette: ColorManager.sharedInstance.getColorPalette(0))
  private let umbrella2 = UmbrellaSprite.newInstance(palette: ColorManager.sharedInstance.getColorPalette(1))

  private let versesTitle = ShadowLabelNode(fontNamed: "PixelDigivolve")

  private var selectedNode : SKNode?

  private var player1ColorIndex = 0
  private var player2ColorIndex = 1

  public var startAction : (() -> ())?
  public var backAction : (() -> ())?

  public func setup(width : CGFloat) {
    let margin : CGFloat = 15
    versesTitle.fontSize = 100
    versesTitle.text = "Verses"
    versesTitle.position = CGPoint(x: width / 2, y: 0)
    addChild(versesTitle)

    startButton = SKSpriteNode(texture: startButtonTexture)
    startButton.position = CGPoint(x: width / 2, y: -versesTitle.fontSize - margin)
    addChild(startButton)

    backButton = SKSpriteNode(texture: backButtonTexture)
    backButton.position = CGPoint(x: width / 2, y: startButton.position.y - startButton.size.height - margin)
    addChild(backButton)

    umbrella1.position = CGPoint(x: width * 0.15, y: startButton.position.y)
    addChild(umbrella1)

    umbrella2.position = CGPoint(x: width * 0.85, y: startButton.position.y)
    addChild(umbrella2)
  }

  public func touchBeganAtPoint(touch: UITouch) {
    let point = touch.location(in: self)

    if selectedNode == nil {
      if startButton.contains(point) {
        selectedNode = startButton

        handleStartButtonHover(isHovering: true)
      } else if backButton.contains(point) {
        selectedNode = backButton

        handleBackButtonHover(isHovering: true)
      } else if umbrella1.contains(point) {
        selectedNode = umbrella1

        handleAlpha(node: umbrella1, highlighted: true)
      } else if umbrella2.contains(point) {
        selectedNode = umbrella2

        handleAlpha(node: umbrella2, highlighted: true)
      }
    }
  }

  public func touchMovedToPoint(touch: UITouch) {
    let point = touch.location(in: self)

    if let selectedNode = selectedNode {

      if selectedNode == startButton {
        handleStartButtonHover(isHovering: startButton.contains(point))
      } else if selectedNode == backButton {
        handleBackButtonHover(isHovering: backButton.contains(point))
      } else {
        handleAlpha(node: selectedNode, highlighted: selectedNode.contains(point))
      }
    }
  }

  public func touchEndedAtPoint(touch: UITouch) {
    let point = touch.location(in: self)

    if selectedNode == startButton && startButton.contains(point) && startAction != nil {
      handleStartButtonHover(isHovering: false)

      startAction!()
    } else if selectedNode == backButton && backButton.contains(point) && backAction != nil {
      handleBackButtonHover(isHovering: false)

      backAction!()
    } else if selectedNode == umbrella1 && umbrella1.contains(point) {
      handleAlpha(node: umbrella1, highlighted: false)

      player1ColorIndex += 1

      umbrella1.updatePalette(palette: ColorManager.sharedInstance.getColorPalette(player1ColorIndex))
    } else if selectedNode == umbrella2 && umbrella2.contains(point) {
      handleAlpha(node: umbrella2, highlighted: false)

      player2ColorIndex += 1

      umbrella2.updatePalette(palette: ColorManager.sharedInstance.getColorPalette(player2ColorIndex))
    }

    selectedNode = nil
  }

  public func touchCancelledAtPoint(touch: UITouch) {
    selectedNode = nil

    handleStartButtonHover(isHovering: false)
    handleBackButtonHover(isHovering: false)

    handleAlpha(node: umbrella1, highlighted: false)
    handleAlpha(node: umbrella2, highlighted: false)
  }

  private func handleStartButtonHover(isHovering : Bool) {
    if isHovering {
      startButton.texture = startButtonPressedTexture
    } else {
      startButton.texture = startButtonTexture
    }
  }

  private func handleBackButtonHover(isHovering : Bool) {
    if isHovering {
      backButton.texture = backButtonPressedTexture
    } else {
      backButton.texture = backButtonTexture
    }
  }

  private func handleAlpha(node : SKNode, highlighted : Bool) {
    if highlighted {
      node.run(SKAction.fadeAlpha(to: 0.75, duration: 0.15))
    } else {
      node.run(SKAction.fadeAlpha(to: 1.0, duration: 0.15))
    }
  }

  public func playerOnePalette() -> ColorPalette {
    return ColorManager.sharedInstance.getColorPalette(player1ColorIndex)
  }

  public func playerTwoPalette() -> ColorPalette {
    return ColorManager.sharedInstance.getColorPalette(player2ColorIndex)
  }
}
