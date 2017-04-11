//
//  LCDFoodRow.swift
//  RainCat
//
//  Created by Marc Vandehey on 11/7/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

class LCDFoodRow : SKNode, Resetable, LCDSetupable {

  private var foodPosition1 : SKSpriteNode!
  private var foodPosition2 : SKSpriteNode!
  private var foodPosition3 : SKSpriteNode!
  private var foodPosition4 : SKSpriteNode!
  private var foodPosition5 : SKSpriteNode!
  private var foodPosition6 : SKSpriteNode!

  private(set) var foodLocation = -1

  private var shouldUpdate = true

  func setup() {
    foodPosition1 = childNode(withName: "food-pos-one") as! SKSpriteNode!
    foodPosition2 = childNode(withName: "food-pos-two") as! SKSpriteNode!
    foodPosition3 = childNode(withName: "food-pos-three") as! SKSpriteNode!
    foodPosition4 = childNode(withName: "food-pos-four") as! SKSpriteNode!
    foodPosition5 = childNode(withName: "food-pos-five") as! SKSpriteNode!
    foodPosition6 = childNode(withName: "food-pos-six") as! SKSpriteNode!

    turnOffLocationAtIndex(index: 0)
    turnOffLocationAtIndex(index: 1)
    turnOffLocationAtIndex(index: 2)
    turnOffLocationAtIndex(index: 3)
    turnOffLocationAtIndex(index: 4)
    turnOffLocationAtIndex(index: 5)

    showNextPosition()
  }

  func showNextPosition() {
    if shouldUpdate {
      turnOffLocationAtIndex(index: foodLocation)
      var location = Int(arc4random() % LCD_MAX_LOCATION)

      //If location clashes with last location move the food to an adjacent location
      if foodLocation == location {
        location += (arc4random() % 2 == 0) ? 1 : -1

        if location < 0 {
          location = Int(LCD_MAX_LOCATION) - 1
        } else if location > Int(LCD_MAX_LOCATION) - 1 {
          location = 0
        }
      }

      print("next food location \(location)")

      turnOnLocationAtIndex(index: location)
    }
  }

  func resetPressed() {
    shouldUpdate = false

    turnOnLocationAtIndex(index: 0)
    turnOnLocationAtIndex(index: 1)
    turnOnLocationAtIndex(index: 2)
    turnOnLocationAtIndex(index: 3)
    turnOnLocationAtIndex(index: 4)
    turnOnLocationAtIndex(index: 5)
  }

  func resetReleased() {
    turnOffLocationAtIndex(index: 0)
    turnOffLocationAtIndex(index: 1)
    turnOffLocationAtIndex(index: 2)
    turnOffLocationAtIndex(index: 3)
    turnOffLocationAtIndex(index: 4)
    turnOffLocationAtIndex(index: 5)

    shouldUpdate = true
    showNextPosition()
  }

  func turnOffLocationAtIndex(index : Int) {
    switch index {
    case 0:
      foodPosition1.alpha = lcdOffAlpha
    case 1:
      foodPosition2.alpha = lcdOffAlpha
    case 2:
      foodPosition3.alpha = lcdOffAlpha
    case 3:
      foodPosition4.alpha = lcdOffAlpha
    case 4:
      foodPosition5.alpha = lcdOffAlpha
    default:
      foodPosition6.alpha = lcdOffAlpha
    }
  }

  func turnOnLocationAtIndex(index : Int) {
    switch index {
    case 0:
      foodPosition1.alpha = lcdOnAlpha
    case 1:
      foodPosition2.alpha = lcdOnAlpha
    case 2:
      foodPosition3.alpha = lcdOnAlpha
    case 3:
      foodPosition4.alpha = lcdOnAlpha
    case 4:
      foodPosition5.alpha = lcdOnAlpha
    default:
      foodPosition6.alpha = lcdOnAlpha
      foodLocation = 5 // In case we are at a negative location
    }
    
    foodLocation = index
  }
}
