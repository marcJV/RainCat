//
//  LCDScene.swift
//  RainCat
//
//  Created by Marc Vandehey on 10/31/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import Foundation
import SpriteKit

class LCDScene : SKScene {
  private var lcdScreen   : LCDScreenNode!
  private var leftButton  : TwoPaneButton!
  private var rightButton : TwoPaneButton!
  private var resetButton : TwoPaneButton!
  private var quitButton  : TwoPaneButton!

  private var lastUpdateTime : TimeInterval = 0.0

  private var currentButton : TwoPaneButton?

  override func didMove(to view: SKView) {
    lcdScreen = childNode(withName: "lcd-screen") as! LCDScreenNode!
    lcdScreen.setup()

    let rainCatLabel = childNode(withName: "rain-cat-logo") as! ShadowLabelNode!
    rainCatLabel?.setup(fontNamed: BASE_FONT_NAME)
    rainCatLabel?.text = "RAINCAT"
    rainCatLabel?.fontSize = 80

    leftButton = childNode(withName: "left-button") as! TwoPaneButton!
    leftButton.setup(text: "left", fontSize: 25)

    rightButton = childNode(withName: "right-button") as! TwoPaneButton!
    rightButton.setup(text: "right", fontSize: 25)

    resetButton = childNode(withName: "reset-button") as! TwoPaneButton!
    resetButton.setup(text: "reset", fontSize: 19)

    quitButton = childNode(withName: "quit-button") as! TwoPaneButton!
    quitButton.setup(text: "quit", fontSize: 19)
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if currentButton == nil && touches.first != nil {
      let location = touches.first!.location(in: self)

      if leftButton.contains(location) {
        currentButton = leftButton
      } else if rightButton.contains(location) {
        currentButton = rightButton
      } else if resetButton.contains(location) {
        currentButton = resetButton

        lcdScreen.resetPressed()
      } else if quitButton.contains(location) {
        currentButton = quitButton
      }

      currentButton?.setTouched()
    }
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    if currentButton != nil && touches.first != nil {
      let location = touches.first!.location(in: self)

      if currentButton!.contains(location) {
        currentButton?.setTouched()
      } else {
        currentButton?.setUntouched()
      }

      if currentButton! == resetButton {
        //TODO Reset the game anyways
      }
    }
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let button = currentButton {
      if button == leftButton {
        lcdScreen.moveUmbrellaLeft()
      } else if button == rightButton {
        lcdScreen.moveUmbrellaRight()
      } else if button == resetButton {
        lcdScreen.resetReleased()
      } else if button == quitButton {
        //quit button action
      }
    }

    leftButton.setUntouched()
    rightButton.setUntouched()
    resetButton.setUntouched()
    quitButton.setUntouched()

    currentButton = nil
  }

  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    leftButton.setUntouched()
    rightButton.setUntouched()
    resetButton.setUntouched()
    quitButton.setUntouched()
    currentButton = nil
  }

  override func update(_ currentTime: TimeInterval) {
    var deltaTime = currentTime - lastUpdateTime
    lastUpdateTime = currentTime

    if deltaTime > 1 {
      deltaTime = 0
    }

    lcdScreen.update(deltaTime: deltaTime)
  }
}
