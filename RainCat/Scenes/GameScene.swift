//
//  GameScene.swift
//  RainCat
//
//  Created by Marc Vandehey on 8/29/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {

  private var lastUpdateTime : TimeInterval = 0
  private var currentRainDropSpawnTime : TimeInterval = 0
  private var rainDropSpawnRate : TimeInterval = 0.5
  private let random = GKARC4RandomSource()

  private let umbrella = UmbrellaSprite.newInstance()

  override func sceneDidLoad() {
    self.lastUpdateTime = 0

    var worldFrame = frame
    worldFrame.origin.x -= 100
    worldFrame.origin.y -= 100
    worldFrame.size.height += 200
    worldFrame.size.width += 200

    self.physicsBody = SKPhysicsBody(edgeLoopFrom: worldFrame)
    self.physicsWorld.contactDelegate = self
    self.physicsBody?.categoryBitMask = WorldFrameCategory

    let floorNode = SKShapeNode(rectOf: CGSize(width: size.width, height: 5))
    floorNode.position = CGPoint(x: size.width / 2, y: 50)
    floorNode.fillColor = SKColor.red
    floorNode.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: -size.width / 2, y: 0), to: CGPoint(x: size.width, y: 0))
    floorNode.physicsBody?.categoryBitMask = FloorCategory
    floorNode.physicsBody?.contactTestBitMask = RainDropCategory
    floorNode.physicsBody?.restitution = 0.3

    addChild(floorNode)

    umbrella.updatePosition(point: CGPoint(x: frame.midX, y: frame.midY))
    addChild(umbrella)
  }


  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    let touchPoint = touches.first?.location(in: self)

    if let point = touchPoint {
      umbrella.setDestination(destination: point)
    }
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    let touchPoint = touches.first?.location(in: self)

    if let point = touchPoint {
      umbrella.setDestination(destination: point)
    }
  }

  override func update(_ currentTime: TimeInterval) {
    // Called before each frame is rendered

    // Initialize _lastUpdateTime if it has not already been
    if (self.lastUpdateTime == 0) {
      self.lastUpdateTime = currentTime
    }

    // Calculate time since last update
    let dt = currentTime - self.lastUpdateTime

    // Update the Spawn Timer
    currentRainDropSpawnTime += dt

    if currentRainDropSpawnTime > rainDropSpawnRate {
      currentRainDropSpawnTime = 0

      spawnRaindrop()
    }

    umbrella.update(deltaTime: dt)

    self.lastUpdateTime = currentTime
  }

  func spawnRaindrop() {
    let rainDrop = SKShapeNode(rectOf: CGSize(width: 20, height: 20))
    rainDrop.position = CGPoint(x: size.width / 2, y:  size.height / 2)
    rainDrop.fillColor = SKColor.blue
    rainDrop.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 20, height: 20))
    rainDrop.physicsBody?.categoryBitMask = RainDropCategory
    rainDrop.physicsBody?.contactTestBitMask = WorldFrameCategory

    let randomPosition = abs(CGFloat(random.nextInt()).truncatingRemainder(dividingBy: size.width))
    rainDrop.position = CGPoint(x: randomPosition, y: size.height)

    addChild(rainDrop)
  }

  func didBegin(_ contact: SKPhysicsContact) {
    if (contact.bodyA.categoryBitMask == RainDropCategory) {
      contact.bodyA.node?.physicsBody?.collisionBitMask = 0
      contact.bodyA.node?.physicsBody?.categoryBitMask = 0
    } else if (contact.bodyB.categoryBitMask == RainDropCategory) {
      contact.bodyB.node?.physicsBody?.collisionBitMask = 0
      contact.bodyB.node?.physicsBody?.categoryBitMask = 0
    }

    if contact.bodyA.categoryBitMask == WorldFrameCategory {
      contact.bodyB.node?.removeFromParent()
      contact.bodyB.node?.physicsBody = nil
      contact.bodyB.node?.removeAllActions()
    } else if contact.bodyB.categoryBitMask == WorldFrameCategory {
      contact.bodyA.node?.removeFromParent()
      contact.bodyA.node?.physicsBody = nil
      contact.bodyA.node?.removeAllActions()
    }
  }
}
