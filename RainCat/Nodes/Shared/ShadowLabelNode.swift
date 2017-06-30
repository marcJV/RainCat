//
//  ShadowLabelNode.swift
//  RainCat
//
//  Created by Marc Vandehey on 9/19/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

public class ShadowLabelNode : SKNode {

  private var shadowTextNode : SKLabelNode!
  private var textNode : SKLabelNode!

  init(fontNamed: String) {
    super.init()

    setup(fontNamed: fontNamed)
  }

  func setup(fontNamed: String) {
    textNode = SKLabelNode(fontNamed: fontNamed)
    shadowTextNode = SKLabelNode(fontNamed: fontNamed)

    textNode.zPosition = 10
    shadowTextNode.zPosition = 0

    textNode.position = CGPoint()
    shadowTextNode.position = CGPoint(x: -1, y: -6)

    textNode.fontColor = SKColor.white
    shadowTextNode.fontColor = SKColor.black
    shadowTextNode.alpha = 0.2

    addChild(textNode)
    addChild(shadowTextNode)
  }

  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    setup(fontNamed: BASE_FONT_NAME)
    let labelText = userData?.value(forKey: "text") as? String
    let textSize = CGFloat(userData?.value(forKey: "textSize") as? Int ?? 100)
    textNode.text = labelText
    shadowTextNode.text = labelText

    textNode.fontSize = textSize
    shadowTextNode.fontSize = textSize
  }

  public override var zPosition: CGFloat {
    didSet {
      if textNode != nil {
        textNode.zPosition = zPosition
        shadowTextNode.zPosition = zPosition - 1
      }
    }
  }

  public var fontSize : CGFloat = 32 {
    didSet {
      textNode.fontSize = fontSize
      shadowTextNode.fontSize = fontSize

      if fontSize < 80 {
        shadowTextNode.position = CGPoint(x: -1, y: -3)
      } else {
        shadowTextNode.position = CGPoint(x: -1, y: -6)
      }
    }
  }

  public var text: String? {
    didSet {
      textNode.text = text
      shadowTextNode.text = text
    }
  }

  public var horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center {
    didSet {
      textNode.horizontalAlignmentMode = horizontalAlignmentMode
      shadowTextNode.horizontalAlignmentMode = horizontalAlignmentMode
    }
  }

  public func getLCDVersion() -> SKLabelNode {
    let newNode = SKLabelNode(fontNamed: textNode.fontName)
    newNode.text = textNode.text
    newNode.color = .black
    newNode.fontSize = textNode.fontSize
    newNode.horizontalAlignmentMode = textNode.horizontalAlignmentMode
    newNode.verticalAlignmentMode = textNode.verticalAlignmentMode
    newNode.position = position
    
    return newNode
  }
}
