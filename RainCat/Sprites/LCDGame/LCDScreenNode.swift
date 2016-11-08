//
//  LCDViewModel.swift
//  RainCat
//
//  Created by Marc Vandehey on 11/1/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

class LCDScreenNode : SKSpriteNode {
  private var lane1 : LCDRainLane!
  private var lane2 : LCDRainLane!
  private var lane3 : LCDRainLane!
  private var lane4 : LCDRainLane!
  private var lane5 : LCDRainLane!
  private var lane6 : LCDRainLane!
  private var umbrellaRow : LCDUmbrellaRow!
  private var foodRow : LCDFoodRow!
  private var catRow : LCDCatRow!
  private var hudNode : LCDHudNode!

  private var tick : TimeInterval = 0.8
  private var tickNumber = 3
  private let ticksPerDrop = 4
  private var lastUpdateTime : TimeInterval = 0.0

  func setup() {
    lane1 = childNode(withName: "raindrop-lane-one")   as! LCDRainLane!
    lane2 = childNode(withName: "raindrop-lane-two")   as! LCDRainLane!
    lane3 = childNode(withName: "raindrop-lane-three") as! LCDRainLane!
    lane4 = childNode(withName: "raindrop-lane-four")  as! LCDRainLane!
    lane5 = childNode(withName: "raindrop-lane-five")  as! LCDRainLane!
    lane6 = childNode(withName: "raindrop-lane-six")   as! LCDRainLane!

    umbrellaRow = childNode(withName: "umbrella-row") as! LCDUmbrellaRow!
    foodRow = childNode(withName: "food-row") as! LCDFoodRow!
    catRow = childNode(withName: "cat-row") as! LCDCatRow!
    hudNode = childNode(withName: "hud")   as! LCDHudNode!

    lane1.setup()
    lane2.setup()
    lane3.setup()
    lane4.setup()
    lane5.setup()
    lane6.setup()

    umbrellaRow.setup()
    foodRow.setup()
    catRow.setup()
    hudNode.setup()
  }

  func update(deltaTime : TimeInterval) {
    lastUpdateTime += deltaTime

    if lastUpdateTime >= tick {
      lastUpdateTime = 0.0

      killRaindropAtUmbrellaIndex()

      lane1.update()
      lane2.update()
      lane3.update()
      lane4.update()
      lane5.update()
      lane6.update()

      if tickNumber >= ticksPerDrop {
        tickNumber = 0

        //May loop here if we want more than one drop per tick
        switch arc4random() % 6 {
        case 0:
          lane1.addRaindrop()
        case 1:
          lane2.addRaindrop()
        case 2:
          lane3.addRaindrop()
        case 3:
          lane4.addRaindrop()
        case 4:
          lane5.addRaindrop()
        default:
          lane6.addRaindrop()
        }
      }

      tickNumber += 1
    }
  }

  //Call this before updating the lanes
  func killRaindropAtUmbrellaIndex() {
    switch umbrellaRow.umbrellaLocation {
    case 0:
      lane1.removeUmbrellaLevelRaindrop()
    case 1:
      lane2.removeUmbrellaLevelRaindrop()
    case 2:
      lane3.removeUmbrellaLevelRaindrop()
    case 3:
      lane4.removeUmbrellaLevelRaindrop()
    case 4:
      lane5.removeUmbrellaLevelRaindrop()
    default:
      lane6.removeUmbrellaLevelRaindrop()
    }
  }

  //Call this before updating lanes
  func checkFoodEaten() {

  }

  func moveUmbrellaLeft() {
    umbrellaRow.moveLeft()
  }

  func moveUmbrellaRight() {
    umbrellaRow.moveRight()
  }
}
