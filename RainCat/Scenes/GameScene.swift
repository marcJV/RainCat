//
//  GameScene.swift
//  RainCat
//
//  Created by Marc Vandehey on 8/29/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {

  private var lastUpdateTime : TimeInterval = 0
  private var currentRainDropSpawnTime : TimeInterval = 0
  private var rainDropSpawnRate : TimeInterval = 0.5

  override func sceneDidLoad() {
    self.lastUpdateTime = 0

    let floorNode = SKShapeNode(rectOf: CGSize(width: size.width, height: 5))
    floorNode.position = CGPoint(x: size.width / 2, y: 50)
    floorNode.fillColor = SKColor.red
    floorNode.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: -size.width / 2, y: 0), to: CGPoint(x: size.width, y: 0))
    addChild(floorNode)
  }


  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

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


    self.lastUpdateTime = currentTime
  }
}
