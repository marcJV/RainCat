//
//  RainTransition.swift
//  RainCat
//
//  Created by Marc Vandehey on 5/23/17.
//  Copyright © 2017 Thirteen23. All rights reserved.
//

import SpriteKit

class RainTransition : SKNode {

  var sprites = [[SKSpriteNode]]()
  var spriteNameDict = [String : Int]()

  func setup() {
    zPosition = 2000

    let scene = SKScene(fileNamed: "RainTransition")

    var row = 0
    var col = 0

    var currentSprite = scene?.childNode(withName: getSpriteName(row: row, col: col))

    while currentSprite != nil {
      currentSprite?.removeFromParent()
      addChild(currentSprite!)

      currentSprite?.alpha = 0

      spriteNameDict.updateValue(children.index(of: currentSprite!)!, forKey: currentSprite!.name!)

      if row == 0 {
        sprites.append([SKSpriteNode]())
      }

      sprites[col].append(currentSprite as! SKSpriteNode)

      row += 1

      currentSprite = scene?.childNode(withName: getSpriteName(row: row, col: col))

      //Check for end of row, if nil get next column
      if currentSprite == nil {
        print("Sprites in col: \(col) is \(sprites[col].count)")

        row = 0
        col += 1

        currentSprite = scene?.childNode(withName: getSpriteName(row: row, col: col))
      }
    }
  }

  func performTransition(extras : TransitionExtras?) {
    if let extras = extras {
      switch extras.transitionType {
      case .ScaleInCircular(let point):
        performScaleSpiral(toScale: 1, atPoint: point, fromColor: extras.fromColor, toColor: extras.toColor)

      case .ScaleInEvenOddColumn:
        performScaleInEvenOdd(fromColor: extras.fromColor, toColor: extras.toColor)
      case .ScaleInChecker:
        performScaleInChecker(fromColor: extras.fromColor, toColor: extras.toColor)
      case .ScaleInLinearTop:
        performScaleInLinearTop(fromColor: extras.fromColor, toColor: extras.toColor)
      case .ScaleInUniform:
        performScaleInUniform(fromColor: extras.fromColor, toColor: extras.toColor)
      }
    }
  }

  func performScaleInUniform(fromColor : SKColor, toColor : SKColor) {
    for column in sprites {
      for row in column {
        let scaleAnim = getScaleAnimation(fromColor: fromColor, toColor: toColor, toScale: 1)

        row.run(scaleAnim)
      }
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
      (self.parent as! Router).transitionCoveredScreen()

      self.performScaleOutUniform(fromColor: toColor, toColor: toColor)
    }
  }

  private func performScaleOutUniform(fromColor : SKColor, toColor : SKColor) {
    for column in sprites {
      for row in column {
        let scaleAnim = getScaleAnimation(fromColor: fromColor, toColor: toColor, toScale: 0)

        row.run(scaleAnim)
      }
    }
  }

  func performScaleInEvenOdd(fromColor : SKColor, toColor : SKColor)  {
    let scaleAnim = getScaleAnimation(fromColor: fromColor, toColor: toColor, toScale: 1)

    for col in 0 ..< sprites.count {
      for row in 0 ..< sprites[col].count {
        let node = sprites[col][row]
        node.alpha = 1
        node.scale(to: CGSize())

        let delay = isEven(number: row)

        node.run(SKAction.sequence([
          SKAction.wait(forDuration: 0.3 * (delay ? 0 : 1)),
          scaleAnim
          ]))
      }
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
      (self.parent as! Router).transitionCoveredScreen()

      self.performScaleOutEvenOdd(fromColor: toColor, toColor: toColor)
    }
  }

  private func performScaleOutEvenOdd(fromColor : SKColor, toColor : SKColor) {
    let scaleAnim = getScaleAnimation(fromColor: fromColor, toColor: toColor, toScale: 1)

    for col in 0 ..< sprites.count {

      for row in 0 ..< sprites[col].count {
        let node = sprites[col][row]
        let delay = isEven(number: row)

        node.run(SKAction.sequence([
          SKAction.wait(forDuration: 0.3 * (delay ? 0 : 1)),
          scaleAnim
          ]))
      }
    }
  }

  func performScaleInChecker(fromColor : SKColor, toColor : SKColor) {
    let scaleAnim = getScaleAnimation(fromColor: fromColor, toColor: toColor, toScale: 1)

    for col in 0 ..< sprites.count {
      for row in 0 ..< sprites[col].count {
        let node = sprites[col][row]
        node.alpha = 1
        node.scale(to: CGSize())

        let delay = isEven(number: row) && isEven(number: col) || !isEven(number: row) && isEven(number: col)

        node.run(SKAction.sequence([
          SKAction.wait(forDuration: 0.3 * (delay ? 0 : 1)),
          scaleAnim
          ]))
      }
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
      (self.parent as! Router).transitionCoveredScreen()

      self.performScaleOutChecker(fromColor: toColor, toColor: toColor)
    }
  }

  private func performScaleOutChecker(fromColor : SKColor, toColor : SKColor) {
    let scaleAnim = getScaleAnimation(fromColor: fromColor, toColor: toColor, toScale: 0)

    for col in 0 ..< sprites.count {
      for row in 0 ..< sprites[col].count {
        let node = sprites[col][row]
        let delay = !isEven(number: row) && !isEven(number: col) || isEven(number: row) && !isEven(number: col)

        node.run(SKAction.sequence([
          SKAction.wait(forDuration: 0.3 * (delay ? 0 : 1)),
          scaleAnim
          ]))
      }
    }
  }

