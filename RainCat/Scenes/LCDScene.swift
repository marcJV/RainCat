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
  private var isQuitting = false

  override func didMove(to view: SKView) {
    let lcdReference = childNode(withName: "lcd-reference")

    var controlsTextSize : CGFloat = 25
    var optionsTextSize : CGFloat = 19

    if UIDevice.current.userInterfaceIdiom == .phone {
      controlsTextSize = 35
      optionsTextSize = 25
    }

    lcdScreen = lcdReference?.children[0].childNode(withName: "lcd-screen") as! LCDScreenNode
    lcdScreen.setup()

    let rainCatLabel = childNode(withName: "rain-cat-logo") as! ShadowLabelNode!
    rainCatLabel?.setup(fontNamed: BASE_FONT_NAME)
    rainCatLabel?.text = "RAINCAT"
    rainCatLabel?.fontSize = 80

    leftButton = childNode(withName: "left-button") as! TwoPaneButton!
    leftButton.setup(text: "left", fontSize: controlsTextSize)
    leftButton.addTarget(self, selector: #selector(moveLeft(_:)), forControlEvents: .TouchUpInside)

    rightButton = childNode(withName: "right-button") as! TwoPaneButton!
    rightButton.setup(text: "right", fontSize: controlsTextSize)
    rightButton.addTarget(self, selector: #selector(moveRight(_:)), forControlEvents: .TouchUpInside)

    resetButton = childNode(withName: "reset-button") as! TwoPaneButton!
    resetButton.setup(text: "reset", fontSize: optionsTextSize)
    resetButton.addTarget(self, selector: #selector(resetPressed(_:)), forControlEvents: [.TouchDown, .DragEnter])
    resetButton.addTarget(self, selector: #selector(resetReleased(_:)), forControlEvents: [.TouchUpInside, .TouchUpOutside])

    quitButton = childNode(withName: "quit-button") as! TwoPaneButton!
    quitButton.setup(text: "quit", fontSize: optionsTextSize)
    quitButton.addTarget(self, selector: #selector(quitPressed(_:)), forControlEvents: .TouchUpInside)
  }

  override func update(_ currentTime: TimeInterval) {
    var deltaTime = currentTime - lastUpdateTime
    lastUpdateTime = currentTime

    if deltaTime > 1 {
      deltaTime = 0
    }
    
    lcdScreen.update(deltaTime: deltaTime)
  }

  func moveLeft(_ sender:Any) {
    lcdScreen.moveUmbrellaLeft()
  }

  func moveRight(_ sender:Any) {
    lcdScreen.moveUmbrellaRight()
  }

  func quitPressed(_ sender:Any) {
//    MenuScene.presentMenuScene(currentScene: self)
  }

  func resetPressed(_ sender:Any) {
    lcdScreen.resetPressed()
  }

  func resetReleased(_ sender:Any) {
    lcdScreen.resetReleased()
  }

  deinit {
    print("destroyed LCD Game Scene")
  }
}
