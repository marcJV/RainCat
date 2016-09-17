//
//  LogoScene.swift
//  RainCat
//
//  Created by Marc Vandehey on 9/16/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

public class LogoScene : SKScene {

  let backgroundSprite = SKSpriteNode(imageNamed: "launch_screen")
  let maskNode = SKCropNode()
  let circleNode = SKShapeNode(circleOfRadius: 20)

  let t23Logo = SKSpriteNode()

  var logoFrames = [SKTexture]()

  public override func sceneDidLoad() {
    //We can fix pulling a large number of assets if we do the mask animation ourselves
    //TODO: Need to figure out correct speed / easing and clean this up
    for index in 0...89 {
      let textureName = String(format: "Logo_000%02d", index)
      logoFrames.append(SKTexture(imageNamed: textureName))
    }

    backgroundColor = SKColor(red:0.18, green:0.20, blue:0.22, alpha:1.0)

    circleNode.setScale(0)

    maskNode.maskNode = circleNode

    backgroundSprite.position = CGPoint(x: frame.midX, y: frame.midY)
    addChild(backgroundSprite)

    circleNode.position = CGPoint(x: frame.midX, y: frame.midY)
    circleNode.fillColor = SKColor(red:0.18, green:0.20, blue:0.22, alpha:1.0)
    circleNode.lineWidth = 0

    circleNode.zPosition = 1
    addChild(circleNode)

    t23Logo.position = CGPoint(x: frame.midX, y: frame.midY)
    t23Logo.zPosition = 2
    addChild(t23Logo)
  }

  public override func didMove(to view: SKView) {
    circleNode.run(SKAction.sequence([
      SKAction.wait(forDuration: 0.1),
      SKAction.scale(to: 100, duration: 0.8)
      ]))

    //Preload the menu
    let menuScene = MenuScene(size: self.size)

    t23Logo.run(SKAction.sequence([
      SKAction.wait(forDuration: 0.6),
      SKAction.animate(with: logoFrames, timePerFrame: 0.03, resize: true, restore: false),
      SKAction.wait(forDuration: 1),
      SKAction.customAction(withDuration: 0.0, actionBlock: { _ in
        let transition = SKTransition.reveal(with: .left, duration: 0.75)
        transition.pausesOutgoingScene = false
        transition.pausesIncomingScene = false

        menuScene.scaleMode = self.scaleMode

        self.view?.presentScene(menuScene, transition: transition)
      })
      ]))

    if !SoundManager.sharedInstance.isMuted {
      run(SKAction.sequence([
        SKAction.wait(forDuration: 2.6),
        SKAction.playSoundFileNamed("cat_meow_3", waitForCompletion: true)
        ]))
    }
  }

  deinit {
    print("logo scene destroyed")
  }
}
