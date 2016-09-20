//
//  RainDropBanner.swift
//  RainCat
//
//  Created by Marc Vandehey on 9/20/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

public class RainDropBanner : SKNode, Touchable {
  let rainTexture = SKTexture(imageNamed: "rain_drop")
  let mediumTexture = SKTexture(imageNamed: "medium_rain_drop")
  let largeTexture = SKTexture(imageNamed: "large_rain_drop")

  var rainDrops = [SKSpriteNode]()

  public func setup(size : CGSize) {
    let margin : CGFloat = 40
    let lowerLimit : CGFloat = 0
    let upperLimit : CGFloat = size.height
    let centerLine : CGFloat = (upperLimit + lowerLimit) / 2.0


    let rainDrop = SKSpriteNode(texture: rainTexture)
    rainDrop.position = CGPoint(x: size.width / 2, y: centerLine)

    rainDrop.zPosition = 10

    addChild(rainDrop)
    rainDrops.append(rainDrop)

    //Generate left side
    var xPosition = rainDrop.position.x
    var index = 0
    let innerMargin = 10 * UIScreen.main.nativeScale
    let offsetAmount = rainDrop.size.width / 2 + innerMargin

    xPosition -= offsetAmount

    while xPosition > margin {
      let rainDrop = SKSpriteNode(texture: rainTexture)
      var yPosition = centerLine

      if index % 6 == 0 {
        yPosition = centerLine - rainDrop.size.height
      } else if index % 3 == 0 {
        yPosition = centerLine - innerMargin
      } else if index % 2 == 0 {
        yPosition = centerLine + rainDrop.size.height
      }

      rainDrop.position = CGPoint(x: xPosition, y: yPosition)
      rainDrop.zPosition = 10

      addChild(rainDrop)
      rainDrops.append(rainDrop)

      xPosition -= offsetAmount
      index += 1
    }

    //Generate right side
    index = 8 //Hack to have the pattern line up correctly
    xPosition = rainDrop.position.x + offsetAmount
    while xPosition < size.width - margin {
      var yPosition = centerLine

      if index % 6 == 0 {
        yPosition = centerLine - rainDrop.size.height
      } else if index % 3 == 0 {
        yPosition = centerLine - innerMargin
      } else if index % 2 == 0 {
        yPosition = centerLine + rainDrop.size.height
      }

      let rainDrop = SKSpriteNode(texture: rainTexture)
      rainDrop.position = CGPoint(x: xPosition, y: yPosition)
      rainDrop.zPosition = 10

      addChild(rainDrop)
      rainDrops.append(rainDrop)
      
      xPosition += offsetAmount
      index += 1
    }
  }

  public func makeItRain() {
    for rainDrop in rainDrops {
      rainDrop.physicsBody = SKPhysicsBody(circleOfRadius: 10 * rainDrop.xScale)
      rainDrop.physicsBody?.categoryBitMask = RainDropCategory

      //Makes all of the raindrops fall at different rates
      rainDrop.physicsBody?.linearDamping = CGFloat(arc4random()).truncatingRemainder(dividingBy: 100) / 100
      rainDrop.physicsBody?.mass = CGFloat(arc4random()).truncatingRemainder(dividingBy: 100) / 100
    }
  }

  public func touchBeganAtPoint(touch: UITouch) {
    for rainDrop in rainDrops {
      if rainDrop.contains(touch.location(in: self)) {

        if rainDrop.texture == rainTexture {
          rainDrop.texture = mediumTexture
          rainDrop.setScale(2)
        } else if rainDrop.texture == mediumTexture {
          rainDrop.texture = largeTexture
          rainDrop.setScale(3)
        }
      }
    }
  }

  public func touchMovedToPoint(touch: UITouch) {
    //Not implemented
  }

  public func touchEndedAtPoint(touch: UITouch) {
    //Not implemented
  }

  public func touchCancelledAtPoint(touch: UITouch) {
    //Not implemented
  }
}
