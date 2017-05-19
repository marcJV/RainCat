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

  var classicButton : TwoPaneButton!
  var catPongButton : TwoPaneButton!
  var classicHighScoreText : SKLabelNode!
  var multiplayerText : ShadowLabelNode!
  var umbrella1 : UmbrellaSprite!
  var umbrella2 : UmbrellaSprite!

  var classicReference : AnimationReference!
  var catPongReference : AnimationReference!
  var classicHighScoreReference : AnimationReference!
  var multiplayerReference : AnimationReference!
  var umbrella1Reference : AnimationReference!
  var umbrella2Reference : AnimationReference!

  var selectedButton : TwoPaneButton?

  func setup(sceneSize: CGSize) {
    classicButton = childNode(withName: "button-multi-classic") as! TwoPaneButton!
    classicReference = AnimationReference(zeroPosition: classicButton.position.x,
                                          offscreenLeft: -sceneSize.width - classicButton.position.x,
                                          offscreenRight: sceneSize.width + classicButton.position.x)

    catPongButton = childNode(withName: "button-multi-cat-pong") as! TwoPaneButton!
    catPongReference = AnimationReference(zeroPosition: catPongButton.position.x,
                                          offscreenLeft: -sceneSize.width - catPongButton.position.x,
                                          offscreenRight: sceneSize.width + catPongButton.position.x)

    multiplayerText = childNode(withName: "label-multiplayer") as! ShadowLabelNode!
    multiplayerReference = AnimationReference(zeroPosition: multiplayerText.position.x,
                                              offscreenLeft: -sceneSize.width * 1.2 - multiplayerText.position.x,
                                              offscreenRight: sceneSize.width * 1.2 + multiplayerText.position.x)

    classicHighScoreText = childNode(withName: "label-multi-classic-highscore") as! SKLabelNode!
    classicHighScoreReference = AnimationReference(zeroPosition: classicHighScoreText.position.x,
                                                   offscreenLeft: -sceneSize.width - classicHighScoreText.position.x,
                                                   offscreenRight: sceneSize.width + classicHighScoreText.position.x)

    umbrella1 = childNode(withName: "umbrella-1") as! UmbrellaSprite!
    umbrella1Reference = AnimationReference(zeroPosition: umbrella1.position.x,
                                            offscreenLeft: -sceneSize.width - umbrella1.position.x,
                                            offscreenRight: sceneSize.width + umbrella1.position.x)

    umbrella2 = childNode(withName: "umbrella-2") as! UmbrellaSprite!
    umbrella2Reference = AnimationReference(zeroPosition: umbrella2.position.x,
                                            offscreenLeft: -sceneSize.width - umbrella2.position.x,
                                            offscreenRight: sceneSize.width + umbrella2.position.x)

    classicButton.addTarget(self, selector: #selector(navigateToClassic), forControlEvents: .TouchUpInside)
    catPongButton.addTarget(self, selector: #selector(navigateToCatPong), forControlEvents: .TouchUpInside)

    navigateOutToRight(duration: 0.0)
  }

  func getName() -> String {
    return "multiplayer"
  }

  func navigateInFromRight(duration: TimeInterval) {
    classicButton.moveTo(x: classicReference.zeroPosition, duration: duration)
    catPongButton.moveTo(x: catPongReference.zeroPosition, duration: duration)

    multiplayerText.run(SKActionHelper.moveToEaseInOut(x: multiplayerReference.zeroPosition, duration: duration))
    classicHighScoreText.run(SKActionHelper.moveToEaseInOut(x: classicHighScoreReference.zeroPosition, duration: duration * 1.05))
    umbrella1.run(SKActionHelper.moveToEaseInOut(x: umbrella1Reference.zeroPosition, duration: duration * 1.1))
    umbrella2.run(SKActionHelper.moveToEaseInOut(x: umbrella2Reference.zeroPosition, duration: duration * 1.15))
  }

  func navigateInFromLeft(duration: TimeInterval) {
    classicButton.moveTo(x: classicReference.zeroPosition, duration: duration)
    catPongButton.moveTo(x: catPongReference.zeroPosition, duration: duration)

    multiplayerText.run(SKActionHelper.moveToEaseInOut(x: multiplayerReference.zeroPosition, duration: duration))
    classicHighScoreText.run(SKActionHelper.moveToEaseInOut(x: classicHighScoreReference.zeroPosition, duration: duration * 1.05))
    umbrella1.run(SKActionHelper.moveToEaseInOut(x: umbrella1Reference.zeroPosition, duration: duration * 1.1))
    umbrella2.run(SKActionHelper.moveToEaseInOut(x: umbrella2Reference.zeroPosition, duration: duration * 1.15))
  }

  func navigateOutToRight(duration: TimeInterval) {
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
  }
  
  func navigateOutToLeft(duration: TimeInterval) {
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

    umbrella1.run(SKAction.sequence([
      SKAction.wait(forDuration: 0.1),
      SKActionHelper.moveToEaseInOut(x: umbrella1Reference.offscreenLeft, duration: duration)
      ]))

    umbrella2.run(SKAction.sequence([
      SKAction.wait(forDuration: 0.1),
      SKActionHelper.moveToEaseInOut(x: umbrella2Reference.offscreenLeft, duration: duration)
      ]))
  }

  func navigateToClassic() {
    if let nav = menuNavigation {
      nav.navigateToMultiplerClassic()
    }
  }

  func navigateToCatPong() {
    if let nav = menuNavigation {
      nav.menuToPlayerSelect()
    }
  }
}
