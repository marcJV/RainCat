//
//  LCDNumberNode.swift
//  RainCat
//
//  Created by Marc Vandehey on 3/29/17.
//  Copyright © 2017 Thirteen23. All rights reserved.
//

import SpriteKit

class LCDNumberNode : SKSpriteNode, LCDSetupable {

  private var topHorizontalBar : SKSpriteNode!
  private var middleHorizontalBar : SKSpriteNode!
  private var bottomHorizontalBar : SKSpriteNode!

  private var topLeftVerticalBar : SKSpriteNode!
  private var topRightVerticalBar : SKSpriteNode!
  private var bottomLeftVerticalBar : SKSpriteNode!
  private var bottomRightVerticalBar : SKSpriteNode!

  func setup() {
    //Clear the editor color
    color = SKColor.clear

    let horizontalBar = SKTexture(imageNamed: "lcd-horizontal-section")
    let verticalBar = SKTexture(imageNamed: "lcd-vertical-section")

    topHorizontalBar = SKSpriteNode(texture: horizontalBar)
    middleHorizontalBar = SKSpriteNode(texture: horizontalBar)
    bottomHorizontalBar = SKSpriteNode(texture: horizontalBar)

    topLeftVerticalBar = SKSpriteNode(texture: verticalBar)
    topRightVerticalBar = SKSpriteNode(texture: verticalBar)
    bottomLeftVerticalBar = SKSpriteNode(texture: verticalBar)
    bottomRightVerticalBar = SKSpriteNode(texture: verticalBar)

    let horizontalBarHeight = topHorizontalBar.size.height
    let verticalBarHeight = topLeftVerticalBar.size.height
    let horizontalBarWidth = topHorizontalBar.size.width

    let originX = size.width / 2

    topHorizontalBar.position = CGPoint(x: originX, y: -horizontalBarHeight * 0.5)

    topLeftVerticalBar.position = CGPoint(x: originX - horizontalBarWidth * 0.5,
                                          y: -horizontalBarHeight * 0.75 - verticalBarHeight * 0.5)
    topRightVerticalBar.position = CGPoint(x: originX + horizontalBarWidth * 0.5,
                                           y:topLeftVerticalBar.position.y)
    middleHorizontalBar.position = CGPoint(x: originX,
                                           y: -horizontalBarHeight * 0.75 - verticalBarHeight)
    bottomLeftVerticalBar.position = CGPoint(x: originX - horizontalBarWidth * 0.5,
                                             y: middleHorizontalBar.position.y - horizontalBarHeight * 1.5 - horizontalBarHeight * 0.5)
    bottomRightVerticalBar.position = CGPoint(x: originX + horizontalBarWidth * 0.5,
                                              y:bottomLeftVerticalBar.position.y)
    bottomHorizontalBar.position = CGPoint(x: originX,
                                           y: bottomRightVerticalBar.position.y - verticalBarHeight * 0.5)

    addChild(topHorizontalBar)
    addChild(middleHorizontalBar)
    addChild(bottomHorizontalBar)

    addChild(topLeftVerticalBar)
    addChild(topRightVerticalBar)
    addChild(bottomLeftVerticalBar)
    addChild(bottomRightVerticalBar)
  }

