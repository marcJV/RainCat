//
//  MenuNavigation.swift
//  RainCat
//
//  Created by Marc Vandehey on 5/8/17.
//  Copyright © 2017 Thirteen23. All rights reserved.
//

import SpriteKit

protocol MenuNavigation : class {
  func menuToSinglePlayer()
  func menuToMultiplayer()
  func menuToPlayerSelect()

  func navigateToUrl(url : String)

  func navigateToSinglePlayerClassic()
  func navigateToSinglePlayerLCD()

  func navigateToMultiplerClassic()
  func navigateToMultiplayerCatPong()

  func navigateToTutorial()

  func menuBack()
}

protocol MenuNodeAnimation : class {
  func getName() -> String

  func setup(sceneSize : CGSize)

  func navigateInFromLeft(duration : TimeInterval)
  func navigateInFromRight(duration : TimeInterval)
  
  func navigateOutToLeft(duration : TimeInterval)
  func navigateOutToRight(duration : TimeInterval)
}

struct AnimationReference {
  let zeroPosition : CGFloat
  let offscreenLeft : CGFloat
  let offscreenRight : CGFloat
}

protocol PingPongNavigation : QuitNavigation {
  func restartPressed()
}

protocol QuitNavigation : class {
  func quitPressed()
}
