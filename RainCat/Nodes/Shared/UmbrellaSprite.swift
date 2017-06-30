//
//  UmbrellaSprite.swift
//  RainCat
//
//  Created by Marc Vandehey on 8/30/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import Foundation
import SpriteKit

class UmbrellaSprite : SKSpriteNode, Palettable {
  private var umbrellaTop : SKSpriteNode!
  private var umbrellaBottom : SKSpriteNode!

  private var destination : CGPoint!
  private var easing : CGFloat = 0.1
  public var minimumHeight : CGFloat = 0

  private var isPingPong = false
  var clickArea : SKAControlSprite?

  private(set) var palette : ColorPalette!

  public init() {
    super.init(texture: nil, color: .clear, size: .zero)
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    clickArea = SKAControlSprite(texture: nil, color: .clear, size: .zero)
    clickArea?.zPosition = 1000
    
    addChild(clickArea!)
    clickArea!.isUserInteractionEnabled = true

    if let playerNumber = userData?.value(forKey: "catpongplayer") as? Int {
      if playerNumber == 1 {
        setup(palette: ColorManager.sharedInstance.getColorPalette(UserDefaultsManager.sharedInstance.playerOnePalette))
      } else {
        setup(palette: ColorManager.sharedInstance.getColorPalette(UserDefaultsManager.sharedInstance.playerTwoPalette))
      }
    } else {
      setup(palette: ColorManager.sharedInstance.getColorPalette(0))
    }
  }

  convenience init(palette: ColorPalette, pingPong : Bool = false) {
    self.init()

    setup(palette: palette, pingPong: pingPong)
  }

  private func setup(palette : ColorPalette, pingPong : Bool = false) {
    self.palette = palette
    isPingPong = pingPong

    let top = SKSpriteNode(imageNamed: "umbrellaTop")
    let bottom = SKSpriteNode(imageNamed: "umbrellaBottom")

    if pingPong {
      top.physicsBody = SKPhysicsBody(texture: top.texture!, size: top.size)
      anchorPoint = CGPoint(x: 1, y: 0.5)

      top.physicsBody?.mass = 500
    } else {
      let path = UIBezierPath()
      path.move(to: CGPoint(x: -top.size.width / 2, y: -top.size.height / 2))
      path.addLine(to: CGPoint(x: 0, y: top.size.height / 2))
      path.addLine(to: CGPoint(x: top.size.width / 2, y: -top.size.height / 2))
      path.addLine(to: CGPoint(x: top.size.width / 2 - 10, y: -top.size.height / 2))
      path.addLine(to: CGPoint(x: 0, y: top.size.height / 2 - 10))
      path.addLine(to: CGPoint(x: -top.size.width / 2 + 10, y: -top.size.height / 2))
      path.close()

      top.physicsBody = SKPhysicsBody(edgeLoopFrom: path.cgPath)
    }
    
    top.physicsBody?.isDynamic = false
    top.physicsBody?.categoryBitMask = UmbrellaCategory
    top.physicsBody?.contactTestBitMask = RainDropCategory
    top.physicsBody?.restitution = 0.9

    top.zPosition = 4
    bottom.zPosition = 2

    top.colorBlendFactor = 1
    bottom.colorBlendFactor = 1

    top.color = palette.umbrellaTopColor
    bottom.color = palette.umbrellaBottomColor

    if xScale > 0 {
      top.position.y = (top.size.height + bottom.size.height) / 2
    } else {
      top.position.y = (top.size.height + bottom.size.height) / 2 - 5
    }

    bottom.position.x -= bottom.size.width / 4

    addChild(top)
    addChild(bottom)

    umbrellaTop = top
    umbrellaBottom = bottom

    if clickArea != nil {
      clickArea?.size = CGSize(width: top.size.width, height: top.size.width)
      clickArea?.position.y += 50
    }
  }

  public func updatePosition(point : CGPoint) {
    position = point
    destination = point
  }

  public func setDestination(destination : CGPoint) {
    self.destination = destination

    if destination.y < minimumHeight {
      self.destination.y = minimumHeight
    }

    let distance = Distance(p1: self.destination, p2: self.position)

    if isPingPong {
      easing = 0.3
    } else {
      if distance > UIScreen.main.bounds.width / 2 {
        easing = 0.04
      } else if distance > UIScreen.main.bounds.width / 4 {
        easing = 0.1
      } else {
        easing = 0.15
      }

      if self.destination.y == minimumHeight && position.y <= (minimumHeight + 5) {
        easing = max(easing / 2, 0.04)
      }
    }
  }

  public func update(deltaTime : TimeInterval) {
    let distance = sqrt(pow((destination.x - position.x), 2) + pow((destination.y - position.y), 2))

    if(distance > 1) {
      let directionX = (destination.x - position.x)
      let directionY = (destination.y - position.y)

      position.x += directionX * easing
      position.y += directionY * easing
    } else {
      position = destination;
    }
  }

  public func getVelocity() -> CGVector {
    return CGVector(dx: destination.x - position.x, dy: destination.y - position.y)
  }

  public func getHeight() -> CGFloat {
    return umbrellaTop.size.height + umbrellaBottom.size.height
  }

  public func updatePalette(palette: ColorPalette) {
    self.palette = palette

    umbrellaTop.run(ColorAction().colorTransitionAction(fromColor: umbrellaTop.color, toColor: palette.umbrellaTopColor, duration: colorChangeDuration))
    umbrellaBottom.run(ColorAction().colorTransitionAction(fromColor: umbrellaBottom.color, toColor: palette.umbrellaBottomColor, duration: colorChangeDuration))
  }

  public func updatePalette(palette : Int) {
    self.palette = ColorManager.sharedInstance.getColorPalette(palette)

    updatePalette(palette: self.palette)
  }

  func makeDynamic() {
    umbrellaTop.physicsBody = nil
    physicsBody = SKPhysicsBody(circleOfRadius: 15)
    physicsBody?.categoryBitMask = CatCategory
    physicsBody?.contactTestBitMask = WorldFrameCategory
    physicsBody?.density = 0.01
    physicsBody?.linearDamping = 1
    physicsBody?.isDynamic = true
    physicsBody?.allowsRotation = true

    zPosition = 0
    umbrellaTop.zPosition = 1
    umbrellaBottom.zPosition = 0
  }

  override func isEqual(_ object: Any?) -> Bool {
    return super.isEqual(object) || umbrellaTop.isEqual(object) || umbrellaBottom.isEqual(object)
  }
}
