//
//  RainDropBanner.swift
//  RainCat
//
//  Created by Marc Vandehey on 9/20/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

public class RainDropBanner : SKNode, Touchable {
  typealias RainDrops = (raindrop: SKSpriteNode, lcdRaindrop: SKSpriteNode)

  var rainDrops = [RainDrops]()

  func pause () {
    for rainDrop in rainDrops {
      rainDrop.raindrop.isPaused = isPaused
      rainDrop.lcdRaindrop.isPaused = isPaused

      rainDrop.raindrop.physicsBody?.isDynamic = isPaused
      rainDrop.raindrop.speed = 0
    }
  }

  public func setup(maskNode : SKNode) {
    for i in 0...23 {
      let index = String(format: "%02d", i)

      let node = childNode(withName: "raindrop\(index)") as! SKSpriteNode

      let lcdNode = SKSpriteNode(imageNamed: "large_rain_drop")

      rainDrops.append((raindrop: node, lcdRaindrop: lcdNode))

      lcdNode.anchorPoint = CGPoint(x: 0, y: 1)
      lcdNode.position = node.position

      maskNode.addChild(lcdNode)

      lcdNode.zPosition = 100
    }
  }

  public func makeItRain() {
    for node in rainDrops {
      addPhysicsBody(rainDrop: node.raindrop)
    }
  }

  private func addPhysicsBody(rainDrop : SKSpriteNode) {
    rainDrop.physicsBody = SKPhysicsBody(texture: rainDrop.texture!, size: rainDrop.size)
    rainDrop.physicsBody?.categoryBitMask = RainDropCategory

    //Makes all of the raindrops fall at different rates
    rainDrop.physicsBody?.linearDamping = CGFloat(arc4random()).truncatingRemainder(dividingBy: 100) / 100
    rainDrop.physicsBody?.mass = CGFloat(arc4random()).truncatingRemainder(dividingBy: 100) / 100
  }

  public func touchBegan(touch: UITouch) {
    for node : RainDrops in rainDrops {
      if node.raindrop.contains(touch.location(in: self)) {
        enlargeRaindrop(node.raindrop)
        enlargeRaindrop(node.lcdRaindrop)
      }
    }
  }

  func enlargeRaindrop(_ raindrop : SKSpriteNode) {
    let oldScale = raindrop.xScale

    let newScale = min(raindrop.xScale + 0.35, 1)
    //Since we use a 0,1 anchor point, we need to update the position to appear centered
    if oldScale != newScale {
      raindrop.position.x -= raindrop.size.width / 33

      let scaleRainDropAction = SKAction.group([
        SKAction.moveTo(x: raindrop.position.x - raindrop.size.width / 4, duration: 0.05),
        SKAction.scale(to: newScale, duration: 0.05)
        ])

      raindrop.run(scaleRainDropAction)
    }
  }

  public func touchMoved(touch: UITouch) {
    //Not implemented
  }

  public func touchEnded(touch: UITouch) {
    //Not implemented
  }

  public func touchCancelled(touch: UITouch) {
    //Not implemented
  }

  public func update(size: CGSize) {
    for node : RainDrops in rainDrops {
      node.lcdRaindrop.position = node.raindrop.position
      node.lcdRaindrop.setScale(node.raindrop.xScale)
      node.lcdRaindrop.position.y += size.height //This fixes anchorpoint madness
      node.lcdRaindrop.zRotation = node.raindrop.zRotation
    }
  }
}
