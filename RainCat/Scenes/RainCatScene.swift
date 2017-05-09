//
//  RainCatScene.swift
//  RainCat
//
//  Created by Marc Vandehey on 5/2/17.
//  Copyright © 2017 Thirteen23. All rights reserved.
//

import SpriteKit

class RainCatScene : SKScene, Router {
  private var baseNode : SceneNode?
  private var lastTime : TimeInterval = 0

  override func didMove(to view: SKView) {
    navigate(to: .Logo)
  }


  func navigate(to: Location) {
    baseNode?.zPosition = 1
    var newNode : SceneNode

    switch to {
    case .MainMenu:
      newNode = MenuScene(color: .clear, size: size)
    case .Classic: fallthrough
    case .LCD: fallthrough
    case .ClassicMulti: fallthrough
    case .CatPont: fallthrough
    default:
      newNode = LogoScene(color: .clear, size: size)
    }

    newNode.zPosition = 2
    newNode.layoutScene(size: size)

    addChild(newNode)

    newNode.attachedToScene()

    if baseNode != nil {
      (baseNode!).removeFromParent()
      baseNode!.detachedFromScene()
    }

    baseNode = newNode

    if let _ = baseNode as? SKPhysicsContactDelegate {
      physicsWorld.contactDelegate = (baseNode as! SKPhysicsContactDelegate)
    }
  }

  override func update(_ currentTime: TimeInterval) {
    var deltaTime = currentTime - lastTime

    if deltaTime > 1 {
      deltaTime = 0
    }

    if baseNode != nil {
      baseNode!.update(dt: deltaTime)
    }
  }
}
