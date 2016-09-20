//
//  PingPongScene.swift
//  RainCat
//
//  Created by Marc Vandehey on 9/17/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

public class PingPongScene : SKScene, SKPhysicsContactDelegate {
  private var umbrella1 : UmbrellaSprite!
  private var umbrella2 : UmbrellaSprite!

  private let cat1 = CatSprite.newInstance()
  private let cat2 = CatSprite.newInstance()

  private let hud = PingPongHud()

  private let cat1Key = "PLAYER_ONE_CAT"
  private let cat2Key = "PLAYER_TWO_CAT"

  private var puck : SKSpriteNode?

  private var lastUpdateTime : TimeInterval = 0
  private let maxNoHitTime : TimeInterval = 5
  private var currentNoHitTime : TimeInterval = 0

  private var cat1Destination = CGPoint()
  private var cat2Destination = CGPoint()

  private var cat1ZeroPosition = CGPoint()
  private var cat2ZeroPosition = CGPoint()

  private var umbrella1ZeroPosition = CGPoint()
  private var umbrella2ZeroPosition = CGPoint()

  private let backgroundNode = PingPongBackgroundNode()

  private var deadZone :CGFloat = 150

  private var cat1X : CGFloat = 0
  private var cat2X : CGFloat = 0

  private let umbrellaScale : CGFloat = 0.85

  private let p1Rotation = CGFloat(M_PI / -2.0)
  private let p2Rotation = CGFloat(M_PI / 2.0)

  private var catHit = false
  private var p1LastHit = false

  private var roundStarted = false
  private var showingWinCondition = false

  private let maxPoints = 7

  //Track finger movement based on touches
  private var p1Touch : UITouch?
  private var p2Touch : UITouch?

  private var player1Palette : ColorPalette!
  private var player2Palette : ColorPalette!

  private var rainScale : CGFloat!
  private var catScale : CGFloat!

  private var destinationOffset : CGFloat

  private var giantMode = false

