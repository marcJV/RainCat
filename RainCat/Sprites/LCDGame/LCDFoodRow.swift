//
//  LCDFoodRow.swift
//  RainCat
//
//  Created by Marc Vandehey on 11/7/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

class LCDFoodRow : SKNode {

  var foodPosition1 : SKSpriteNode!
  var foodPosition2 : SKSpriteNode!
  var foodPosition3 : SKSpriteNode!
  var foodPosition4 : SKSpriteNode!
  var foodPosition5 : SKSpriteNode!
  var foodPosition6 : SKSpriteNode!

  var currentPosition = -1

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
    turnOffLocationAtIndex(index: currentPosition)
    var location = Int(arc4random() % 6)

    //If location clashes with last location move the food to an adjacent location
    if currentPosition == location {
      location += (arc4random() % 2 == 0) ? 1 : -1

      location %= 6

      print(location)
    }

    turnOnLocationAtIndex(index: location)
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
      currentPosition = 5 // In case we are at a negative location
    }

    currentPosition = index

  }
}
