//
//  LCDScene.swift
//  RainCat
//
//  Created by Marc Vandehey on 10/31/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import Foundation
import SpriteKit

class LCDSceneNode : SceneNode {
  private var lcdScreen   : LCDScreenNode!
  private var leftButton  : TwoPaneButton!
  private var rightButton : TwoPaneButton!
  private var resetButton : TwoPaneButton!
  private var quitButton  : TwoPaneButton!

  private var currentButton : TwoPaneButton?
  private var isQuitting = false

  override func layoutScene(size : CGSize, extras menuExtras: MenuExtras?) {
    var scene : SKScene
    anchorPoint = CGPoint(x: 0, y: 0)
    color = BACKGROUND_COLOR

    if UIDevice.current.userInterfaceIdiom == .phone {
      scene = SKScene(fileNamed: "LCDScene-iPhone")!//Todo make iphone variant
    } else {
      scene = SKScene(fileNamed: "LCDScene")!
    }

    for child in scene.children {
      child.removeFromParent()
      addChild(child)

      //Fix position since SKS file's anchorpoint is (0,1)
      child.position.y += size.height
    }

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
    leftButton.addTarget(self, selector: #selector(moveLeft), forControlEvents: .TouchUpInside)

    rightButton = childNode(withName: "right-button") as! TwoPaneButton!
    rightButton.setup(text: "right", fontSize: controlsTextSize)
    rightButton.addTarget(self, selector: #selector(moveRight), forControlEvents: .TouchUpInside)

    resetButton = childNode(withName: "reset-button") as! TwoPaneButton!
    resetButton.setup(text: "reset", fontSize: optionsTextSize)
    resetButton.addTarget(self, selector: #selector(resetPressed), forControlEvents: [.TouchDown, .DragEnter])
    resetButton.addTarget(self, selector: #selector(resetReleased), forControlEvents: [.TouchUpInside, .TouchUpOutside])

    quitButton = childNode(withName: "quit-button") as! TwoPaneButton!
    quitButton.setup(text: "quit", fontSize: optionsTextSize)
    quitButton.addTarget(self, selector: #selector(quitPressed), forControlEvents: .TouchUpInside)
  }

  override func attachedToScene() {}

  override func detachedFromScene() {}

  override func update(dt: TimeInterval) {
    lcdScreen.update(deltaTime: dt)
  }

  func moveLeft() {
    lcdScreen.moveUmbrellaLeft()

    
  }

  func moveRight() {
    lcdScreen.moveUmbrellaRight()
  }

  func quitPressed() {
    if let parent = parent as? Router {
      parent.navigate(to: .MainMenu, extras: MenuExtras(rainScale: 0, catScale: 0, transition: TransitionExtras(transitionType: .ScaleInLinearTop, fromColor: .black)))
    }
  }

  func resetPressed() {
    lcdScreen.resetPressed()
  }

  func resetReleased() {
    lcdScreen.resetReleased()
  }

  deinit {
    print("destroyed LCD Game Scene")
  }
}
