//
//  PlayerSelectNode.swift
//  RainCat
//
//  Created by Marc Vandehey on 9/20/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

public class PlayerSelectNode : SKNode, Touchable {

  private var startButton : TwoPaneButton!
  private var backButton : TwoPaneButton!

  private let umbrella1 = UmbrellaSprite.newInstance(palette: ColorManager.sharedInstance.getColorPalette(0))
  private let umbrella2 = UmbrellaSprite.newInstance(palette: ColorManager.sharedInstance.getColorPalette(1))

  private let versesTitle = ShadowLabelNode(fontNamed: BASE_FONT_NAME)

  private var selectedNode : SKNode?

  private var player1ColorIndex = 0
  private var player2ColorIndex = 1

  public var startAction : (() -> ())?
  public var backAction : (() -> ())?

  public func setup(width : CGFloat) {
    player1ColorIndex = UserDefaultsManager.sharedInstance.playerOnePalette
    player2ColorIndex = UserDefaultsManager.sharedInstance.playerTwoPalette

    umbrella1.updatePalette(palette: player1ColorIndex)
    umbrella2.updatePalette(palette: player2ColorIndex)

    let margin : CGFloat = 15
    versesTitle.fontSize = 100
    versesTitle.text = "Cat-Pong"
    versesTitle.position = CGPoint(x: width / 2, y: 0)
    addChild(versesTitle)

    startButton = TwoPaneButton(color: UIColor.clear, size: CGSize(width: 300, height: 70))
    startButton.setup(text: "Start", fontSize: 30)
    startButton.addTarget(self, selector: #selector(startCatPong(_:)), forControlEvents: .TouchUpInside)

    startButton.position = CGPoint(x: width / 2 - startButton.size.width / 2, y: -versesTitle.fontSize)
    addChild(startButton)

    backButton = TwoPaneButton(color: UIColor.clear, size: CGSize(width: 250, height: 50))
    backButton.setup(text: "Back", fontSize: 25)
    backButton.addTarget(self, selector: #selector(backToMenu(_:)), forControlEvents: .TouchUpInside)
    backButton.position = CGPoint(x: width / 2 - backButton.size.width / 2,
                                  y: startButton.position.y - startButton.size.height - margin * 2)
    addChild(backButton)

    umbrella1.position = CGPoint(x: width * 0.15, y: startButton.position.y - 40)
    addChild(umbrella1)

    umbrella2.position = CGPoint(x: width * 0.85, y: startButton.position.y - 40)
    addChild(umbrella2)
  }

  public func touchBegan(touch: UITouch) {
    let point = touch.location(in: self)

    if selectedNode == nil {
      if umbrella1.contains(point) {
        selectedNode = umbrella1

        handleAlpha(node: umbrella1, highlighted: true)
      } else if umbrella2.contains(point) {
        selectedNode = umbrella2

        handleAlpha(node: umbrella2, highlighted: true)
      }
    }
  }

  public func touchMoved(touch: UITouch) {
    let point = touch.location(in: self)

    if let selectedNode = selectedNode {
      handleAlpha(node: selectedNode, highlighted: selectedNode.contains(point))
    }
  }

  public func touchEnded(touch: UITouch) {
    let point = touch.location(in: self)

    if selectedNode == umbrella1 && umbrella1.contains(point) {
      handleAlpha(node: umbrella1, highlighted: false)

      player1ColorIndex = ColorManager.sharedInstance.getNextColorPaletteIndex(player1ColorIndex)
      umbrella1.updatePalette(palette: ColorManager.sharedInstance.getColorPalette(player1ColorIndex))

      UserDefaultsManager.sharedInstance.updatePlayerOnePalette(palette: player1ColorIndex)
    } else if selectedNode == umbrella2 && umbrella2.contains(point) {
      handleAlpha(node: umbrella2, highlighted: false)

      player2ColorIndex = ColorManager.sharedInstance.getNextColorPaletteIndex(player2ColorIndex)
      umbrella2.updatePalette(palette: ColorManager.sharedInstance.getColorPalette(player2ColorIndex))

      UserDefaultsManager.sharedInstance.updatePlayerOnePalette(palette: player2ColorIndex)
    }

    selectedNode = nil
  }

  public func touchCancelled(touch: UITouch) {
    selectedNode = nil

    handleAlpha(node: umbrella1, highlighted: false)
    handleAlpha(node: umbrella2, highlighted: false)
  }

  func startCatPong(_ sender:AnyObject) {
    startAction!()
  }

  func backToMenu(_ sender:AnyObject) {
    backAction!()
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

  func clearActions() {
    startAction = nil
    backAction = nil
  }
}
