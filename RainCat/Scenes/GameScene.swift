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

  private var umbrella : UmbrellaSprite!
  private var cat : CatSprite!
  private var food : FoodSprite?
  private let hud = HudNode()
  private var rainDropTexture : SKTexture

  private var backgroundNode : BackgroundNode!
  private var groundNode : GroundNode!

  private var currentPalette = ColorManager.sharedInstance.resetPaletteIndex()

  private var catScale : CGFloat = 1
  private var rainScale : CGFloat = 1

  public init(size : CGSize, catScale : CGFloat, rainScale : CGFloat) {
    switch rainScale {
    case 2:
      rainDropTexture = SKTexture(imageNamed: "medium_rain_drop")
    case 3:
      rainDropTexture = SKTexture(imageNamed: "large_rain_drop")
    default:
      rainDropTexture = SKTexture(imageNamed: "rain_drop")
    }

    super.init(size: size)

    self.catScale = catScale
    self.rainScale = rainScale
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func sceneDidLoad() {
    self.lastUpdateTime = 0

    //Hud Setup
    hud.setup(size: size, palette:  currentPalette)

    hud.quitButtonAction = {
      let transition = SKTransition.reveal(with: .up, duration: 0.75)
      transition.pausesOutgoingScene = false
      transition.pausesIncomingScene = false
      
      let gameScene = MenuScene(size: self.size)
      gameScene.scaleMode = self.scaleMode

      self.view?.presentScene(gameScene, transition: transition)

      self.hud.quitButtonAction = nil
    }

    addChild(hud)

    //Background Setup
    backgroundNode = BackgroundNode.newInstance(size: size, palette: currentPalette)

    addChild(backgroundNode)

    //Ground Setup
    groundNode = GroundNode.newInstance(size: size, palette: currentPalette)

    addChild(groundNode)
    //World Frame Setup

    var worldFrame = frame
    worldFrame.origin.x -= 100
    worldFrame.origin.y -= 100
    worldFrame.size.height += 200
    worldFrame.size.width += 200

    self.physicsBody = SKPhysicsBody(edgeLoopFrom: worldFrame)
    self.physicsWorld.contactDelegate = self
    self.physicsBody?.categoryBitMask = WorldFrameCategory

    //Add Umbrella
    umbrella = UmbrellaSprite.newInstance(palette: currentPalette)
    umbrella.updatePosition(point: CGPoint(x: frame.midX, y: frame.midY))

    addChild(umbrella)
  }

  override func didMove(to view: SKView) {
    //Spawn initial cat and food

    switch catScale {
    case 2:
      umbrella.minimumHeight = size.height * 0.4
    case 3:
      umbrella.minimumHeight = size.height * 0.5
    default:
      umbrella.minimumHeight = size.height * 0.27
    }

    spawnCat()
    spawnFood()
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    let touchPoint = touches.first?.location(in: self)

    if let point = touchPoint {
      hud.touchBeganAtPoint(point: point)

      if !hud.quitButtonPressed {
        umbrella.setDestination(destination: point)
      }
    }
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    let touchPoint = touches.first?.location(in: self)

    if let point = touchPoint {
      hud.touchMovedToPoint(point: point)

      if !hud.quitButtonPressed {
        umbrella.setDestination(destination: point)
      }
    }
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    let touchPoint = touches.first?.location(in: self)

    if let point = touchPoint {
      hud.touchEndedAtPoint(point: point)
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

    if let food = food {
      cat.update(deltaTime: dt, foodLocation: (food.position))
    }

    cat.movementSpeed = cat.baseMovementSpeed + (cat.baseMovementSpeed * 0.1) * CGFloat(hud.score) / 10.0

    self.lastUpdateTime = currentTime
  }

  //Spawning Functions

  func spawnRaindrop() {
    for _ in 0...Int(hud.score / 10) {
      let rainDrop = SKSpriteNode(texture: rainDropTexture)
      rainDrop.position = CGPoint(x: size.width / 2, y:  size.height / 2)
      rainDrop.zPosition = 2

      let bodyEdge = 20 * rainScale
      rainDrop.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: bodyEdge, height: bodyEdge))
      rainDrop.physicsBody?.categoryBitMask = RainDropCategory
      rainDrop.physicsBody?.contactTestBitMask = WorldFrameCategory
      rainDrop.physicsBody?.density = 0.5

      let randomPosition = abs(CGFloat(random.nextInt()).truncatingRemainder(dividingBy: size.width))
      rainDrop.position = CGPoint(x: randomPosition, y: size.height)

      //Raindrop fun

      if hud.score > 10 && arc4random() % 10 == 0 {
        rainDrop.yScale = -1
      }

      if hud.score > 20 && arc4random() % 10 == 0 {
        rainDrop.physicsBody?.velocity.dx = (CGFloat(arc4random()).truncatingRemainder(dividingBy: 4) + 1.0) * 100
        rainDrop.physicsBody?.velocity.dx *= arc4random() % 2 == 0 ? -1 : 1
        rainDrop.zPosition = 4
        rainDrop.color = currentPalette.umbrellaBottomColor
        rainDrop.colorBlendFactor = 0.5
      }

      if hud.score > 30 && arc4random() % 10 == 0 {
        rainDrop.setScale(rainScale * 2)
        rainDrop.physicsBody?.density = 1000
      }

      rainDrop.physicsBody?.linearDamping = CGFloat(arc4random()).truncatingRemainder(dividingBy: 100) / 100

      addChild(rainDrop)
    }
  }

  func spawnCat() {
    if let currentCat = cat, children.contains(currentCat) {
      cat.removeFromParent()
      cat.removeAllActions()
      cat.physicsBody = nil
    }

    cat = CatSprite.newInstance()
    cat.setScale(0.5)
    cat.position = CGPoint(x: umbrella.position.x, y: umbrella.position.y + umbrella.getHeight() / 2)
    cat.run(SKAction.scale(to: catScale, duration: 0.3))

    hud.resetPoints()
    addChild(cat)
  }

  func spawnFood() {
    var containsFood = false

    for child in children {
      if child.name == FoodSprite.foodDishName {
        containsFood = true
        break
      }
    }

    if !containsFood {
      food = FoodSprite.newInstance(palette: currentPalette)
      var randomPosition : CGFloat = CGFloat(random.nextInt())
      randomPosition = randomPosition.truncatingRemainder(dividingBy: size.width - foodEdgeMargin * 2)
      randomPosition = CGFloat(abs(randomPosition))
      randomPosition += foodEdgeMargin

      food?.position = CGPoint(x: randomPosition, y: size.height)
      food?.physicsBody?.friction = 100
      addChild(food!)
    }
  }

  //Contact Functions

  func didBegin(_ contact: SKPhysicsContact) {
    if contact.bodyA.categoryBitMask == FoodCategory || contact.bodyB.categoryBitMask == FoodCategory {
      handleFoodHit(contact: contact)
    }

    if contact.bodyA.categoryBitMask == CatCategory || contact.bodyB.categoryBitMask == CatCategory {
      handleCatCollision(contact: contact)

      return
    }

    if contact.bodyA.categoryBitMask == RainDropCategory {
      contact.bodyA.node?.physicsBody?.collisionBitMask = 0
      contact.bodyA.node?.physicsBody?.categoryBitMask = 0
    } else if contact.bodyB.categoryBitMask == RainDropCategory {
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
      hud.resetPoints()
      resetColorPalette()

      rainDropSpawnRate = 0.5
      physicsWorld.gravity = CGVector(dx: 0, dy: -7.8)
    case WorldFrameCategory:
      spawnCat()
    case FloorCategory:
      cat.isGrounded = true
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
      hud.addPoint()

      if hud.score % 5 == 0 {
        updateColorPalette()
        rainDropSpawnRate *= 0.95
      }

      //Stronger gravity the higher the score
      let dy : CGFloat = -7.8 - CGFloat(hud.score % 10)
      var dx : CGFloat = 0.0

      //Update Gravity here
      if hud.score > 50  {
        dx = 2.0
      }

      physicsWorld.gravity = CGVector(dx: dx, dy: dy)

      fallthrough
    case WorldFrameCategory:
      foodBody.node?.removeFromParent()
      foodBody.node?.physicsBody = nil
      
      food = nil
      
      spawnFood()
      
    default:
      print("something else touched the food")
    }
  }

  func updateColorPalette() {
    currentPalette = ColorManager.sharedInstance.getNextColorPalette()

    for node in children {
      if let node = node as? Palettable {
        node.updatePalette(palette: currentPalette)
      }
    }
  }

  func resetColorPalette() {
    currentPalette = ColorManager.sharedInstance.resetPaletteIndex()

    for node in children {
      if let node = node as? Palettable {
        node.updatePalette(palette: currentPalette)
      }
    }
  }

  deinit {
    print("game scene destroyed")
  }
}
