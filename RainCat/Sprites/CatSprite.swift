//
//  CatSprite.swift
//  RainCat
//
//  Created by Marc Vandehey on 8/31/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

public class CatSprite : SKSpriteNode {
  public static func newInstance() -> CatSprite {
    let catSprite = CatSprite(imageNamed: "cat_one")

    
    catSprite.zPosition = 3
    catSprite.physicsBody = SKPhysicsBody(circleOfRadius: catSprite.size.width / 2)
    catSprite.physicsBody?.categoryBitMask = CatCategory
    catSprite.physicsBody?.contactTestBitMask = RainDropCategory | WorldFrameCategory

    return catSprite
  }

  public func update(deltaTime : TimeInterval) {

  }
}
