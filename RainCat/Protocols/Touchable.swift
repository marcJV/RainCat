//
//  Touchable.swift
//  RainCat
//
//  Created by Marc Vandehey on 9/20/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

public protocol Touchable {
  func touchBegan(touch: UITouch)
  func touchMoved(touch: UITouch)
  func touchEnded(touch: UITouch)
  func touchCancelled(touch: UITouch)
}

public protocol Updateable {
  func update(deltaTime : TimeInterval)
}
