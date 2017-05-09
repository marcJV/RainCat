//
//  LogoButtonSprite.swift
//  RainCat
//
//  Created by Marc Vandehey on 5/8/17.
//  Copyright © 2017 Thirteen23. All rights reserved.
//

import SpriteKit

class LogoButtonSprite : SKAControlSprite {
  func getUrl() -> String? {
    return userData?.value(forKey: "url") as? String
  }

  override func updateControl() {
    var action : SKAction
    if controlState.contains(.Disabled) {
      action = SKAction.scale(to: 0.25, duration: 0.15)
    } else if controlState.contains(.Highlighted) {
      action = SKAction.scale(to: 0.9, duration: 0.15)
    } else {
      action = SKAction.scale(to: 0.75, duration: 0.15)
    }

    run(action)
  }
}
