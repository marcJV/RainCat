//
//  TitleMenuNode.swift
//  RainCat
//
//  Created by Marc Vandehey on 5/3/17.
//  Copyright © 2017 Thirteen23. All rights reserved.
//

import SpriteKit

class TitleMenuNode : SKNode, MenuNodeAnimation {
  weak var menuNavigation : MenuNavigation?

  var singlePlayerButton : TwoPaneButton!
  var multiPlayerButton : TwoPaneButton!
  var titleText : ShadowLabelNode!
  var tutorialButton : TwoPaneButton!

  var selectedButton : TwoPaneButton?

  var size : CGSize!

  var singlePlayerReference : AnimationReference!
  var multiPlayerReference : AnimationReference!
  var titleReference : AnimationReference!
  var tutorialReference : AnimationReference!


  func setup(sceneSize: CGSize) {
    self.size = sceneSize

    titleText = childNode(withName: "rain-cat-logo") as! ShadowLabelNode
    singlePlayerButton = childNode(withName: "button-single-player") as! TwoPaneButton
    multiPlayerButton = childNode(withName: "button-multi-player") as! TwoPaneButton
    tutorialButton = childNode(withName: "button-tutorial") as! TwoPaneButton


    singlePlayerReference = AnimationReference(zeroPosition: singlePlayerButton.position.x, offscreenLeft: -size.width - singlePlayerButton.position.x, offscreenRight: size.width)

    multiPlayerReference = AnimationReference(zeroPosition: multiPlayerButton.position.x, offscreenLeft: -size.width - multiPlayerButton.position.x, offscreenRight: size.width)

    titleReference = AnimationReference(zeroPosition: titleText.position.x, offscreenLeft: -size.width - titleText.position.x, offscreenRight: size.width)

    tutorialReference = AnimationReference(zeroPosition: tutorialButton.position.x, offscreenLeft: -size.width - tutorialButton.position.x, offscreenRight: size.width)

    singlePlayerButton.addTarget(self, selector: #selector(singlePlayerButtonClicked(_:)), forControlEvents: .TouchUpInside)
    multiPlayerButton.addTarget(self, selector: #selector(multiplayerButtonClicked(_:)), forControlEvents: .TouchUpInside)
    tutorialButton.addTarget(self, selector: #selector(tutorialButtonClicked), forControlEvents: .TouchUpInside)
  }

  func singlePlayerButtonClicked(_ sender : TwoPaneButton) {
    if let menu = menuNavigation {
      selectedButton = singlePlayerButton

      menu.menuToSinglePlayer()
    }

    tempDisableButton(duration: 1)
  }

  func multiplayerButtonClicked(_ sender : TwoPaneButton) {
    if let menu = menuNavigation {
      selectedButton = multiPlayerButton

      menu.menuToMultiplayer()
    }

    tempDisableButton(duration: 1)
  }

  func tutorialButtonClicked() {
    if let menu = menuNavigation {
      menu.navigateToTutorial()
    }
  }

  func getName() -> String {
    return "title"
  }

  func navigateInFromLeft(duration: TimeInterval) {
    var delay : TimeInterval = 0.05
    var wait : TimeInterval = 0.1

    if duration == 0 {
      delay = 0
      wait = 0
    }

    if let button = selectedButton {
      if singlePlayerButton.isEqual(to: button) {
        singlePlayerButton.moveTo(x: singlePlayerReference.zeroPosition, duration: duration)
        multiPlayerButton.moveTo(x: multiPlayerReference.zeroPosition, duration: duration, delay: delay)
        tutorialButton.moveTo(x: tutorialReference.zeroPosition, duration: duration, delay: delay * 2)
      } else {
        multiPlayerButton.moveTo(x: multiPlayerReference.zeroPosition, duration: duration)
        singlePlayerButton.moveTo(x: singlePlayerReference.zeroPosition, duration: duration, delay: delay)
        tutorialButton.moveTo(x: tutorialReference.zeroPosition, duration: duration, delay: delay * 2)
      }
    } else {
      multiPlayerButton.moveTo(x: multiPlayerReference.zeroPosition, duration: duration)
      singlePlayerButton.moveTo(x: singlePlayerReference.zeroPosition, duration: duration)
      tutorialButton.moveTo(x: tutorialReference.zeroPosition, duration: duration)
    }

    titleText.run(SKAction.sequence([
      SKAction.wait(forDuration: wait),
      SKActionHelper.moveToEaseInOut(x: titleReference.zeroPosition, duration: duration)
      ]))

    selectedButton = nil

    tempDisableButton(duration: duration)
  }

  func navigateInFromRight(duration: TimeInterval) {
    //Not implemented
  }

  func navigateOutToLeft(duration: TimeInterval) {
    var delay : TimeInterval = 0.05
    var wait : TimeInterval = 0.1

    if duration == 0 {
      delay = 0
      wait = 0
    }

    if let button = selectedButton {
      if singlePlayerButton.isEqual(to: button) {
        singlePlayerButton.moveTo(x: singlePlayerReference.offscreenLeft, duration: duration)
        multiPlayerButton.moveTo(x: multiPlayerReference.offscreenLeft, duration: duration, delay: delay)
        tutorialButton.moveTo(x: tutorialReference.offscreenLeft, duration: duration, delay: delay * 2)
      } else {
        multiPlayerButton.moveTo(x: multiPlayerReference.offscreenLeft, duration: duration)
        singlePlayerButton.moveTo(x: singlePlayerReference.offscreenLeft, duration: duration, delay: delay)
        tutorialButton.moveTo(x: tutorialReference.offscreenLeft, duration: duration, delay: delay * 2)
      }
    } else {
      multiPlayerButton.moveTo(x: multiPlayerReference.offscreenLeft, duration: duration)
      singlePlayerButton.moveTo(x: singlePlayerReference.offscreenLeft, duration: duration)
      tutorialButton.moveTo(x: tutorialReference.offscreenLeft, duration: duration)
    }


    titleText.run(SKAction.sequence([
      SKAction.wait(forDuration: wait),
      SKActionHelper.moveToEaseInOut(x: titleReference.offscreenLeft, duration: duration)
      ]))

    tempDisableButton(duration: duration)
  }

  func navigateOutToRight(duration: TimeInterval) {
    //Not implimented
  }

  func tempDisableButton(duration : TimeInterval) {
    singlePlayerButton.isUserInteractionEnabled = false
    multiPlayerButton.isUserInteractionEnabled = false

    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
      self.singlePlayerButton.isUserInteractionEnabled = true
      self.multiPlayerButton.isUserInteractionEnabled = true
    }
  }
}
