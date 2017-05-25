//
//  TimingFunctions.swift
//  RainCat
//
//  Created by Marc Vandehey on 4/17/17.
//  Copyright © 2017 Thirteen23. All rights reserved.
//

import SpriteKit

public func SKTTimingFunctionQuarticEaseOut(_ t: CGFloat) -> CGFloat {

  let startValue : CGFloat = 0
  let endValue : CGFloat = 1
  let duration : CGFloat = 1.0

  SKAction.customAction(withDuration: TimeInterval(duration)) { (node, elapsedTime) in
    if elapsedTime < 0.8 {
      node.position.x = (endValue - startValue) / 0.8
    }
  }

  let f = t - 1.0
  return 1.0 - f * f * f * f
}