  func performScaleInLinearTop(fromColor : SKColor, toColor : SKColor) {
    let scaleAnim = getScaleAnimation(fromColor: fromColor, toColor: toColor, toScale: 1)

    for column in sprites {
      for i in 0 ..< column.count {
        let sprite = column[i]
        sprite.alpha = 1
        sprite.scale(to: CGSize())
        sprite.color = fromColor

        sprite.run(SKAction.sequence([
          SKAction.wait(forDuration: 0.05 * TimeInterval(i)),
          scaleAnim
          ]))
      }
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
      (self.parent as! Router).transitionCoveredScreen()

      self.performScaleOutLinearTop(fromColor: toColor, toColor: toColor)
    }
  }

  private func performScaleOutLinearTop(fromColor : SKColor, toColor : SKColor) {
    let scaleAnim = getScaleAnimation(fromColor: fromColor, toColor: toColor, toScale: 0)

    for column in sprites {
      for i in 0 ..< column.count {
        let sprite = column[i]
        sprite.run(SKAction.sequence([
          SKAction.wait(forDuration: 0.05 * TimeInterval(i)),
          scaleAnim
          ]))
      }
    }
  }

  //Beware! Brittle code awaits yee who dares to enter
  func performScaleSpiral(toScale: CGFloat, atPoint: CGPoint, fromColor : SKColor, toColor : SKColor) {
    let count = children.count
    var affectedCount = 0

    var childAtPoint : SKSpriteNode?
    for child in children {
      if child.contains(atPoint) {
        childAtPoint = (child as! SKSpriteNode)

        break
      }
    }

    if childAtPoint == nil {
      childAtPoint = (children[Int(arc4random()) % children.count] as! SKSpriteNode)
    }

    let coordinates = childAtPoint?.name?.characters.split{$0 == "."}.map(String.init)

    var col = Int(coordinates![0])!
    var row = Int(coordinates![1])!
    var lastDirection = Direction.None
    let animationKey = "scaleKey\(toScale)\(fromColor)\(toColor)"

    var sideLength = 0
    var currentSideMovement = 0

    let anim = getScaleAnimation(fromColor: fromColor, toColor: toColor, toScale: toScale)

    var delay : TimeInterval = 0
    while affectedCount < count {
      let nodeName = getSpriteName(row: row, col: col)

      if let key = spriteNameDict[nodeName] {
        let node = children[key] as! SKSpriteNode

        if node.action(forKey: animationKey) == nil {
          node.setScale(1 - toScale)
          node.color = fromColor
          node.alpha = 1

          delay = 0.001 * TimeInterval(affectedCount)

          node.run(SKAction.sequence([
            SKAction.wait(forDuration: delay),
            anim
            ]), withKey: animationKey)
          
          affectedCount += 1
        }
      }

      switch lastDirection {
      case .None:
        lastDirection = .South
      case .South:
        sideLength += 2
        currentSideMovement = 0

        lastDirection = .NorthWest
        row += 1
      case .NorthWest:
        if currentSideMovement < sideLength {
          lastDirection = .NorthWest

          if isEven(number: col) {
            row -= 1
          }

          col -= 1

          currentSideMovement += 1
        } else {
          lastDirection = .NorthEast
          currentSideMovement = 0
        }
      case .NorthEast:

        if currentSideMovement < sideLength {
          lastDirection = .NorthEast

          if isEven(number: col) {
            row -= 1
          }

          col += 1

          currentSideMovement += 1
        } else {
          lastDirection = .SouthEast
          currentSideMovement = 0
        }

      case  .SouthEast:
        if currentSideMovement < sideLength {
          lastDirection = .SouthEast

          if !isEven(number: col) {
            row += 1
          }
          
            col += 1

          currentSideMovement += 1
        } else {
          lastDirection = .SouthWest
          currentSideMovement = 0
        }
      case .SouthWest:
        if currentSideMovement < sideLength {
          lastDirection = .SouthWest

          if !isEven(number: col) {
            row += 1
          }

          col -= 1

          currentSideMovement += 1
        } else {
          lastDirection = .South
          currentSideMovement = 0
        }
      case .West: break
      case .North: break
      case .East: break
        
      }
    }

    if(toScale > 0) {
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
        (self.parent as! Router).transitionCoveredScreen()

        self.performScaleSpiral(toScale: 0, atPoint: atPoint, fromColor: toColor, toColor: toColor)
      }
    }
  }

  func getScaleAnimation(fromColor : SKColor, toColor : SKColor, toScale: CGFloat) -> SKAction {
    let scaleAnim = SKAction.scale(to: toScale, duration: 0.5)
    scaleAnim.timingMode = .easeIn

    return SKAction.group([
      scaleAnim,
      SKAction.sequence([
        SKAction.wait(forDuration: 0.1),
        ColorAction().colorTransitionAction(fromColor: fromColor, toColor: toColor)
        ])
      ])
  }

  func isEven(number : Int) -> Bool {
    return number % 2 == 0
  }
  
  func getSpriteName(row: Int, col: Int) -> String {
    return "\(col).\(row)"
  }
}

enum TransitionType {
  case ScaleInUniform
  case ScaleInLinearTop
  case ScaleInCircular(fromPoint : CGPoint)
  case ScaleInEvenOddColumn
  case ScaleInChecker
}

class TransitionExtras {
  var transitionType : TransitionType
  var fromColor : SKColor
  var toColor : SKColor

  init(transitionType : TransitionType, fromColor : SKColor = RAIN_COLOR, toColor : SKColor = RAIN_COLOR) {
    self.transitionType = transitionType
    self.fromColor = fromColor
    self.toColor = toColor
  }
}

enum Direction {
  case North, NorthEast, East, SouthEast, South, SouthWest, West, NorthWest, None
}
