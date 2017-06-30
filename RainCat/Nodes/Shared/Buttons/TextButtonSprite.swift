//
//  TestAlphaButton.swift
//  RainCat
//
//  Created by Marc Vandehey on 5/3/17.
//  Copyright © 2017 Thirteen23. All rights reserved.
//

import SpriteKit

class TextButtonSprite : SKAControlSprite {
  var label : SKLabelNode!

  init() {
    super.init(texture: nil, color: .clear, size: .zero)

    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    setup()
  }

  private func setup() {
    color = .clear

    label = SKLabelNode(fontNamed: BASE_FONT_NAME)

    label.zPosition = zPosition
  }

  func set(text: String, fontSize: CGFloat, autoResize: Bool, fontColor : SKColor = .white) {
    color = .clear
    
    label.horizontalAlignmentMode = .center
    label.verticalAlignmentMode = .center

    label.fontSize = fontSize
    label.fontColor = fontColor
    label.text = text

    if autoResize {
      size = CGSize(width: label.frame.width * 1.5, height: label.frame.height * 2.5)
    }

    addChild(label)
  }

  override func updateControl() {
    var action : SKAction
    if controlState.contains(.Disabled) {
      action = SKAction.scale(to: 0.25, duration: 0.15)
    } else if controlState.contains(.Highlighted) {
      action = SKAction.scale(to: 1.1, duration: 0.15)
    } else {
      action = SKAction.scale(to: 1, duration: 0.15)
    }

    label.run(action)
  }
}
