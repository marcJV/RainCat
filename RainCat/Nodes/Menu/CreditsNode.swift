//
//  CreditsNode.swift
//  RainCat
//
//  Created by Marc Vandehey on 9/20/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

public class CreditsNode : SKNode, MenuNodeAnimation {
  weak var menuNavigation : MenuNavigation?

  var marcButton : CreditLabelButtonSprite!
  var jeffButton : CreditLabelButtonSprite!
  var bensoundButton : CreditLabelButtonSprite!
  var cathrynButton : CreditLabelButtonSprite!
  var morganButton : CreditLabelButtonSprite!
  var lauraButton : CreditLabelButtonSprite!
  var logoButton : LogoButtonSprite!

  var developmentLabel : SKLabelNode!
  var designLabel : SKLabelNode!
  var musicLabel : SKLabelNode!

  var developReference : AnimationReference!
  var designReference : AnimationReference!
  var musicReference : AnimationReference!
  var logoReference : AnimationReference!

  var developLabelReference : AnimationReference!
  var musicLabelReference : AnimationReference!
  var designLabelReference : AnimationReference!

  func creditButtonClicked(_ sender : CreditLabelButtonSprite) {
    menuNavigation?.navigateToUrl(url: sender.getUrl()!)
  }

  func logoClicked(_ sender : LogoButtonSprite) {
    menuNavigation?.navigateToUrl(url: sender.getUrl()!)
  }

  func getName() -> String {
    return "credits"
  }

