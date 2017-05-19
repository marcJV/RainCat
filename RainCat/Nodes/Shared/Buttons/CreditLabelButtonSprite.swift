//
//  CreditLabelButtonSprite.swift
//  RainCat
//
//  Created by Marc Vandehey on 5/4/17.
//  Copyright © 2017 Thirteen23. All rights reserved.
//

import SpriteKit

class CreditLabelButtonSprite : SKAControlSprite {
  var label : SKLabelNode!

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  private func setup() {
    label = SKLabelNode(fontNamed: BASE_FONT_NAME)

    label.fontColor = SKColor(red:0.99, green:0.92, blue:0.55, alpha:1.0)
    label.zPosition = zPosition
    label.horizontalAlignmentMode = .left
    label.verticalAlignmentMode = .bottom

    label.text = userData?.value(forKey: "label") as? String

    addChild(label)
  }

  func getUrl() -> String? {
    return userData?.value(forKey: "url") as? String
  }

  override func updateControl() {
    var action : SKAction
    if controlState.contains(.Disabled) {
      action = SKAction.fadeAlpha(to: 0.25, duration: 0.1)
    } else if controlState.contains(.Highlighted) {
      action = SKAction.fadeAlpha(to: 0.65, duration: 0.1)
    } else {
      action = SKAction.fadeAlpha(to: 1, duration: 0.1)
    }

    label.run(action)
  }
}