  public init(size: CGSize, player1ColorPalette : ColorPalette, player2ColorPalette : ColorPalette, catScale : CGFloat, rainScale : CGFloat) {
    player1Palette = player1ColorPalette
    player2Palette = player2ColorPalette

    self.catScale = catScale
    self.rainScale = rainScale

    destinationOffset = 50 * ((catScale > 1) ? catScale : 1)

    if catScale > 2 {
      giantMode = true
    }

    super.init(size: size)
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func sceneDidLoad() {
    if giantMode {
      deadZone = 75
    }

    hud.setup(size: size)

    addChild(hud)

    backgroundColor = SKColor(red:0.38, green:0.60, blue:0.65, alpha:1.0)

    backgroundNode.setup(frame: frame, deadZone: deadZone, playerOnePalette: player1Palette, playerTwoPalette: player2Palette)
    addChild(backgroundNode)

    //Override graviy for the cats
    physicsWorld.gravity = CGVector()
    physicsWorld.contactDelegate = self

    physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
    physicsBody?.restitution = 0.4
    physicsBody?.friction = 0.1

    setupUmbrellas()
    setupCats()

    resetLocations(arc4random() % 2 == 0) //random start location

    hud.quitButtonAction = {
      let transition = SKTransition.reveal(with: .up, duration: 0.75)
      transition.pausesOutgoingScene = false
      transition.pausesIncomingScene = false

      let gameScene = MenuScene(size: self.size)
      gameScene.scaleMode = self.scaleMode

      self.view?.presentScene(gameScene, transition: transition)

      self.hud.quitButtonAction = nil
    }

    hud.rematchButtonAction = {
      self.rematchPressed()
    }
  }

  private func setupPuck() {
    if puck == nil {
      puck = SKSpriteNode(imageNamed: "medium_rain_drop")
    }

    puck!.setScale(rainScale)
    puck!.zPosition = 4
    puck!.physicsBody = SKPhysicsBody(circleOfRadius: puck!.size.height / 3)
    puck!.physicsBody?.categoryBitMask = RainDropCategory
    puck!.physicsBody?.contactTestBitMask = UmbrellaCategory | WorldFrameCategory | CatCategory
    puck!.physicsBody?.restitution = 1
    puck!.physicsBody?.linearDamping = 0.5

    addChild(puck!)
  }

  private func setupCats() {
    cat1.physicsBody?.collisionBitMask = RainDropCategory
    cat2.physicsBody?.collisionBitMask = RainDropCategory

    cat1.name = cat1Key
    cat2.name = cat2Key

    cat1.physicsBody?.linearDamping = 0
    cat2.physicsBody?.linearDamping = 0

    cat1.walkHorizontally = false
    cat2.walkHorizontally = false

    cat1.isGrounded = true
    cat2.isGrounded = true

    cat1.setScale(catScale)
    cat2.setScale(catScale)

    cat1.zRotation = p1Rotation
    cat1.flipScale = true
    cat2.zRotation = p2Rotation

    cat1X = cat1.size.height * 0.55
    cat2X = frame.maxX - cat2.size.height * 0.6

    cat1ZeroPosition = CGPoint(x:cat1X,  y: frame.midY)

    cat1.position = cat1ZeroPosition
    cat1Destination = cat1.position
    cat1Destination.y = destinationOffset

    cat2ZeroPosition = CGPoint(x: cat2X, y: frame.midY)
    cat2.position = cat2ZeroPosition
    cat2Destination.y = frame.height - destinationOffset

    addChild(cat1)
    addChild(cat2)
  }

  private func setupUmbrellas() {
    umbrella1 = UmbrellaSprite.newInstance(palette: player1Palette, pingPong: true)
    umbrella2 = UmbrellaSprite.newInstance(palette: player2Palette, pingPong: true)

    umbrella1.physicsBody?.restitution = 0.1
    umbrella2.physicsBody?.restitution = 0.1

    umbrella1.setScale(umbrellaScale)
    umbrella2.setScale(umbrellaScale)

    //Rotate our umbrellas!
    umbrella1.zRotation = p1Rotation
    umbrella2.zRotation = p2Rotation

    umbrella1ZeroPosition = CGPoint(x: 150, y: frame.midY)
    umbrella2ZeroPosition = CGPoint(x: frame.maxX - 150, y: frame.midY)

    umbrella1.updatePosition(point: umbrella1ZeroPosition)
    umbrella2.updatePosition(point: umbrella2ZeroPosition)

    addChild(umbrella1)
    addChild(umbrella2)
  }

  private func resetLocations(_ playerOnePuck : Bool) {
    cat1.physicsBody?.velocity = CGVector()
    cat1.physicsBody?.angularVelocity = 0

    cat2.physicsBody?.velocity = CGVector()
    cat2.physicsBody?.angularVelocity = 0

    umbrella1.run(SKAction.move(to: umbrella1ZeroPosition, duration: 0.25))
    umbrella1.setDestination(destination: umbrella1ZeroPosition)

    umbrella2.run(SKAction.move(to: umbrella2ZeroPosition, duration: 0.25))
    umbrella2.setDestination(destination: umbrella2ZeroPosition)

    cat1Destination = cat1ZeroPosition
    cat1Destination.y = destinationOffset

    cat2Destination = cat2ZeroPosition
    cat2Destination.y = frame.height - destinationOffset

    cat1.run(SKAction.move(to: cat1ZeroPosition, duration: 0.25))
    cat2.run(SKAction.move(to: cat2ZeroPosition, duration: 0.25))

    cat1.run(SKAction.rotate(toAngle: p1Rotation, duration: 0.25))
    cat2.run(SKAction.rotate(toAngle: p2Rotation, duration: 0.25))

    currentNoHitTime = 0

    catHit = false
    roundStarted = false

    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(200)) {
      self.setupPuck()

      if playerOnePuck {
        self.puck?.position = CGPoint(x: self.frame.midX - self.deadZone - 65,
                                      y: self.frame.height * (self.umbrella1.position.y > self.frame.height / 2 ? 0.25 : 0.75))
      } else {
        self.puck?.position = CGPoint(x: self.frame.midX + self.deadZone + 65,
                                      y: self.frame.height * (self.umbrella2.position.y > self.frame.height / 2 ? 0.25 : 0.75))
      }
    }
  }

