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
  private let foodEdgeMargin : CGFloat = 75.0

  private let umbrella = UmbrellaSprite.newInstance()
  private var cat : CatSprite!
  private var food : FoodSprite!
  private let rainDropTexture = SKTexture(imageNamed: "rain_drop")

  override func sceneDidLoad() {
    self.lastUpdateTime = 0

    let background = SKSpriteNode(imageNamed: "background")
    background.position = CGPoint(x: frame.midX, y: frame.midY)
    background.zPosition = 0

    addChild(background)

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
    floorNode.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: -size.width / 2, y: 0), to: CGPoint(x: size.width, y: 0))
    floorNode.physicsBody?.categoryBitMask = FloorCategory
    floorNode.physicsBody?.contactTestBitMask = RainDropCategory
    floorNode.physicsBody?.restitution = 0.3

    addChild(floorNode)

    umbrella.updatePosition(point: CGPoint(x: frame.midX, y: frame.midY))
    addChild(umbrella)

    spawnCat()
    spawnFood()
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
    cat.update(deltaTime: dt, foodLocation: food.position)

    self.lastUpdateTime = currentTime
  }

  //Spawning Functions

  func spawnRaindrop() {
    let rainDrop = SKSpriteNode(texture: rainDropTexture)
    rainDrop.position = CGPoint(x: size.width / 2, y:  size.height / 2)
    rainDrop.zPosition = 2
    rainDrop.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 20, height: 20))
    rainDrop.physicsBody?.categoryBitMask = RainDropCategory
    rainDrop.physicsBody?.contactTestBitMask = WorldFrameCategory
    rainDrop.physicsBody?.density = 0.5

    let randomPosition = abs(CGFloat(random.nextInt()).truncatingRemainder(dividingBy: size.width))
    rainDrop.position = CGPoint(x: randomPosition, y: size.height)

    addChild(rainDrop)
  }

  func spawnCat() {
    if let currentCat = cat, children.contains(currentCat) {
      cat.removeFromParent()
      cat.removeAllActions()
      cat.physicsBody = nil
    }

    cat = CatSprite.newInstance()
    cat.position = CGPoint(x: umbrella.position.x, y: umbrella.position.y - 30)

    addChild(cat)
  }

  func spawnFood() {
    food = FoodSprite.newInstance()
    var randomPosition : CGFloat = CGFloat(random.nextInt())
    randomPosition = randomPosition.truncatingRemainder(dividingBy: size.width - foodEdgeMargin * 2)
    randomPosition = CGFloat(abs(randomPosition))
    randomPosition += foodEdgeMargin

    food.position = CGPoint(x: randomPosition, y: size.height)

    addChild(food)
  }

  //Contact Functions

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

  func handleCatCollision(contact: SKPhysicsContact) {
    var otherBody : SKPhysicsBody

    if contact.bodyA.categoryBitMask == CatCategory {
      otherBody = contact.bodyB
    } else {
      otherBody = contact.bodyA
    }

    switch otherBody.categoryBitMask {
    case RainDropCategory:
      cat.hitByRain()
    case WorldFrameCategory:
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
    case WorldFrameCategory:
      foodBody.node?.removeFromParent()
      foodBody.node?.physicsBody = nil

      spawnFood()
    default:
      print("something else touched the food")
    }
  }
}
