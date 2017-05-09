//
//  CurtainSprite.swift
//  RainCat
//
//  Created by Marc Vandehey on 5/2/17.
//  Copyright © 2017 Thirteen23. All rights reserved.
//

import SpriteKit

class CurtainSprite : SKShapeNode {

  public static func newInstance(size: CGSize) -> CurtainSprite {
    let path = UIBezierPath()
    path.move(to: CGPoint())
    path.addLine(to: CGPoint(x: size.width, y: 0))
    path.addLine(to: CGPoint(x: size.width, y: size.height))
    path.addLine(to: CGPoint(x: 0, y: size.height))

    let spikeCount = 15

    let spikeDepth = size.height / CGFloat(spikeCount)

    for i in 0...(spikeCount + 1) {
      let height = spikeDepth * CGFloat(i)

      path.addLine(to: CGPoint(x: spikeDepth * 0.45, y: size.height - height))
      path.addLine(to: CGPoint(x: 0, y: size.height - height - spikeDepth / 2))
    }

    return CurtainSprite(path: path.cgPath)
  }
}
