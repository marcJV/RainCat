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
  private var newNode : SceneNode?
  private var extras : MenuExtras?
  private var lastTime : TimeInterval = 0
  private var transition : RainTransition!

  override func didMove(to view: SKView) {
    transition = RainTransition()
    transition.setup()
    addChild(transition)

    navigate(to: .Logo, extras: nil)
  }

  func navigate(to: Location, extras menuExtras: MenuExtras?) {
    transition.performTransition(extras : menuExtras?.transition)

    baseNode?.zPosition = 1

    SoundManager.sharedInstance.resumeMusic()

    switch to {
    case .MainMenu:
      newNode = MenuSceneNode(color: .clear, size: size)
    case .Classic:
      newNode = GameScene(color: .clear, size: size)
    case .LCD:
      newNode = LCDSceneNode(color: .clear, size: size)
      SoundManager.sharedInstance.muteMusic()
    case .ClassicMulti:
      let game = GameScene(color: .clear, size: size)
      game.isMultiplayer = true

      newNode = game
    case .CatPong:
      newNode = PingPongSceneNode(color: .clear, size: size)
    case .Directions:
      newNode = DirectionsSceneNode(color: .clear, size: size)
    default:
      newNode = LogoScene(color: .clear, size: size)
    }

    self.extras = menuExtras
    newNode!.zPosition = 2

    if self.extras?.transition == nil {
      transitionCoveredScreen()
    }
  }

  func transitionCoveredScreen() {
    if newNode != nil  && newNode?.parent == nil {
      newNode!.layoutScene(size: size, extras: extras)

      physicsWorld.gravity = newNode!.getGravity()

      if baseNode != nil {
        updateBaseNode(newNode: newNode!)
      } else {
        baseNode = newNode
        addChild(newNode!)
        newNode!.attachedToScene()
      }
    }

    newNode = nil
    extras = nil
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
