//
//  FadeableButton.swift
//  RainCat
//
//  Created by Marc Vandehey on 9/29/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

class AlphaButton : SKAControlSprite {

  public var baseNode : SKNode
  private var margin : CGFloat
  private var baseNodeSize : CGSize
  private var modifiedFrame : CGRect

  private(set) var isHovering = false

  public var buttonClickAction : (() -> ())?

  public init(baseNode : SKNode, size : CGSize, margin : CGFloat) {
    self.baseNode = baseNode
    self.margin = margin
    self.baseNodeSize = size
    self.modifiedFrame = CGRect(origin: CGPoint(x: -margin, y: -margin),
                                size: CGSize(width: size.width + margin * 2, height: size.height + margin * 2))

    super.init(texture: nil, color: SKColor.clear,
               size: CGSize(width: baseNodeSize.width + margin, height: baseNodeSize.height + margin))

    baseNode.position = CGPoint(x: modifiedFrame.midX, y: modifiedFrame.midY)


    addTarget(self, selector: #selector(runClickAction(_:)), forControlEvents: .TouchUpInside)

    addChild(baseNode)
  }

  override func updateControl() {
    if controlState.contains(.Highlighted) {
      baseNode.run(SKAction.fadeAlpha(to: 0.5, duration: 0.15))
    } else if controlState.contains(.Normal) {
      baseNode.run(SKAction.fadeAlpha(to: 1.0, duration: 0.15))
    }
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func runClickAction(_ sender: AnyObject) {
    if let clickAction = buttonClickAction {
      clickAction()
    }
  }
}
