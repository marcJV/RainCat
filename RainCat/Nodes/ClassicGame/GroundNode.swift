//
//  GroundNode.swift
//  RainCat
//
//  Created by Marc Vandehey on 9/12/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

public class GroundNode : SKShapeNode, Palettable {

  public static func newInstance(size : CGSize, palette : ColorPalette) -> GroundNode {
    var updatedSize = size
    updatedSize.height *= 0.35

    let groundNode = GroundNode(rect: CGRect(origin: CGPoint(), size: updatedSize))
    groundNode.zPosition = 1
    groundNode.fillColor = palette.groundColor
    groundNode.strokeColor = SKColor.clear

    let groundLocation = updatedSize.height * 0.35
    groundNode.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: 5, y: groundLocation), to: CGPoint(x: size.width - 5, y: groundLocation))
    groundNode.physicsBody?.categoryBitMask = FloorCategory
    groundNode.physicsBody?.contactTestBitMask = RainDropCategory | CatCategory
    groundNode.physicsBody?.restitution = 0.3

    return groundNode
  }

  public func updatePalette(palette: ColorPalette) {
    run(ColorAction().colorTransitionAction(fromColor: fillColor, toColor: palette.groundColor, duration: colorChangeDuration))
  }
}
