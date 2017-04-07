//
//  LCDCatRow.swift
//  RainCat
//
//  Created by Marc Vandehey on 11/7/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

class LCDCatRow : SKNode, Resetable, LCDUpdateable, LCDSetupable {
  private var catPosition1 : LCDCatNode!
  private var catPosition2 : LCDCatNode!
  private var catPosition3 : LCDCatNode!
  private var catPosition4 : LCDCatNode!
  private var catPosition5 : LCDCatNode!
  private var catPosition6 : LCDCatNode!

  private(set) var catLocation = 0
  private var facingLeft = false
  private var shouldUpdate = true

  private(set) var didEatFood = false
  var foodLocation = 0

  func setup() {
    catPosition1 = childNode(withName: "cat-pos-one") as! LCDCatNode!
    catPosition2 = childNode(withName: "cat-pos-two") as! LCDCatNode!
    catPosition3 = childNode(withName: "cat-pos-three") as! LCDCatNode!
    catPosition4 = childNode(withName: "cat-pos-four") as! LCDCatNode!
    catPosition5 = childNode(withName: "cat-pos-five") as! LCDCatNode!
    catPosition6 = childNode(withName: "cat-pos-six") as! LCDCatNode!

    for child in children {
      if let setupable = child as? LCDSetupable {
        setupable.setup()
      }
    }

    reset()
  }

  func update() {
    if shouldUpdate {
      didEatFood = false
      
      if catLocation == foodLocation {
        //Has Food!!
        didEatFood = true
      } else if foodLocation < catLocation && facingLeft {
        catLocation -= 1
      } else if foodLocation < catLocation {
        facingLeft = true
      } else if foodLocation > catLocation && !facingLeft {
        catLocation += 1
      } else {
        facingLeft = false
      }

      //Safety check to keep cat on screen
      if catLocation < 0 {
        catLocation = 0
      } else if catLocation > 5 {
        catLocation = 5
      }

      updateDisplay(location: catLocation, facingLeft: facingLeft)
    }
  }

  func resetPressed() {
    shouldUpdate = false

    for child in children {
      if let resetable = child as? Resetable {
        resetable.resetPressed()
      }
    }
  }

  func resetReleased() {
    for child in children {
      if let resetable = child as? Resetable {
        resetable.resetReleased()
      }
    }

    shouldUpdate = true
    reset()
  }

  private func reset() {
    catLocation = Int(arc4random() % LCD_MAX_LOCATION)
    facingLeft = Int(arc4random()) % 2 == 0

    updateDisplay(location: catLocation, facingLeft: facingLeft)
  }

  private func updateDisplay(location: Int, facingLeft : Bool) {
    for child in children {
      if child is LCDCatNode {
        (child as! LCDCatNode).update(hasCat: false, facingLeft: false)
      }
    }

    switch location {
    case 0:
      catPosition1.update(hasCat: true, facingLeft: facingLeft)
    case 1:
      catPosition2.update(hasCat: true, facingLeft: facingLeft)
    case 2:
      catPosition3.update(hasCat: true, facingLeft: facingLeft)
    case 3:
      catPosition4.update(hasCat: true, facingLeft: facingLeft)
    case 4:
      catPosition5.update(hasCat: true, facingLeft: facingLeft)
    default:
      catPosition6.update(hasCat: true, facingLeft: facingLeft)
    }
  }
}
