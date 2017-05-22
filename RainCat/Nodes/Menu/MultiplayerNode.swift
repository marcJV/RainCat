//
//  MultiplayerNode.swift
//  RainCat
//
//  Created by Marc Vandehey on 5/10/17.
//  Copyright © 2017 Thirteen23. All rights reserved.
//

import SpriteKit

class MultiplayerNode : SKNode, MenuNodeAnimation {
  weak var menuNavigation : MenuNavigation?

  private var classicButton : TwoPaneButton!
  private var catPongButton : TwoPaneButton!
  private var classicHighScoreText : SKLabelNode!
  private var multiplayerText : ShadowLabelNode!
  private var umbrella1 : UmbrellaSprite!
  private var umbrella2 : UmbrellaSprite!

  private var classicReference : AnimationReference!
  private var catPongReference : AnimationReference!
  private var classicHighScoreReference : AnimationReference!
  private var multiplayerReference : AnimationReference!
  private var umbrella1Reference : AnimationReference!
  private var umbrella2Reference : AnimationReference!

  var umbrella1LeftPosition : CGPoint!
  var umbrella2LeftPosition : CGPoint!

  private var umbrella1StartScale : CGFloat!
  private var umbrella2StartScale : CGFloat!

  private var umbrella1ZeroYPosition : CGFloat!
  private var umbrella2ZeroYPosition : CGFloat!

  private var umbrella1ZeroAngle : CGFloat!
  private var umbrella2ZeroAngle : CGFloat!

  private var selectedButton : TwoPaneButton?

  private var player1ColorIndex = 0
  private var player2ColorIndex = 1

