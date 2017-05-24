//
//  LogoScene.swift
//  RainCat
//
//  Created by Marc Vandehey on 9/16/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

public class LogoScene : SceneNode {

  let backgroundSprite = SKSpriteNode()
  let maskNode = SKCropNode()
  let circleNode = SKShapeNode(circleOfRadius: 20)

  let t23Logo = SKSpriteNode()

  var logoFrames = [SKTexture]()

  override func layoutScene(size : CGSize, extras menuExtras: MenuExtras?) {
    if !UserDefaultsManager.sharedInstance.isMuted {
      SoundManager.sharedInstance.startPlaying()
    }

    //We can fix pulling a large number of assets if we do the mask animation ourselves
    //TODO: Need to figure out correct speed / easing and clean this up
    for index in 0...89 {
      let textureName = String(format: "Logo_000%02d", index)
      logoFrames.append(SKTexture(imageNamed: textureName))
    }

    let backgroundNode = SKSpriteNode(color: SKColor(red:0.18, green:0.20, blue:0.22, alpha:1.0), size: size)
    addChild(backgroundNode)

    circleNode.setScale(0)

    maskNode.maskNode = circleNode

    backgroundSprite.position = CGPoint(x: size.width / 2, y: size.height / 2)
    addChild(backgroundSprite)

    circleNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
    circleNode.fillColor = SKColor(red:0.18, green:0.20, blue:0.22, alpha:1.0)
    circleNode.lineWidth = 0

    let texture = SKTexture(imageNamed: "loony")

    backgroundSprite.size.width = size.height / texture.size().height * texture.size().width
    backgroundSprite.size.height = size.height

    backgroundSprite.texture = texture

    circleNode.zPosition = 1
    addChild(circleNode)

    t23Logo.position = CGPoint(x: size.width / 2, y: size.height / 2)
    t23Logo.zPosition = 2
    addChild(t23Logo)
  }

  override func attachedToScene() {
    circleNode.run(SKAction.sequence([
      SKAction.wait(forDuration: 0.1),
      SKAction.scale(to: 100, duration: 0.8)
      ]))

    t23Logo.run(SKAction.sequence([
      SKAction.wait(forDuration: 0.6),
      SKAction.animate(with: logoFrames, timePerFrame: 0.03, resize: true, restore: false),
      SKAction.wait(forDuration: 1)
      ]))

    DispatchQueue.main.asyncAfter(deadline: .now() + 2.7) {
      if let parent = self.parent as? Router {
        parent.navigate(to: .MainMenu, extras: MenuExtras(rainScale: 0, catScale: 0,
                                                          transition:
          TransitionExtras(transitionType: .ScaleInLinearTop,
                           fromColor: SKColor(red:0.18, green:0.20, blue:0.22, alpha:1.0),
                           toColor: BACKGROUND_COLOR)))
      }
    }

    if !UserDefaultsManager.sharedInstance.isMuted {
      run(SKAction.sequence([
        SKAction.wait(forDuration: 2.6),
        SKAction.playSoundFileNamed("cat_meow_3", waitForCompletion: true)
        ]))
    }
  }

  override func detachedFromScene() {
    
  }
  
  deinit {
    print("logo scene destroyed")
  }
}
