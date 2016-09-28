//
//  GameScene.swift
//  RainCat
//
//  Created by Marc Vandehey on 8/29/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {

  private var lastUpdateTime : TimeInterval = 0
  private var currentRainDropSpawnTime : TimeInterval = 0
  private var rainDropSpawnRate : TimeInterval = 0.5

  private let foodEdgeMargin : CGFloat = 75.0

  let raindropTexture = SKTexture(imageNamed: "rain_drop")

  private let backgroundNode = BackgroundNode()
  private let umbrellaNode = UmbrellaSprite.newInstance()
  private var catNode : CatSprite!
  private var foodNode : FoodSprite!

  override func sceneDidLoad() {
    self.lastUpdateTime = 0

    backgroundNode.setup(size: size)
    addChild(backgroundNode)

    umbrellaNode.updatePosition(point: CGPoint(x: frame.midX, y: frame.midY))
    umbrellaNode.zPosition = 4
    addChild(umbrellaNode)

    spawnCat()
    spawnFood()

    var worldFrame = frame
    worldFrame.origin.x -= 100
    worldFrame.origin.y -= 100
    worldFrame.size.height += 200
    worldFrame.size.width += 200

    self.physicsBody = SKPhysicsBody(edgeLoopFrom: worldFrame)
    self.physicsBody?.categoryBitMask = WorldCategory
    self.physicsWorld.contactDelegate = self
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    let touchPoint = touches.first?.location(in: self)

    if let point = touchPoint {
      umbrellaNode.setDestination(destination: point)
    }
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    let touchPoint = touches.first?.location(in: self)

    if let point = touchPoint {
      umbrellaNode.setDestination(destination: point)
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

    umbrellaNode.update(deltaTime: dt)
    catNode.update(deltaTime: dt, foodLocation: foodNode.position)

    // Update the Spawn Timer
    currentRainDropSpawnTime += dt

    if currentRainDropSpawnTime > rainDropSpawnRate {
      currentRainDropSpawnTime = 0
      spawnRaindrop()
    }

    self.lastUpdateTime = currentTime
  }

  private func spawnRaindrop() {
    let raindrop = SKSpriteNode(texture: raindropTexture)
    raindrop.physicsBody = SKPhysicsBody(texture: raindropTexture, size: raindrop.size)
    raindrop.physicsBody?.categoryBitMask = RainDropCategory
    raindrop.physicsBody?.contactTestBitMask = FloorCategory | WorldCategory
    raindrop.physicsBody?.density = 0.5

    let xPosition = CGFloat(arc4random()).truncatingRemainder(dividingBy: size.width)
    let yPosition = size.height + raindrop.size.height
    raindrop.position = CGPoint(x: xPosition, y: yPosition)
    raindrop.zPosition = 2

    addChild(raindrop)
  }

  func spawnCat() {
    if let currentCat = catNode, children.contains(currentCat) {
      catNode.removeFromParent()
      catNode.removeAllActions()
      catNode.physicsBody = nil
    }

    catNode = CatSprite.newInstance()
    catNode.position = CGPoint(x: umbrellaNode.position.x, y: umbrellaNode.position.y - 30)
    
    addChild(catNode)
  }

  func spawnFood() {
    if let currentFood = foodNode, children.contains(currentFood) {
      foodNode.removeFromParent()
      foodNode.removeAllActions()
      foodNode.physicsBody = nil
    }

    foodNode = FoodSprite.newInstance()
    var randomPosition : CGFloat = CGFloat(arc4random())
    randomPosition = randomPosition.truncatingRemainder(dividingBy: size.width - foodEdgeMargin * 2)
    randomPosition += foodEdgeMargin

    foodNode.position = CGPoint(x: randomPosition, y: size.height)

    addChild(foodNode)
  }

  func didBegin(_ contact: SKPhysicsContact) {
    if (contact.bodyA.categoryBitMask == RainDropCategory) {
      contact.bodyA.node?.physicsBody?.collisionBitMask = 0
    } else if (contact.bodyB.categoryBitMask == RainDropCategory) {
      contact.bodyB.node?.physicsBody?.collisionBitMask = 0
    }

    if contact.bodyA.categoryBitMask == FoodCategory || contact.bodyB.categoryBitMask == FoodCategory {
      handleFoodHit(contact: contact)
      return
    }

    if contact.bodyA.categoryBitMask == CatCategory || contact.bodyB.categoryBitMask == CatCategory {
      handleCatCollision(contact: contact)

      return
    }

    if contact.bodyA.categoryBitMask == WorldCategory {
      contact.bodyB.node?.removeFromParent()
      contact.bodyB.node?.physicsBody = nil
      contact.bodyB.node?.removeAllActions()
    } else if contact.bodyB.categoryBitMask == WorldCategory {
      contact.bodyA.node?.removeFromParent()
      contact.bodyA.node?.physicsBody = nil
      contact.bodyA.node?.removeAllActions()
    }
  }

  func handleCatCollision(contact: SKPhysicsContact) {
    var otherBody : SKPhysicsBody

    if contact.bodyA.categoryBitMask == CatCategory {
      otherBody = contact.bodyB
    } else {
      otherBody = contact.bodyA
    }

    switch otherBody.categoryBitMask {
    case RainDropCategory:
      catNode.hitByRain()
    case WorldCategory:
      spawnCat()
    default:
      print("Something hit the cat")
    }
  }

  func handleFoodHit(contact: SKPhysicsContact) {
    var otherBody : SKPhysicsBody
    var foodBody : SKPhysicsBody

    if(contact.bodyA.categoryBitMask == FoodCategory) {
      otherBody = contact.bodyB
      foodBody = contact.bodyA
    } else {
      otherBody = contact.bodyA
      foodBody = contact.bodyB
    }

    switch otherBody.categoryBitMask {
    case CatCategory:
      //TODO increment points
      print("fed cat")
      fallthrough
    case WorldCategory:
      foodBody.node?.removeFromParent()
      foodBody.node?.physicsBody = nil

      spawnFood()
    default:
      print("something else touched the food")
    }
  }
}
