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
  private var backgroundPane : SKSpriteNode!
  private var label : SKLabelNode!
  private var zeroPosition = CGPoint()
  private var buttonElevation : CGFloat = 10

  override init(texture: SKTexture?, color: UIColor, size: CGSize) {
    super.init(texture: texture, color: color, size: size)
  }

  convenience init(color: SKColor, size : CGSize) {
    self.init(texture: nil, color: color, size: size)
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    color = .clear

    if let text = userData?.value(forKey: "text") as? String, let fontSize = userData?.value(forKey: "textSize") as? Int {
      setup(text: text, fontSize: CGFloat(fontSize))
    }
  }

  var elevation : CGFloat {
    set {
      buttonElevation = newValue
      updateElevation(newElevation: buttonElevation)
    }
    get {
      return buttonElevation
    }
  }

  func updateElevation(newElevation : CGFloat) {
    zeroPosition = CGPoint(x: -elevation, y: -elevation)
    backgroundPane.position = zeroPosition

    var buttonSize = size
    buttonSize.height -= elevation
    buttonSize.width -= elevation

    backgroundPane.size = buttonSize
    foregroundPane.size = buttonSize

    if anchorPoint == CGPoint(x: 0, y: 1) {
      label.position = CGPoint(x: buttonSize.width / 2, y: -buttonSize.height / 2)
    }
  }

  func setup(text: String, fontSize: CGFloat) {
    zeroPosition = CGPoint.zero

    anchorPoint = CGPoint(x: 0, y: 1)

    self.color = SKColor.clear

    backgroundPane = SKSpriteNode(color: SKColor(red:0.79, green:0.76, blue:0.37, alpha:1.0), size: size)
    backgroundPane.position = zeroPosition

    foregroundPane = SKSpriteNode(color: SKColor(red:0.99, green:0.92, blue:0.55, alpha:1.0), size: size)
    foregroundPane.anchorPoint = anchorPoint
    backgroundPane.anchorPoint = anchorPoint

    label = SKLabelNode(fontNamed: BASE_FONT_NAME)
    label.text = text
    label.fontSize = fontSize
    label.fontColor = SKColor(red:0.29, green:0.29, blue:0.29, alpha:1.0)
    label.horizontalAlignmentMode = .center
    label.verticalAlignmentMode = .center

    addChild(backgroundPane)
    addChild(foregroundPane)
    foregroundPane.addChild(label)

    if let sksElevation = userData?.value(forKey: "elevation") as? Int {
      elevation = CGFloat(sksElevation)
      updateElevation(newElevation: CGFloat(sksElevation))
    } else {
      elevation = 10
    }
  }

  override func updateControl() {
    if controlState.contains(.Highlighted) {
      foregroundPane.run(SKAction.move(to: zeroPosition, duration: 0.05))
    } else if controlState.contains(.Normal) {
      foregroundPane.run(SKAction.move(to: CGPoint.zero, duration: 0.05))
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

