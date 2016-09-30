//
//  FadeableButton.swift
//  RainCat
//
//  Created by Marc Vandehey on 9/29/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

public class AlphaButton : SKNode, Touchable {

  public var baseNode : SKNode
  private var margin : CGFloat
  private var baseNodeSize : CGSize
  private var modifiedFrame : CGRect

  private(set) var size : CGSize

  private(set) var isHovering = false

  public var buttonClickAction : (() -> ())?

  public init(baseNode : SKNode, size : CGSize, margin : CGFloat) {
    self.baseNode = baseNode
    self.margin = margin
    self.baseNodeSize = size
    self.modifiedFrame = CGRect(origin: CGPoint(x: -margin, y: -margin),
                                size: CGSize(width: size.width + margin * 2, height: size.height + margin * 2))

    self.size = CGSize(width: baseNodeSize.width + margin, height: baseNodeSize.height + margin)

    super.init()

    baseNode.position = CGPoint(x: modifiedFrame.midX, y: modifiedFrame.midY)
    addChild(baseNode)
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // Touchable protocol

  public func touchBegan(touch: UITouch) {
    let nodeLocation = touch.location(in: self)

    if modifiedFrame.contains(nodeLocation) {
      setHovering(isHovering: true)
    }
  }

  public func touchMoved(touch: UITouch) {
    let nodeLocation = touch.location(in: self)

    setHovering(isHovering: modifiedFrame.contains(nodeLocation))
  }

  public func touchEnded(touch: UITouch) {
    setHovering(isHovering: false)

    if modifiedFrame.contains(touch.location(in: self)) && buttonClickAction != nil {
      buttonClickAction!()
    }
  }

  public func touchCancelled(touch: UITouch) {
    setHovering(isHovering: false)
  }

  private func setHovering(isHovering : Bool) {
    self.isHovering = isHovering

    if isHovering {
      baseNode.alpha = 0.5
    } else {
      baseNode.alpha = 1.0
    }
  }
}
