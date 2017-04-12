//
//  CatSprite.swift
//  RainCat
//
//  Created by Marc Vandehey on 8/31/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

public class CatSprite : SKSpriteNode {
  public var walkHorizontally = true

  private let walkingActionKey = "action_walking"
  private var timeSinceLastHit : TimeInterval = 2
  private let maxFlailTime : TimeInterval = 2

  private var currentRainHits = 4
  private let maxRainHits = 4

  let baseMovementSpeed : CGFloat = 100
  var movementSpeed : CGFloat = 100
  var flipScale = false //used only for ping pong for player 1

  var isGrounded = false

  private let walkFrames = [
    SKTexture(imageNamed: "cat_one"),
    SKTexture(imageNamed: "cat_two")
  ]

public static func newInstance() -> CatSprite {
    let catSprite = CatSprite(imageNamed: "cat_two")

    catSprite.zPosition = 3
    catSprite.physicsBody = SKPhysicsBody(circleOfRadius: catSprite.size.width / 2)
    catSprite.physicsBody?.categoryBitMask = CatCategory
    catSprite.physicsBody?.contactTestBitMask = RainDropCategory | WorldFrameCategory | FloorCategory

    return catSprite
  }

  public func update(deltaTime : TimeInterval, foodLocation: CGPoint) {
    timeSinceLastHit += deltaTime

    if timeSinceLastHit >= maxFlailTime && isGrounded {
      if action(forKey: walkingActionKey) == nil {
        let walkingAction = SKAction.repeatForever(
          SKAction.animate(with: walkFrames,
                           timePerFrame: 0.1,
                           resize: false,
                           restore: true))

        run(walkingAction, withKey:walkingActionKey)
      }

      if walkHorizontally {
        if zRotation != 0 && action(forKey: "action_rotate") == nil {
          run(SKAction.rotate(toAngle: 0, duration: 0.25), withKey: "action_rotate")
        }

        //Stand still if the food is above us
        if foodLocation.y > position.y && abs(foodLocation.x - position.x) < 2 {
          physicsBody?.velocity.dx = 0
          removeAction(forKey: walkingActionKey)
          texture = walkFrames[1]
        } else if foodLocation.x < position.x {
          //Food is left
          physicsBody?.velocity.dx = -movementSpeed
          xScale = -1 * abs(xScale)
        } else {
          //Food is right
          physicsBody?.velocity.dx = movementSpeed
          xScale = abs(xScale)
        }
      } else {
        //Used for Cat Pong
        if foodLocation.y < position.y {
          //Food is down
          physicsBody?.velocity.dy = -movementSpeed
          xScale = abs(yScale) * (flipScale ? 1 : -1)

        } else {
          //Food is up
          physicsBody?.velocity.dy = movementSpeed
          xScale = abs(yScale) * (flipScale ? -1 : 1)
        }
      }

      physicsBody?.angularVelocity = 0
    }
  }

  public func hitByRain() {
    timeSinceLastHit = 0
    removeAction(forKey: walkingActionKey)

    //Determine if we should meow or not
    if(currentRainHits < maxRainHits) {
      currentRainHits += 1

      return
    }

    currentRainHits = 0

    SoundManager.sharedInstance.meow(node: self)
  }
}
