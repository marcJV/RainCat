//
//  Touchable.swift
//  RainCat
//
//  Created by Marc Vandehey on 9/20/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

public protocol Touchable {
  func touchBeganAtPoint(touch: UITouch)
  func touchMovedToPoint(touch: UITouch)
  func touchEndedAtPoint(touch: UITouch)
  func touchCancelledAtPoint(touch: UITouch)
}
