//
//  FadeableButton.swift
//  RainCat
//
//  Created by Marc Vandehey on 9/29/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

class AlphaButton : SKAControlSprite {
  override func updateControl() {
    if controlState.contains(.Disabled) {
      run(SKAction.fadeAlpha(to: 0.4, duration: 0.15))
    } else if controlState.contains(.Highlighted) {
      run(SKAction.fadeAlpha(to: 0.6, duration: 0.15))
    } else if controlState.contains(.Normal) {
      run(SKAction.fadeAlpha(to: 1, duration: 0.15))
    }
  }
}