  func updateDisplay(number : Int) {
    switch number {
    case 0:
      topHorizontalBar.alpha = lcdOnAlpha
      middleHorizontalBar.alpha = lcdOffAlpha
      bottomHorizontalBar.alpha = lcdOnAlpha

      topLeftVerticalBar.alpha = lcdOnAlpha
      topRightVerticalBar.alpha = lcdOnAlpha
      bottomLeftVerticalBar.alpha = lcdOnAlpha
      bottomRightVerticalBar.alpha = lcdOnAlpha
    case 1:
      topHorizontalBar.alpha = lcdOffAlpha
      middleHorizontalBar.alpha = lcdOffAlpha
      bottomHorizontalBar.alpha = lcdOffAlpha

      topLeftVerticalBar.alpha = lcdOffAlpha
      topRightVerticalBar.alpha = lcdOnAlpha
      bottomLeftVerticalBar.alpha = lcdOffAlpha
      bottomRightVerticalBar.alpha = lcdOnAlpha
    case 2:
      topHorizontalBar.alpha = lcdOnAlpha
      middleHorizontalBar.alpha = lcdOnAlpha
      bottomHorizontalBar.alpha = lcdOnAlpha

      topLeftVerticalBar.alpha = lcdOffAlpha
      topRightVerticalBar.alpha = lcdOnAlpha
      bottomLeftVerticalBar.alpha = lcdOnAlpha
      bottomRightVerticalBar.alpha = lcdOffAlpha
    case 3:
      topHorizontalBar.alpha = lcdOnAlpha
      middleHorizontalBar.alpha = lcdOnAlpha
      bottomHorizontalBar.alpha = lcdOnAlpha

      topLeftVerticalBar.alpha = lcdOffAlpha
      topRightVerticalBar.alpha = lcdOnAlpha
      bottomLeftVerticalBar.alpha = lcdOffAlpha
      bottomRightVerticalBar.alpha = lcdOnAlpha
    case 4:
      topHorizontalBar.alpha = lcdOffAlpha
      middleHorizontalBar.alpha = lcdOnAlpha
      bottomHorizontalBar.alpha = lcdOffAlpha

      topLeftVerticalBar.alpha = lcdOnAlpha
      topRightVerticalBar.alpha = lcdOnAlpha
      bottomLeftVerticalBar.alpha = lcdOffAlpha
      bottomRightVerticalBar.alpha = lcdOnAlpha
    case 5:
      topHorizontalBar.alpha = lcdOnAlpha
      middleHorizontalBar.alpha = lcdOnAlpha
      bottomHorizontalBar.alpha = lcdOnAlpha

      topLeftVerticalBar.alpha = lcdOnAlpha
      topRightVerticalBar.alpha = lcdOffAlpha
      bottomLeftVerticalBar.alpha = lcdOffAlpha
      bottomRightVerticalBar.alpha = lcdOnAlpha
    case 6:
      topHorizontalBar.alpha = lcdOnAlpha
      middleHorizontalBar.alpha = lcdOnAlpha
      bottomHorizontalBar.alpha = lcdOnAlpha

      topLeftVerticalBar.alpha = lcdOnAlpha
      topRightVerticalBar.alpha = lcdOffAlpha
      bottomLeftVerticalBar.alpha = lcdOnAlpha
      bottomRightVerticalBar.alpha = lcdOnAlpha
    case 7:
      topHorizontalBar.alpha = lcdOnAlpha
      middleHorizontalBar.alpha = lcdOffAlpha
      bottomHorizontalBar.alpha = lcdOffAlpha

      topLeftVerticalBar.alpha = lcdOffAlpha
      topRightVerticalBar.alpha = lcdOnAlpha
      bottomLeftVerticalBar.alpha = lcdOffAlpha
      bottomRightVerticalBar.alpha = lcdOnAlpha
    case 9:
      topHorizontalBar.alpha = lcdOnAlpha
      middleHorizontalBar.alpha = lcdOnAlpha
      bottomHorizontalBar.alpha = lcdOnAlpha

      topLeftVerticalBar.alpha = lcdOnAlpha
      topRightVerticalBar.alpha = lcdOnAlpha
      bottomLeftVerticalBar.alpha = lcdOffAlpha
      bottomRightVerticalBar.alpha = lcdOnAlpha
    default:
      topHorizontalBar.alpha = lcdOnAlpha
      middleHorizontalBar.alpha = lcdOnAlpha
      bottomHorizontalBar.alpha = lcdOnAlpha

      topLeftVerticalBar.alpha = lcdOnAlpha
      topRightVerticalBar.alpha = lcdOnAlpha
      bottomLeftVerticalBar.alpha = lcdOnAlpha
      bottomRightVerticalBar.alpha = lcdOnAlpha
    }
  }
}
