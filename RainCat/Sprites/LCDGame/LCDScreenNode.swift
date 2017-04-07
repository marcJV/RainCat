//
//  LCDViewModel.swift
//  RainCat
//
//  Created by Marc Vandehey on 11/1/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

class LCDScreenNode : SKSpriteNode, Resetable {
  private var lanes = [LCDRainLane]()

  private var umbrellaRow : LCDUmbrellaRow!
  private var foodRow : LCDFoodRow!
  private var catRow : LCDCatRow!
  private var hudNode : LCDHudNode!

  private var tick : TimeInterval = 1.25 //How fast the game updates
  private var tickNumber = 7 //Current Tick
  private var spawnsPerDrop = 0 //Number of raindrops per spawn
  private let ticksPerDrop = 6 //Number of ticks it takes to spawn raindrops
  private var lastUpdateTime : TimeInterval = 0.0

  func setup() {
    lanes.append(childNode(withName: "raindrop-lane-one") as! LCDRainLane!)
    lanes.append(childNode(withName: "raindrop-lane-two") as! LCDRainLane!)
    lanes.append(childNode(withName: "raindrop-lane-three") as! LCDRainLane!)
    lanes.append(childNode(withName: "raindrop-lane-four") as! LCDRainLane!)
    lanes.append(childNode(withName: "raindrop-lane-five") as! LCDRainLane!)
    lanes.append(childNode(withName: "raindrop-lane-six") as! LCDRainLane!)

    umbrellaRow = childNode(withName: "umbrella-row") as! LCDUmbrellaRow!
    foodRow = childNode(withName: "food-row") as! LCDFoodRow!
    catRow = childNode(withName: "cat-row") as! LCDCatRow!
    hudNode = childNode(withName: "hud")   as! LCDHudNode!

    for child in children {
      if let setupable = child as? LCDSetupable {
        setupable.setup()
      }
    }
  }

  func update(deltaTime : TimeInterval) {
    hudNode.update()

    if(!hudNode.hasLivesRemaining()){
      //Don't update anything! ..other than time
      return
    }

    lastUpdateTime += deltaTime

    if lastUpdateTime >= tick {
      lastUpdateTime = 0.0

      if checkCatHit() {
        hudNode.catHit()
      }

      if hudNode.hasLivesRemaining() {
        if checkUmbrellaLevelRaindrop(atIndex: umbrellaRow.umbrellaLocation) {
          hudNode.addScore()

          //Extra raindrop at umbrella location!
          addRaindrop(atIndex: umbrellaRow.umbrellaLocation)
        }

        //Tell cat row where the food is
        catRow.foodLocation = foodRow.foodLocation

        for child in children {
          if let updateable = child as? LCDUpdateable {
            updateable.update()
          }
        }

        if catRow.didEatFood {
          hudNode.addScore()
          foodRow.showNextPosition()

          //Extra raindrop!
          addRaindrop(atIndex: Int(arc4random() % LCD_MAX_LOCATION))
        }

        if tickNumber >= ticksPerDrop {
          tickNumber = 0

          for _ in 0...spawnsPerDrop {
            //May loop here if we want more than one drop per tick
            addRaindrop(atIndex: Int(arc4random() % LCD_MAX_LOCATION))
          }
        }
      } else {
        //Game over!
        lanes[catRow.catLocation].blinkRaindrop()
      }

      tickNumber += 1
    }
  }

  func addRaindrop(atIndex index : Int) {
    if indexInBounds(index: index) {
      lanes[index].addRaindrop()
    } else {
      print("Cannot add raindrop at location \(index)")
    }
  }

  //Call this before updating the lanes
  func checkUmbrellaLevelRaindrop(atIndex index : Int) -> Bool {
    if indexInBounds(index: index) {
      return lanes[index].checkUmbrellaHit()
    } else {
      print("Cannot check umbrella level at index \(index)")

      return false
    }
  }

  func checkCatHit() -> Bool {
    if indexInBounds(index: catRow.catLocation) {
      return lanes[catRow.catLocation].hasCatLevel()
    } else {
      print("cat out of bounds!")
      return false
    }
  }

  private func indexInBounds(index : Int) -> Bool {
    return index >= 0 && index < Int(LCD_MAX_LOCATION)
  }

  func moveUmbrellaLeft() {
    umbrellaRow.moveLeft()
  }

  func moveUmbrellaRight() {
    umbrellaRow.moveRight()
  }

  func resetPressed() {
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
  }
}
