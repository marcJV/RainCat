//
//  BackgroundNode.swift
//  RainCat
//
//  Created by Marc Vandehey on 9/10/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

public class BackgroundNode : SKShapeNode, Palettable {

  public static func newInstance(size : CGSize, palette : ColorPalette) -> BackgroundNode {
    let backgroundNode = BackgroundNode(rect: CGRect(origin: CGPoint(), size: size))
    backgroundNode.zPosition = 0
    backgroundNode.fillColor = palette.skyColor
    backgroundNode.strokeColor = SKColor.clear

    return backgroundNode
  }

  public func updatePalette(palette: ColorPalette) {
    run(ColorAction().colorTransitionAction(fromColor: fillColor, toColor: palette.skyColor, duration: colorChangeDuration))
  }
}
