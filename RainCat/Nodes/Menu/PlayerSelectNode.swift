//
//  PlayerSelectNode.swift
//  RainCat
//
//  Created by Marc Vandehey on 9/20/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

public class PlayerSelectNode : SKNode, MenuNodeAnimation {
  weak var menuNavigation : MenuNavigation?

  private var startButton : TwoPaneButton!

  private var catPongLabel : ShadowLabelNode!

  private var umbrella1 : UmbrellaSprite!
  private var umbrella2 : UmbrellaSprite!

  private var player1ColorIndex = 0
  private var player2ColorIndex = 1

  private var umbrella1Reference : AnimationReference!
  private var umbrella2Reference : AnimationReference!
  private var catPongLabelReference : AnimationReference!
  private var buttonStartReference : AnimationReference!

  public func setup(sceneSize: CGSize) {
    player1ColorIndex = UserDefaultsManager.sharedInstance.playerOnePalette
    player2ColorIndex = UserDefaultsManager.sharedInstance.playerTwoPalette

    umbrella1 = childNode(withName: "umbrella1") as! UmbrellaSprite
    umbrella2 = childNode(withName: "umbrella2") as! UmbrellaSprite

    umbrella1.updatePalette(palette: player1ColorIndex)
    umbrella2.updatePalette(palette: player2ColorIndex)

    umbrella1.clickArea!.name = "umbrella1"
    umbrella2.clickArea!.name = "umbrella2"

    umbrella1.clickArea?.addTarget(self, selector: #selector(umbrellaTapped(_:)), forControlEvents: .TouchUpInside)
    umbrella2.clickArea?.addTarget(self, selector: #selector(umbrellaTapped(_:)), forControlEvents: .TouchUpInside)

    startButton = childNode(withName: "button-catpong-start") as! TwoPaneButton
    startButton.addTarget(self, selector: #selector(startCatPong), forControlEvents: .TouchUpInside)

    catPongLabel = childNode(withName: "label-catpong") as! ShadowLabelNode

    umbrella1Reference = AnimationReference(zeroPosition: umbrella1.position.x,
                                          offscreenLeft: umbrella1.position.x - sceneSize.width,
                                          offscreenRight: sceneSize.width + umbrella1.position.x)

    umbrella2Reference = AnimationReference(zeroPosition: umbrella2.position.x,
                                            offscreenLeft: umbrella2.position.x - sceneSize.width,
                                            offscreenRight: sceneSize.width + umbrella2.position.x)

    catPongLabelReference = AnimationReference(zeroPosition: catPongLabel.position.x,
                                            offscreenLeft: catPongLabel.position.x - sceneSize.width,
                                            offscreenRight: sceneSize.width + catPongLabel.position.x)

    buttonStartReference = AnimationReference(zeroPosition: startButton.position.x,
                                            offscreenLeft: startButton.position.x - sceneSize.width,
                                            offscreenRight: sceneSize.width + startButton.position.x)

    navigateOutToRight(duration: 0)
  }

  func getName() -> String {
    return "playerSelect"
  }

  func umbrellaTapped(_ sender : UmbrellaSprite) {
    if sender.name == umbrella1.clickArea!.name {
      player1ColorIndex = ColorManager.sharedInstance.getNextColorPaletteIndex(player1ColorIndex)
      umbrella1.updatePalette(palette: ColorManager.sharedInstance.getColorPalette(player1ColorIndex))

      UserDefaultsManager.sharedInstance.updatePlayerOnePalette(palette: player1ColorIndex)
    } else {
      player2ColorIndex = ColorManager.sharedInstance.getNextColorPaletteIndex(player2ColorIndex)
      umbrella2.updatePalette(palette: ColorManager.sharedInstance.getColorPalette(player2ColorIndex))

      UserDefaultsManager.sharedInstance.updatePlayerTwoPalette(palette: player2ColorIndex)
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

  func startCatPong() {
    if let menu = menuNavigation {
      menu.navigateToMultiplayerCatPong()
    }
  }

  func navigateOutToLeft(duration: TimeInterval) {

  }

  func navigateInFromLeft(duration: TimeInterval) {

  }

  func navigateOutToRight(duration: TimeInterval) {
    umbrella1.run(SKActionHelper.moveToEaseInOut(x: umbrella1Reference.offscreenRight, duration: duration))
    umbrella2.run(SKActionHelper.moveToEaseInOut(x: umbrella2Reference.offscreenRight, duration: duration))
    catPongLabel.run(SKActionHelper.moveToEaseInOut(x: catPongLabelReference.offscreenRight, duration: duration))
    startButton.moveTo(x: buttonStartReference.offscreenRight, duration: duration)
  }

  func navigateInFromRight(duration: TimeInterval) {
    umbrella1.run(SKActionHelper.moveToEaseInOut(x: umbrella1Reference.zeroPosition, duration: duration))
    umbrella2.run(SKActionHelper.moveToEaseInOut(x: umbrella2Reference.zeroPosition, duration: duration))
    catPongLabel.run(SKActionHelper.moveToEaseInOut(x: catPongLabelReference.zeroPosition, duration: duration))
    startButton.moveTo(x: buttonStartReference.zeroPosition, duration: duration)
  }
}
