//
//  PingPongBackgroundNode.swift
//  RainCat
//
//  Created by Marc Vandehey on 9/19/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

public class PingPongBackgroundNode : SKNode {
  public func setup(frame : CGRect, deadZone : CGFloat) {
    let leftGround = SKShapeNode(rect: CGRect(origin: CGPoint(), size: CGSize(width: 30, height: frame.height)))
    leftGround.fillColor = SKColor(red:1.00, green:1.00, blue:0.69, alpha:1.0)
    leftGround.strokeColor = SKColor.clear
    leftGround.zPosition = 0
    addChild(leftGround)

    let rightGround = SKShapeNode(rect: CGRect(origin: CGPoint(x: frame.width - 30, y: 0), size: CGSize(width: 30, height: frame.height)))
    rightGround.fillColor = SKColor(red:1.00, green:1.00, blue:0.69, alpha:1.0)
    rightGround.strokeColor = SKColor.clear
    rightGround.zPosition = 0
    addChild(rightGround)

    let leftLine = SKShapeNode(rect: CGRect(origin: CGPoint(), size: CGSize(width: 2.5, height: frame.height)))
    leftLine.fillColor = SKColor.white
    leftLine.position = CGPoint(x: frame.midX - deadZone - 65, y: 0)
    addChild(leftLine)

    let midLine = SKShapeNode(rect: CGRect(origin: CGPoint(), size: CGSize(width: 5, height: frame.height)))
    midLine.fillColor = SKColor.white
    midLine.position = CGPoint(x: frame.midX - 2.5, y: 0)
    addChild(midLine)

    let rightLine = SKShapeNode(rect: CGRect(origin: CGPoint(), size: CGSize(width: 2.5, height: frame.height)))
    rightLine.fillColor = SKColor.white
    rightLine.position = CGPoint(x: frame.midX + deadZone + 65, y: 0)
    addChild(rightLine)

    let circleShape = SKShapeNode(circleOfRadius: 75)
    circleShape.fillColor = SKColor(red:0.38, green:0.60, blue:0.65, alpha:1.0)
    circleShape.position = CGPoint(x: frame.midX, y: frame.midY)
    circleShape.lineWidth = 5
    addChild(circleShape)
  }
}
