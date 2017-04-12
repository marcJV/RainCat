//
//  PingPongBackgroundNode.swift
//  RainCat
//
//  Created by Marc Vandehey on 9/19/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

public class PingPongBackgroundNode : SKNode {
  public func setup(frame : CGRect, deadZone : CGFloat, playerOnePalette : ColorPalette, playerTwoPalette : ColorPalette) {
    let leftGround = SKShapeNode(rect: CGRect(origin: CGPoint(), size: CGSize(width: 30, height: frame.height)))
    leftGround.fillColor = playerOnePalette.groundColor
    leftGround.strokeColor = SKColor.clear
    leftGround.zPosition = 1
    addChild(leftGround)

    let rightGround = SKShapeNode(rect: CGRect(origin: CGPoint(x: frame.width - 30, y: 0), size: CGSize(width: 30, height: frame.height)))
    rightGround.fillColor = playerTwoPalette.groundColor
    rightGround.strokeColor = SKColor.clear
    rightGround.zPosition = 1
    addChild(rightGround)

    let leftLine = SKShapeNode(rect: CGRect(origin: CGPoint(), size: CGSize(width: 2.5, height: frame.height)))
    leftLine.fillColor = SKColor.white
    leftLine.position = CGPoint(x: frame.midX - deadZone - 65, y: 0)
    leftLine.zPosition = 1
    addChild(leftLine)

    let midLine = SKShapeNode(rect: CGRect(origin: CGPoint(), size: CGSize(width: 5, height: frame.height)))
    midLine.fillColor = SKColor.white
    midLine.position = CGPoint(x: frame.midX - 2.5, y: 0)
    midLine.zPosition = 1
    addChild(midLine)

    let rightLine = SKShapeNode(rect: CGRect(origin: CGPoint(), size: CGSize(width: 2.5, height: frame.height)))
    rightLine.fillColor = SKColor.white
    rightLine.position = CGPoint(x: frame.midX + deadZone + 65, y: 0)
    rightLine.zPosition = 1
    addChild(rightLine)

    let circleShape = SKShapeNode(circleOfRadius: 75)
    circleShape.fillColor = SKColor(red:0.38, green:0.60, blue:0.65, alpha:1.0)
    circleShape.position = CGPoint(x: frame.midX, y: frame.midY)
    circleShape.lineWidth = 5
    circleShape.zPosition = 1
    addChild(circleShape)
  }
}
