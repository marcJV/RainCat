//
//  LCDTimeNode.swift
//  RainCat
//
//  Created by Marc Vandehey on 3/29/17.
//  Copyright © 2017 Thirteen23. All rights reserved.
//

import SpriteKit

class LCDTimeNode : SKNode, Resetable, LCDSetupable {
  private var hoursTensSpot : LCDNumberNode!
  private var hoursOnesSpot : LCDNumberNode!
  private var minutesTensSpot : LCDNumberNode!
  private var minutesOnesSpot : LCDNumberNode!
  private let calendar = Calendar.current

  private let dateFormatter = DateFormatter()
  private var shouldUpdate = true


  func setup() {
    hoursTensSpot = childNode(withName: "hour-tens") as! LCDNumberNode!
    hoursOnesSpot = childNode(withName: "hour-ones") as! LCDNumberNode!
    minutesTensSpot = childNode(withName: "minute-tens") as! LCDNumberNode!
    minutesOnesSpot = childNode(withName: "minute-ones") as! LCDNumberNode!

    for child in children {
      if let setupable = child as? LCDSetupable {
        setupable.setup()
      }
    }
  }

  func update() {
    if(shouldUpdate) {
    let comp = calendar.dateComponents([.hour, .minute], from: Date())
    let hour = comp.hour
    let minute = comp.minute

    updateDisplay(hours: hour!, minutes: minute!)
    }
  }

  private func updateDisplay(hours : Int, minutes : Int) {
    let hoursOnes = hours % 10
    let hoursTens = (hours - hoursOnes) % 100

    let minutesOnes = minutes % 10
    let minutesTens = (minutes - minutesOnes) % 100

    hoursTensSpot.updateDisplay(number: hoursTens / 10)
    hoursOnesSpot.updateDisplay(number: hoursOnes)

    minutesTensSpot.updateDisplay(number: minutesTens / 10)
    minutesOnesSpot.updateDisplay(number: minutesOnes)
  }

  func resetPressed() {
    shouldUpdate = false

    updateDisplay(hours: 88, minutes: 88)
  }

  func resetReleased() {
    shouldUpdate = true
  }
}