  private func rematchPressed() {
    let player1Lost = hud.playerTwoScore >= maxPoints

    hud.hideRematchButton()
    hud.hideMessage()
    hud.resetScore()

    let showAction = SKAction.fadeIn(withDuration: 0.25)

    cat1.run(showAction)
    cat2.run(showAction)

    umbrella1.run(showAction)
    umbrella2.run(showAction)

    backgroundNode.run(showAction)

    let umbrellaScaleAction = SKAction.scale(to: umbrellaScale, duration: 0.25)

    umbrella1.run(umbrellaScaleAction)
    umbrella2.run(umbrellaScaleAction)

    umbrella1.run(SKAction.rotate(toAngle: p1Rotation, duration: 0.25))
    umbrella2.run(SKAction.rotate(toAngle: p2Rotation, duration: 0.25))

    showingWinCondition = false
    catHit = false
    roundStarted = false

    puck?.removeFromParent()
    puck = nil

    setupPuck()
    resetLocations(player1Lost)
  }

  override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    let touchPoint = touches.first?.location(in: self)

    if let point = touchPoint {
      hud.touchBeganAtPoint(point: point)

      if catHit {
        return
      }

      if !hud.quitButtonPressed {
        for touch in touches {
          var location = touch.location(in: self)

          if location.x < frame.midX {
            if p1Touch == nil {
              p1Touch = touch

              if location.x > frame.midX - deadZone {
                location.x = frame.midX - deadZone
              }

              umbrella1.setDestination(destination: location)
            }
          } else {
            if p2Touch == nil {
              p2Touch = touch

              if location.x < frame.midX + deadZone {
                location.x = frame.midX + deadZone
              }

              umbrella2.setDestination(destination: location)
            }
          }
        }
      }
    }
  }

  override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    let touchPoint = touches.first?.location(in: self)

    if let point = touchPoint {
      hud.touchMovedToPoint(point: point)

      if catHit {
        return
      }

      if !hud.quitButtonPressed {
        for touch in touches {
          var location = touch.location(in: self)

          if p1Touch == touch {
            if location.x > frame.midX - deadZone {
              location.x = frame.midX - deadZone
            }

            umbrella1.setDestination(destination: location)
          } else if p2Touch == touch {
            if location.x < frame.midX + deadZone {
              location.x = frame.midX + deadZone
            }

            umbrella2.setDestination(destination: location)
          }
        }
      }
    }
  }

  override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    let touchPoint = touches.first?.location(in: self)

    if let point = touchPoint {
      hud.touchEndedAtPoint(point: point)
    }

    for touch in touches {
      if p1Touch == touch {
        p1Touch = nil
      } else if p2Touch == touch {
        p2Touch = nil
      }
    }
  }

  public override func update(_ currentTime: TimeInterval) {
    //check if raindrop is outside bounds, then reset

    if showingWinCondition {
      return
    }

    if (self.lastUpdateTime == 0) {
      self.lastUpdateTime = currentTime
    }

    let dt = currentTime - self.lastUpdateTime

    if roundStarted {
      currentNoHitTime += dt
    }

    if currentNoHitTime > maxNoHitTime {
      resetLocations(false)
    }

    umbrella1.update(deltaTime: dt)
    umbrella2.update(deltaTime: dt)

    if abs(cat1.position.y - cat1Destination.y) < 30 {
      if cat1.position.y < frame.midY {
        cat1Destination.y = frame.height - destinationOffset
      } else {
        cat1Destination.y = destinationOffset
      }
    }

    cat1Destination.x = cat1X
    cat1.update(deltaTime: dt, foodLocation: cat1Destination)

    if abs(cat2.position.y - cat2Destination.y) < 30 {
      if cat2.position.y < frame.midY {
        cat2Destination.y = frame.height - destinationOffset
      } else {
        cat2Destination.y = destinationOffset
      }
    }

    cat2Destination.x = cat2X
    cat2.update(deltaTime: dt, foodLocation: cat2Destination)

    lastUpdateTime = currentTime
  }

  public func didBegin(_ contact: SKPhysicsContact) {
    //So far only the rain drop and something else can come into contact
    var otherBody : SKPhysicsBody

    if contact.bodyA.categoryBitMask == RainDropCategory {
      otherBody = contact.bodyB
    } else if contact.bodyB.categoryBitMask == RainDropCategory {
      otherBody = contact.bodyA
    } else {
      return
    }

    currentNoHitTime = 0

    switch otherBody.categoryBitMask {
    case UmbrellaCategory:
      roundStarted = true

      puck?.physicsBody?.angularVelocity = 0.0

      var impulse = (otherBody.node?.parent as? UmbrellaSprite)!.getVelocity()

      impulse.dx /= 2
      impulse.dy /= 2

      let max : CGFloat = 25

      //Check who hit the puck last
      p1LastHit = otherBody.node?.parent == umbrella1

      if abs(impulse.dx) > max {
        impulse.dx = max * ((impulse.dx > 1) ? 1 : -1)
      }

      if abs(impulse.dy) > max {
        impulse.dy = max * ((impulse.dy > 1) ? 1 : -1)
      }

      puck?.physicsBody?.applyImpulse(impulse)
    case CatCategory:
      if !roundStarted {
        return
      }
      
      if !catHit {
        catHit = true

        puck?.physicsBody = nil
        puck?.removeFromParent()
        puck = nil

        if otherBody.node?.name == cat1Key {
          hud.incrementPlayerTwo()

          if hud.playerTwoScore >= maxPoints {
            hud.showMessageIndefinitely(message: "Cat 2 WINS")

            showWinner()
            return
          } else if p1LastHit {
            hud.showMessage(message: "Cat 1 scored for Cat 2!")
          } else {
            hud.showMessage(message: "Cat 2 scored!")
          }

          cat1.hitByRain()
          cat1.removeAllActions()
          cat1.physicsBody?.angularVelocity = 0.75

          p1LastHit = true
        } else if otherBody.node?.name == cat2Key {
          hud.incrementPlayerOne()

          if hud.playerOneScore >= maxPoints {
            hud.showMessageIndefinitely(message: "Cat 1 WINS")

            showWinner()

            return
          } else if !p1LastHit {
            hud.showMessage(message: "Cat 2 scored for Cat 1!")
          } else {
            hud.showMessage(message: "Cat 1 scored!")
          }

          cat2.hitByRain()
          cat2.removeAllActions()
          cat2.physicsBody?.angularVelocity = 0.75

          p1LastHit = false
        } else {
          print("wtf")
        }

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
          self.resetLocations(self.p1LastHit)
        }
      }

    default:
      break
    }
  }

  private func showWinner() {
    showingWinCondition = true
    hud.showRematchButton()

    let winAnimation = SKAction.group([
      SKAction.rotate(toAngle: 0, duration: 0.25),
      SKAction.scale(to: 2, duration: 0.25),
      SKAction.move(to: CGPoint(x: frame.midX, y: frame.midY), duration: 0.25)
      ])
    
    let fadeOutAction = SKAction.fadeOut(withDuration: 0.25)
    
    backgroundNode.run(fadeOutAction)
    puck?.run(fadeOutAction)
    
    if hud.playerTwoScore >= maxPoints {
      //P2 wins
      umbrella2.run(winAnimation)
      umbrella1.run(fadeOutAction)
      
      cat2.run(fadeOutAction)
      
    } else if hud.playerOneScore >= maxPoints {
      //P1 wins
      umbrella1.run(winAnimation)
      umbrella2.run(fadeOutAction)
      
      cat1.run(fadeOutAction)
    }
    
    umbrella1.physicsBody = nil
    umbrella2.physicsBody = nil
    puck?.physicsBody = nil
  }
  
  deinit {
    print("pingpong scene destroyed")
  }
}