  func setup(sceneSize: CGSize) {
    classicButton = childNode(withName: "button-multi-classic") as! TwoPaneButton!
    classicReference = AnimationReference(zeroPosition: classicButton.position.x,
                                          offscreenLeft: -sceneSize.width,
                                          offscreenRight: sceneSize.width + classicButton.position.x)

    catPongButton = childNode(withName: "button-multi-cat-pong") as! TwoPaneButton!
    catPongReference = AnimationReference(zeroPosition: catPongButton.position.x,
                                          offscreenLeft: -sceneSize.width,
                                          offscreenRight: sceneSize.width + catPongButton.position.x)

    multiplayerText = childNode(withName: "label-multiplayer") as! ShadowLabelNode!
    multiplayerReference = AnimationReference(zeroPosition: multiplayerText.position.x,
                                              offscreenLeft: -sceneSize.width * 1.2 - multiplayerText.position.x,
                                              offscreenRight: sceneSize.width * 1.2 + multiplayerText.position.x)

    classicHighScoreText = childNode(withName: "label-multi-classic-highscore") as! SKLabelNode!
    classicHighScoreReference = AnimationReference(zeroPosition: classicHighScoreText.position.x,
                                                   offscreenLeft: -sceneSize.width,
                                                   offscreenRight: sceneSize.width + classicHighScoreText.position.x)
    classicHighScoreText.text = "\(UserDefaultsManager.sharedInstance.getClassicMultiplayerHighScore())"

    umbrella1 = childNode(withName: "umbrella-1") as! UmbrellaSprite!
    umbrella1Reference = AnimationReference(zeroPosition: umbrella1.position.x,
                                            offscreenLeft: -sceneSize.width,
                                            offscreenRight: sceneSize.width + umbrella1.position.x)

    umbrella2 = childNode(withName: "umbrella-2") as! UmbrellaSprite!
    umbrella2Reference = AnimationReference(zeroPosition: umbrella2.position.x,
                                            offscreenLeft: -sceneSize.width,
                                            offscreenRight: sceneSize.width + umbrella2.position.x)

    player1ColorIndex = UserDefaultsManager.sharedInstance.playerOnePalette
    player2ColorIndex = UserDefaultsManager.sharedInstance.playerTwoPalette

    umbrella1.updatePalette(palette: player1ColorIndex)
    umbrella2.updatePalette(palette: player2ColorIndex)

    umbrella1ZeroYPosition = umbrella1.position.y
    umbrella2ZeroYPosition = umbrella2.position.y

    umbrella1StartScale = umbrella1.yScale
    umbrella2StartScale = umbrella2.yScale

    umbrella1ZeroAngle = umbrella1.zRotation
    umbrella2ZeroAngle = umbrella2.zRotation

    umbrella1.clickArea!.name = "umbrella1"
    umbrella2.clickArea!.name = "umbrella2"

    umbrella1.clickArea?.addTarget(self, selector: #selector(umbrellaTapped(_:)), forControlEvents: .TouchUpInside)
    umbrella2.clickArea?.addTarget(self, selector: #selector(umbrellaTapped(_:)), forControlEvents: .TouchUpInside)

    classicButton.addTarget(self, selector: #selector(navigateToClassic), forControlEvents: .TouchUpInside)
    catPongButton.addTarget(self, selector: #selector(navigateToCatPong), forControlEvents: .TouchUpInside)

    navigateOutToRight(duration: 0.0)
  }

  func getName() -> String {
    return "multiplayer"
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

  public func playerOnePalette() -> ColorPalette {
    return ColorManager.sharedInstance.getColorPalette(player1ColorIndex)
  }

  public func playerTwoPalette() -> ColorPalette {
    return ColorManager.sharedInstance.getColorPalette(player2ColorIndex)
  }

  func navigateInFromRight(duration: TimeInterval) {
    classicButton.moveTo(x: classicReference.zeroPosition, duration: duration)
    catPongButton.moveTo(x: catPongReference.zeroPosition, duration: duration)

    multiplayerText.run(SKActionHelper.moveToEaseInOut(x: multiplayerReference.zeroPosition, duration: duration))
    classicHighScoreText.run(SKActionHelper.moveToEaseInOut(x: classicHighScoreReference.zeroPosition, duration: duration * 1.05))
    umbrella1.run(SKActionHelper.moveToEaseInOut(x: umbrella1Reference.zeroPosition, duration: duration * 1.1))
    umbrella2.run(SKActionHelper.moveToEaseInOut(x: umbrella2Reference.zeroPosition, duration: duration * 1.15))

    tempDisableButton(duration: duration)
  }

  func navigateOutToRight(duration: TimeInterval) {
    umbrella1.clickArea?.isUserInteractionEnabled = false
    umbrella2.clickArea?.isUserInteractionEnabled = false

    selectedButton = nil

    classicButton.moveTo(x: classicReference.offscreenRight, duration: duration)
    catPongButton.moveTo(x: catPongReference.offscreenRight, duration: duration)

    multiplayerText.run(SKAction.sequence([
      SKAction.wait(forDuration: 0.1),
      SKActionHelper.moveToEaseInOut(x: multiplayerReference.offscreenRight, duration: duration)
      ]))

    classicHighScoreText.run(SKAction.sequence([
      SKAction.wait(forDuration: 0.1),
      SKActionHelper.moveToEaseInOut(x: classicHighScoreReference.offscreenRight, duration: duration)
      ]))

    umbrella1.run(SKAction.sequence([
      SKAction.wait(forDuration: 0.1),
      SKActionHelper.moveToEaseInOut(x: umbrella1Reference.offscreenRight, duration: duration)
      ]))

    umbrella2.run(SKAction.sequence([
      SKAction.wait(forDuration: 0.1),
      SKActionHelper.moveToEaseInOut(x: umbrella2Reference.offscreenRight, duration: duration)
      ]))

    tempDisableButton(duration: duration)
  }

  func navigateInFromLeft(duration: TimeInterval) {
    umbrella1.clickArea?.isUserInteractionEnabled = false
    umbrella2.clickArea?.isUserInteractionEnabled = false

    classicButton.moveTo(x: classicReference.zeroPosition, duration: duration)
    catPongButton.moveTo(x: catPongReference.zeroPosition, duration: duration)

    multiplayerText.run(SKActionHelper.moveToEaseInOut(x: multiplayerReference.zeroPosition, duration: duration))
    classicHighScoreText.run(SKActionHelper.moveToEaseInOut(x: classicHighScoreReference.zeroPosition, duration: duration * 1.05))

    umbrella1.run(SKAction.group([
      SKActionHelper.rotateToEaseInOut(angle: umbrella1ZeroAngle, duration: duration),
      SKAction.scaleX(to: -umbrella1StartScale, duration: duration),
      SKAction.scaleY(to: umbrella1StartScale, duration: duration),
      SKAction.move(to: CGPoint(x: umbrella1Reference.zeroPosition, y: umbrella1ZeroYPosition), duration: duration)

      ]))

    umbrella2.run(SKAction.group([
      SKActionHelper.rotateToEaseInOut(angle: umbrella2ZeroAngle, duration: duration),
      SKAction.scale(to: umbrella2StartScale, duration: duration),
      SKAction.move(to: CGPoint(x: umbrella2Reference.zeroPosition, y: umbrella2ZeroYPosition), duration: duration)
      ]))

    tempDisableButton(duration: duration)
  }

  func navigateOutToLeft(duration: TimeInterval) {
    umbrella1.clickArea?.isUserInteractionEnabled = true
    umbrella2.clickArea?.isUserInteractionEnabled = true

    classicButton.moveTo(x: classicReference.offscreenLeft, duration: duration)
    catPongButton.moveTo(x: catPongReference.offscreenLeft, duration: duration)

    multiplayerText.run(SKAction.sequence([
      SKAction.wait(forDuration: 0.1),
      SKActionHelper.moveToEaseInOut(x: multiplayerReference.offscreenLeft, duration: duration)
      ]))

    classicHighScoreText.run(SKAction.sequence([
      SKAction.wait(forDuration: 0.1),
      SKActionHelper.moveToEaseInOut(x: classicHighScoreReference.offscreenLeft, duration: duration)
      ]))

    umbrella1.run(SKAction.group([
      SKActionHelper.rotateToEaseInOut(angle: 0, duration: duration * 0.8),
      SKAction.scaleX(to: -1, duration: duration * 0.5),
      SKAction.scaleY(to: 1, duration: duration * 0.5),
      SKActionHelper.moveToEasInOut(point: umbrella1LeftPosition, duration: duration * 0.9)
      ]))

    umbrella2.run(SKAction.group([
      SKActionHelper.rotateToEaseInOut(angle: 0, duration: duration * 0.8),
      SKAction.scale(to: 1, duration: duration * 0.5),
      SKActionHelper.moveToEasInOut(point: umbrella2LeftPosition, duration: duration * 0.9)
      ]))

    tempDisableButton(duration: duration)
  }

  func navigateToClassic() {
    if let nav = menuNavigation {
      nav.navigateToMultiplerClassic()
    }

    tempDisableButton(duration: 1)
  }
  
  func navigateToCatPong() {
    if let nav = menuNavigation {
      nav.menuToPlayerSelect()
    }

    tempDisableButton(duration: 1)
  }

  func tempDisableButton(duration : TimeInterval) {
    classicButton.isUserInteractionEnabled = false
    catPongButton.isUserInteractionEnabled = false

    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
      self.classicButton.isUserInteractionEnabled = true
      self.catPongButton.isUserInteractionEnabled = true
    }
  }
}
