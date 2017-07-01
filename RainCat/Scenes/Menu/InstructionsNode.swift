//
//  InstructionsNode.swift
//  RainCat
//
//  Created by Marc Vandehey on 6/30/17.
//  Copyright © 2017 Thirteen23. All rights reserved.
//

import SpriteKit

class InstructionsNode : SKNode {

  private var slides = [SKSpriteNode]()
  private var overlay : SKSpriteNode!
  private var currentIndex = 0
  private var playButton : TwoPaneButton!
  private var width : CGFloat = 0

  private var offScreenLeft : CGFloat = 0
  private var offScreenRight : CGFloat = 0

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    setup()
  }

  func setup() {
    let background = childNode(withName: "background") as! SKSpriteNode

    let roundedRect = UIBezierPath(roundedRect: background.frame, cornerRadius: 30)

    let maskShape = SKShapeNode(path: roundedRect.cgPath)
    maskShape.fillColor = SKColor.black
    maskShape.zPosition = 200
    maskShape.lineWidth = 0

    let borderShape = SKShapeNode(path: roundedRect.cgPath)
    borderShape.strokeColor = SKColor(red:0.99, green:0.92, blue:0.55, alpha:1.0)
    borderShape.fillColor = SKColor.clear
    borderShape.zPosition = 200
    borderShape.lineWidth = 10

    addChild(borderShape)

    let mask = SKCropNode()
    mask.maskNode = maskShape

    addChild(mask)

    background.removeFromParent()
    mask.addChild(background)

    width = getDisplaySize().width
    offScreenLeft = width / 2 - background.frame.width
    offScreenRight = width / 2 + background.frame.width

    var index = 0

    while childNode(withName: "slide-\(index)") != nil {
      let slide = childNode(withName: "slide-\(index)") as! SKSpriteNode
      slide.position.x = offScreenRight
      slide.alpha = 0

      slide.removeFromParent()
      mask.addChild(slide)

      slides.append(slide)

      index += 1
    }

    overlay = childNode(withName: "overlay") as! SKSpriteNode
    overlay.alpha = 0
    overlay.position.x = offScreenRight

    overlay.removeFromParent()
    mask.addChild(overlay)

    playButton = overlay.childNode(withName: "button-play") as! TwoPaneButton
    playButton.addTarget(self, selector: #selector(playButtonClicked), forControlEvents: .TouchUpInside)
  }

  func playButtonClicked() {
    if let parent = parent as? DirectionsSceneNode {
      parent.navigateToScene()
    }
  }

  func showNode() {
    slides[0].run(SKAction.sequence([
      SKAction.wait(forDuration: 0.6),
      SKAction.group([SKAction.fadeIn(withDuration: 0.6),
                      SKActionHelper.moveToEaseInOut(x: width / 2, duration: 0.8)])
      ]))
  }

  func hideNode() {
    for slide in slides {
      slide.run(
        SKAction.group([
          SKAction.fadeOut(withDuration: 0.15),
          SKAction.moveTo(x: offScreenRight, duration: 1)
          ]))
    }

    currentIndex = 0

    overlay.run(
      SKAction.group([
        SKAction.fadeOut(withDuration: 0.15),
        SKAction.moveTo(x: offScreenRight, duration: 1)
        ]))
  }

  func hasNext() -> Bool {
    return currentIndex + 1 < (slides.count + 1)
  }

  func hasPrevious() -> Bool {
    return currentIndex > 0
  }

  func slideForwards() {
    if hasNext() {
      let currentSlide = currentIndex < slides.count ? slides[currentIndex] : overlay

      currentSlide!.run(
        SKAction.group([SKActionHelper.moveToEaseInOut(x: offScreenLeft, duration: 0.8),
                        SKAction.fadeOut(withDuration: 0.6)])
        )

      currentIndex += 1

      let nextSlide = currentIndex < slides.count ? slides[currentIndex] : overlay
      nextSlide!.run(
        SKAction.group([SKActionHelper.moveToEaseInOut(x: width / 2, duration: 0.8),
                        SKAction.fadeIn(withDuration: 0.6)])
      )
    }
  }

  func slideBackwards() {
    if hasPrevious() {
      let currentSlide = currentIndex < slides.count ? slides[currentIndex] : overlay
      currentSlide!.run(
        SKAction.group([SKActionHelper.moveToEaseInOut(x: offScreenRight, duration: 0.8),
                        SKAction.fadeOut(withDuration: 0.6)])
      )

      currentIndex -= 1

      let nextSlide = currentIndex < slides.count ? slides[currentIndex] : overlay
      nextSlide!.run(
        SKAction.group([SKActionHelper.moveToEaseInOut(x: width / 2, duration: 0.8),
                        SKAction.fadeIn(withDuration: 0.6)])
      )
    }
  }
}
