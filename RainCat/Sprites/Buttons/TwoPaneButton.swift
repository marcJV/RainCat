//
//  TwoPaneButton.swift
//  RainCat
//
//  Created by Marc Vandehey on 11/2/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

class TwoPaneButton : SKAControlSprite {
  private var foregroundPane : SKSpriteNode!
  private var label : SKLabelNode!
  private var zeroPosition = CGPoint()

  var elevation = 10 {
    didSet {
      zeroPosition = CGPoint(x: elevation, y: elevation)
      foregroundPane.position = zeroPosition
    }
  }

  func setup(text: String, fontSize: CGFloat) {
    zeroPosition = CGPoint(x: 10, y: 10)

    anchorPoint = CGPoint(x: 0, y: 1)

    self.color = SKColor(red:0.79, green:0.76, blue:0.37, alpha:1.0)

    foregroundPane = SKSpriteNode(color: SKColor(red:0.99, green:0.92, blue:0.55, alpha:1.0), size: size)
    foregroundPane.position = zeroPosition
    foregroundPane.anchorPoint = anchorPoint

    label = SKLabelNode(fontNamed: BASE_FONT_NAME)
    label.text = text
    label.fontSize = fontSize
    label.fontColor = SKColor(red:0.29, green:0.29, blue:0.29, alpha:1.0)
    label.horizontalAlignmentMode = .center
    label.verticalAlignmentMode = .center

    if anchorPoint == CGPoint(x: 0, y: 1) {
      label.position = CGPoint(x: size.width / 2, y: -size.height / 2)
    }

    addChild(foregroundPane)
    foregroundPane.addChild(label)
  }

  override func updateControl() {
    if controlState.contains(.Highlighted) {
      foregroundPane.run(SKAction.move(to: CGPoint(), duration: 0.05))
    } else if controlState.contains(.Normal) {
      foregroundPane.run(SKAction.move(to: zeroPosition, duration: 0.05))
    }
  }

  override var zPosition: CGFloat {
    didSet {
      if foregroundPane != nil {
        foregroundPane.zPosition = zPosition + 1
        label.zPosition = zPosition + 2
      }
    }
  }
}

