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

  private var umbrella1Reference : AnimationReference!
  private var umbrella2Reference : AnimationReference!
  private var catPongLabelReference : AnimationReference!
  private var buttonStartReference : AnimationReference!

  private(set) var umbrellaLeftPositions : (umbrella1Left : CGPoint, umbrella2Left : CGPoint)!

  public func setup(sceneSize: CGSize) {
    umbrella1 = childNode(withName: "umbrella1") as! UmbrellaSprite
    umbrella2 = childNode(withName: "umbrella2") as! UmbrellaSprite

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

    umbrellaLeftPositions = (umbrella1Left: umbrella1.position, umbrella2Left: umbrella2.position)

    navigateOutToRight(duration: 0)
  }

  func getName() -> String {
    return "playerSelect"
  }

  private func handleAlpha(node : SKNode, highlighted : Bool) {
    if highlighted {
      node.run(SKAction.fadeAlpha(to: 0.75, duration: 0.15))
    } else {
      node.run(SKAction.fadeAlpha(to: 1.0, duration: 0.15))
    }
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

    tempDisableButton(duration: 1)
  }

  func navigateInFromRight(duration: TimeInterval) {
    //umbrella1.run(SKActionHelper.moveToEaseInOut(x: umbrella1Reference.zeroPosition, duration: duration))
    //umbrella2.run(SKActionHelper.moveToEaseInOut(x: umbrella2Reference.zeroPosition, duration: duration))
    catPongLabel.run(SKActionHelper.moveToEaseInOut(x: catPongLabelReference.zeroPosition, duration: duration * 0.9))
    startButton.moveTo(x: buttonStartReference.zeroPosition, duration: duration)

    tempDisableButton(duration: 1)
  }

  func tempDisableButton(duration : TimeInterval) {
    startButton.isUserInteractionEnabled = false

    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
      self.startButton.isUserInteractionEnabled = true
    }
  }
}
