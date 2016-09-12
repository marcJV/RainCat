//
//  UmbrellaSprite.swift
//  RainCat
//
//  Created by Marc Vandehey on 8/30/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import Foundation
import SpriteKit

public class UmbrellaSprite : SKSpriteNode, Palettable {
  private var umbrellaTop : SKSpriteNode!
  private var umbrellaBottom : SKSpriteNode!

  private var destination : CGPoint!
  private let easing : CGFloat = 0.1


  public static func newInstance(palette : ColorPalette) -> UmbrellaSprite {
    let umbrella = UmbrellaSprite()

    let top = SKSpriteNode(imageNamed: "umbrellaTop")
    let bottom = SKSpriteNode(imageNamed: "umbrellaBottom")

    top.physicsBody = SKPhysicsBody(texture: top.texture!, size: top.size)
    top.physicsBody?.isDynamic = false
    top.physicsBody?.categoryBitMask = UmbrellaCategory
    top.physicsBody?.contactTestBitMask = RainDropCategory
    top.physicsBody?.restitution = 0.9

    //TODO determine if we want the physics body to extend a bit or not
//    let path = UIBezierPath()
//    path.move(to: CGPoint())
//    path.addLine(to: CGPoint(x: -umbrella.size.width / 2 - 30, y: 0))
//    path.addLine(to: CGPoint(x: 0, y: umbrella.size.height / 2))
//    path.addLine(to: CGPoint(x: umbrella.size.width / 2 + 30, y: 0))

    top.zPosition = 3
    bottom.zPosition = 2

    top.colorBlendFactor = 1
    bottom.colorBlendFactor = 1

    top.color = palette.umbrellaTopColor
    bottom.color = palette.umbrellaBottomColor

    top.position.y = (top.size.height + bottom.size.height) / 2

    bottom.position.x -= bottom.size.width / 4

    umbrella.addChild(top)
    umbrella.addChild(bottom)

    umbrella.umbrellaTop = top
    umbrella.umbrellaBottom = bottom

    return umbrella
  }

  public func updatePosition(point : CGPoint) {
    position = point
    destination = point
  }

  public func setDestination(destination : CGPoint) {
    self.destination = destination
  }

  public func update(deltaTime : TimeInterval) {
    let distance = sqrt(pow((destination.x - position.x), 2) + pow((destination.y - position.y), 2))

    if(distance > 1) {
      let directionX = (destination.x - position.x)
      let directionY = (destination.y - position.y)

      position.x += directionX * easing
      position.y += directionY * easing
    } else {
      position = destination;
    }
  }

  public func updatePalette(palette: ColorPalette) {
    umbrellaTop.run(ColorAction().colorTransitionAction(fromColor: umbrellaTop.color, toColor: palette.umbrellaTopColor, duration: colorChangeDuration))
    umbrellaBottom.run(ColorAction().colorTransitionAction(fromColor: umbrellaBottom.color, toColor: palette.umbrellaBottomColor, duration: colorChangeDuration))

  }
}
