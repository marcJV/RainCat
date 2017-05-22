//
//  RainCatScene.swift
//  RainCat
//
//  Created by Marc Vandehey on 5/2/17.
//  Copyright © 2017 Thirteen23. All rights reserved.
//

import SpriteKit

class RainCatScene : SKScene, Router, WorldManager {
  private var baseNode : SceneNode?
  private var lastTime : TimeInterval = 0

  override func didMove(to view: SKView) {
    navigate(to: .Logo, extras: nil)
  }

func navigate(to: Location, extras menuExtras: MenuExtras?) {
    baseNode?.zPosition = 1
    var newNode : SceneNode

    switch to {
    case .MainMenu:
      newNode = MenuSceneNode(color: .clear, size: size)
    case .Classic:
      newNode = GameScene(color: .clear, size: size)
    case .LCD:
      newNode = LCDSceneNode(color: .clear, size: size)
    case .ClassicMulti: fallthrough
    case .CatPong:
      newNode = PingPongSceneNode(color: .clear, size: size)
    default:
      newNode = LogoScene(color: .clear, size: size)
    }

    newNode.zPosition = 2
    newNode.layoutScene(size: size, extras: menuExtras)

    physicsWorld.gravity = newNode.getGravity()

    if baseNode != nil {
      updateBaseNode(newNode: newNode)
    } else {
      baseNode = newNode
      addChild(newNode)
      newNode.attachedToScene()
    }
  }

  private func updateBaseNode(newNode : SceneNode) {
    (baseNode!).removeFromParent()
    baseNode!.detachedFromScene()

    baseNode = newNode
    addChild(newNode)
    newNode.attachedToScene()

    if let _ = baseNode as? SKPhysicsContactDelegate {
      physicsWorld.contactDelegate = (baseNode as! SKPhysicsContactDelegate)
    }
  }

  func updateGravity(vector: CGVector) {
    physicsWorld.gravity = vector
  }

  func tempPauseScene(duration: TimeInterval) {
    physicsWorld.speed = 0.4

    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
      self.physicsWorld.speed = 1
    }
  }

  override func update(_ currentTime: TimeInterval) {
    var deltaTime = currentTime - lastTime

    if deltaTime > 1 {
      deltaTime = 0
    }

    lastTime = currentTime

    if baseNode != nil {
      baseNode!.update(dt: deltaTime)
    }
  }
}
