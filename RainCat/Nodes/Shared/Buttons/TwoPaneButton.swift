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

  convenience init(text: String, textSize: CGFloat, size : CGSize) {
    self.init(texture: nil, color: .clear, size: size)

    setup(text: text, fontSize: textSize)
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

    if backgroundPane == nil {
      backgroundPane = SKSpriteNode(color: SKColor(red:0.79, green:0.76, blue:0.37, alpha:1.0), size: size)
      backgroundPane.position = zeroPosition
      backgroundPane.anchorPoint = anchorPoint

      addChild(backgroundPane)
    }

    if foregroundPane == nil {
      foregroundPane = SKSpriteNode(color: SKColor(red:0.99, green:0.92, blue:0.55, alpha:1.0), size: size)
      foregroundPane.anchorPoint = anchorPoint

      addChild(foregroundPane)
    }

    if label == nil {
      label = SKLabelNode(fontNamed: BASE_FONT_NAME)
      label.fontSize = fontSize
      label.fontColor = SKColor(red:0.29, green:0.29, blue:0.29, alpha:1.0)
      label.horizontalAlignmentMode = .center
      label.verticalAlignmentMode = .center

      foregroundPane.addChild(label)
    }

    label.text = text

    if let sksElevation = userData?.value(forKey: "elevation") as? Int {
      elevation = CGFloat(sksElevation)
      updateElevation(newElevation: CGFloat(sksElevation))
    } else {
      elevation = 10
    }

    addTarget(self, selector: #selector(clickSound), forControlEvents: .TouchUpInside)
  }

  func clickSound() {
    SoundManager.playButtonClick(node: self)
  }

  let moveKey = "moving_the_button_yay!"

  func moveTo(y: CGFloat, duration: TimeInterval = 0.5, delay: TimeInterval = 0.0) {
    runMoveAction(horizontally: true,
                  positiveMovement:  y > position.y,
                  point: CGPoint(x: position.x, y: y),
                  duration : duration,
                  delay: delay)
  }

  func moveTo(x: CGFloat, duration : TimeInterval = 0.5, delay: TimeInterval = 0.0) {
    runMoveAction(horizontally: false,
                  positiveMovement: x > position.x,
                  point: CGPoint(x: x, y: position.y),
                  duration : duration,
                  delay: delay)
  }

  private func runMoveAction(horizontally : Bool, positiveMovement : Bool, point : CGPoint, duration : TimeInterval, delay : TimeInterval) {
      removeAction(forKey: moveKey)
    
      let end = duration * 0.1

      var startAmount : CGFloat = 0
      var overshootAmount : CGFloat = 0
      var settleAmount : CGFloat = 0

      if positiveMovement {
        print("moving up")

        startAmount = -elevation
        overshootAmount = elevation * 1.5
        settleAmount = -elevation * 0.5
      } else {
        print("moving down")

        startAmount = elevation * 1.5
        overshootAmount = -elevation * 2
        settleAmount = elevation * 0.5
      }

      var startAction : SKAction
      var waitAction : SKAction
      var overshootAction : SKAction
      var settleAction : SKAction
      let delayAction = SKAction.wait(forDuration: delay)
      let moveAction = SKAction.move(to: point, duration: duration)

      if horizontally {
        startAction = SKAction.moveBy(x: 0, y: startAmount, duration: end)
        overshootAction = SKAction.moveBy(x: 0, y: overshootAmount, duration: end * 2)
        settleAction = SKAction.moveBy(x: 0, y: settleAmount, duration: end * 2)
      } else {
        startAction = SKAction.moveBy(x: startAmount, y: 0, duration: end)
        overshootAction = SKAction.moveBy(x: overshootAmount, y: 0, duration: end * 2)
        settleAction = SKAction.moveBy(x: settleAmount, y: 0, duration: end * 2)
      }

      waitAction = SKAction.wait(forDuration: duration - end * 2)

      startAction.timingMode = .easeIn
      overshootAction.timingMode = .easeOut
      settleAction.timingMode = .easeInEaseOut
      moveAction.timingMode = .easeInEaseOut

      backgroundPane.run(SKAction.sequence([
        delayAction, startAction, waitAction, overshootAction, settleAction
        ]))

      run(SKAction.sequence([delayAction, moveAction]), withKey: moveKey)
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

