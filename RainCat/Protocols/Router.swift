//
//  Router.swift
//  RainCat
//
//  Created by Marc Vandehey on 5/2/17.
//  Copyright © 2017 Thirteen23. All rights reserved.
//

import SpriteKit

protocol Router {
  func navigate(to: Location, extras menuExtras : MenuExtras?)

  func transitionCoveredScreen()
}

protocol WorldManager {
  func updateGravity(vector : CGVector)
  func tempPauseScene(duration: TimeInterval)
}

public enum Location {
  case Logo, MainMenu, Classic, LCD, ClassicMulti, CatPong, Directions
}