  func setup(sceneSize: CGSize) {
    marcButton = childNode(withName: "button-marc") as! CreditLabelButtonSprite
    marcButton.addTarget(self, selector: #selector(creditButtonClicked(_:)), forControlEvents: .TouchUpInside)

    jeffButton = childNode(withName: "button-jeff") as! CreditLabelButtonSprite
    jeffButton.addTarget(self, selector: #selector(creditButtonClicked(_:)), forControlEvents: .TouchUpInside)

    bensoundButton = childNode(withName: "button-bensound") as! CreditLabelButtonSprite
    bensoundButton.addTarget(self, selector: #selector(creditButtonClicked(_:)), forControlEvents: .TouchUpInside)

    cathrynButton = childNode(withName: "button-cathryn") as! CreditLabelButtonSprite
    cathrynButton.addTarget(self, selector: #selector(creditButtonClicked(_:)), forControlEvents: .TouchUpInside)

    morganButton = childNode(withName: "button-morgan") as! CreditLabelButtonSprite
    morganButton.addTarget(self, selector: #selector(creditButtonClicked(_:)), forControlEvents: .TouchUpInside)

    lauraButton = childNode(withName: "button-laura") as! CreditLabelButtonSprite
    lauraButton.addTarget(self, selector: #selector(creditButtonClicked(_:)), forControlEvents: .TouchUpInside)

    logoButton = childNode(withName: "button-logo") as! LogoButtonSprite
    logoButton.addTarget(self, selector: #selector(logoClicked(_:)), forControlEvents: .TouchUpInside)

    developmentLabel = childNode(withName: "label-development") as! SKLabelNode
    designLabel = childNode(withName: "label-design") as! SKLabelNode
    musicLabel = childNode(withName: "label-music") as! SKLabelNode

    developReference = AnimationReference(zeroPosition: marcButton.position.x,
                                          offscreenLeft: marcButton.position.x - sceneSize.width,
                                          offscreenRight: sceneSize.width + marcButton.position.x)

    designReference = AnimationReference(zeroPosition: morganButton.position.x,
                                         offscreenLeft: morganButton.position.x - sceneSize.width,
                                         offscreenRight: sceneSize.width + morganButton.position.x)

    musicReference = AnimationReference(zeroPosition: jeffButton.position.x,
                                        offscreenLeft: jeffButton.position.x - sceneSize.width,
                                        offscreenRight: sceneSize.width + jeffButton.position.x)

    developLabelReference = AnimationReference(zeroPosition: developmentLabel.position.x,
                                               offscreenLeft: developmentLabel.position.x - sceneSize.width,
                                               offscreenRight: sceneSize.width + developmentLabel.position.x)

    designLabelReference = AnimationReference(zeroPosition: designLabel.position.x,
                                              offscreenLeft: designLabel.position.x - sceneSize.width,
                                              offscreenRight: sceneSize.width + designLabel.position.x)

    musicLabelReference = AnimationReference(zeroPosition: musicLabel.position.x,
                                             offscreenLeft: musicLabel.position.x - sceneSize.width,
                                             offscreenRight: sceneSize.width + musicLabel.position.x)

    logoReference = AnimationReference(zeroPosition: logoButton.position.x,
                                       offscreenLeft: logoButton.position.x - sceneSize.width,
                                       offscreenRight: sceneSize.width + logoButton.position.x)

    navigateOutToRight(duration: 0)
  }

  func navigateOutToLeft(duration: TimeInterval) {

  }

  func navigateInFromLeft(duration: TimeInterval) {

  }

  func navigateOutToRight(duration: TimeInterval) {
    logoButton.run(SKActionHelper.moveToEaseInOut(x: logoReference.offscreenRight, duration: duration * 0.9))

    developmentLabel.run(SKActionHelper.moveToEaseInOut(x: developLabelReference.offscreenRight, duration: duration * 1.05))
    marcButton.run(SKActionHelper.moveToEaseInOut(x: developReference.offscreenRight, duration: duration))

    musicLabel.run(SKActionHelper.moveToEaseInOut(x: musicLabelReference.offscreenRight, duration: duration * 1.05))
    jeffButton.run(SKActionHelper.moveToEaseInOut(x: musicReference.offscreenRight, duration: duration))
    bensoundButton.run(SKActionHelper.moveToEaseInOut(x: musicReference.offscreenRight, duration: duration * 0.95))

    designLabel.run(SKActionHelper.moveToEaseInOut(x: designLabelReference.offscreenRight, duration: duration * 1.05))
    cathrynButton.run(SKActionHelper.moveToEaseInOut(x: designReference.offscreenRight, duration: duration))
    morganButton.run(SKActionHelper.moveToEaseInOut(x: designReference.offscreenRight, duration: duration * 0.95))
    lauraButton.run(SKActionHelper.moveToEaseInOut(x: designReference.offscreenRight, duration: duration * 0.9))

    tempDisableButton(duration: duration)
  }
  
  func navigateInFromRight(duration: TimeInterval) {
    logoButton.run(SKActionHelper.moveToEaseInOut(x: logoReference.zeroPosition, duration: duration * 0.9))

    developmentLabel.run(SKActionHelper.moveToEaseInOut(x: developLabelReference.zeroPosition, duration: duration * 0.95))
    marcButton.run(SKActionHelper.moveToEaseInOut(x: developReference.zeroPosition, duration: duration))

    musicLabel.run(SKActionHelper.moveToEaseInOut(x: musicLabelReference.zeroPosition, duration: duration * 0.95))
    jeffButton.run(SKActionHelper.moveToEaseInOut(x: musicReference.zeroPosition, duration: duration))
    bensoundButton.run(SKActionHelper.moveToEaseInOut(x: musicReference.zeroPosition, duration: duration * 1.05))

    designLabel.run(SKActionHelper.moveToEaseInOut(x: designLabelReference.zeroPosition, duration: duration * 0.95))
    cathrynButton.run(SKActionHelper.moveToEaseInOut(x: designReference.zeroPosition, duration: duration))
    morganButton.run(SKActionHelper.moveToEaseInOut(x: designReference.zeroPosition, duration: duration * 1.05))
    lauraButton.run(SKActionHelper.moveToEaseInOut(x: designReference.zeroPosition, duration: duration * 1.1))

    tempDisableButton(duration: duration)
  }

  func tempDisableButton(duration : TimeInterval) {
    logoButton.isUserInteractionEnabled = false
    marcButton.isUserInteractionEnabled = false
    jeffButton.isUserInteractionEnabled = false
    bensoundButton.isUserInteractionEnabled = false
    cathrynButton.isUserInteractionEnabled = false
    morganButton.isUserInteractionEnabled = false
    lauraButton.isUserInteractionEnabled = false

    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
      self.logoButton.isUserInteractionEnabled = true
      self.marcButton.isUserInteractionEnabled = true
      self.jeffButton.isUserInteractionEnabled = true
      self.bensoundButton.isUserInteractionEnabled = true
      self.cathrynButton.isUserInteractionEnabled = true
      self.morganButton.isUserInteractionEnabled = true
      self.lauraButton.isUserInteractionEnabled = true
    }
  }
}
