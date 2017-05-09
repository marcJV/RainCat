//
//  MenuScene.swift
//  RainCat
//
//  Created by Marc Vandehey on 9/6/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

class MenuScene : SceneNode, MenuNavigation, SKPhysicsContactDelegate {
  let catSprite = CatSprite.newInstance()
  let lcdCatSprite = SKSpriteNode(imageNamed: "cat_two")
  var rainDropBanner : RainDropBanner!

  var curtainMask : CurtainSprite!
  var curtainSprite: CurtainSprite!
  let curtainPadding : CGFloat = 100

  var soundButtonSprite : SKAControlSprite!
  var soundForegroundSprite : SoundButtonSprite!
  var soundMask : SoundButtonSprite!

  var backButton : TwoPaneButton!

  var titleNode : TitleMenuNode!
  var creditsNode : CreditsNode!

  override func layoutScene(size: CGSize) {
    anchorPoint = CGPoint(x: 0, y: 0)
    color = BACKGROUND_COLOR
    isUserInteractionEnabled = true

    var sceneNode : SKScene

    if UIDevice.current.userInterfaceIdiom == .phone {
      sceneNode = SKScene(fileNamed: "MainMenu")!//Todo make iphone variant
    } else {
      sceneNode = SKScene(fileNamed: "MainMenu")!
    }

    for child in sceneNode.children {
      child.removeFromParent()
      addChild(child)

      //Fix position since SKS file's anchorpoint is (0,1)
      child.position.y += size.height
    }

    let cropNode = SKCropNode()
    cropNode.zPosition = 100
    cropNode.position = CGPoint(x: 0, y: 0)

    let maskNode = SKNode()
    maskNode.zPosition = 100
    cropNode.maskNode = maskNode

    curtainMask = CurtainSprite.newInstance(size: CGSize(width: size.width + curtainPadding, height: size.height * 1.25))
    curtainMask.strokeColor = .clear
    curtainMask.position = CGPoint(x: 0, y: -23)
    curtainMask.fillColor = .black

    cropNode.addChild(curtainMask)
    addChild(cropNode)

    curtainSprite = CurtainSprite.newInstance(size: CGSize(width: size.width, height: size.height * 1.25))
    curtainSprite.fillColor = SKColor(red:0.59, green:0.71, blue:0.74, alpha:1.0)
    curtainSprite.strokeColor = .clear
    addChild(curtainSprite)

    let curtainForeground = CurtainSprite.newInstance(size: CGSize(width: size.width + curtainPadding, height: size.height * 1.25))
    curtainForeground.fillColor = SKColor(red:0.69, green:0.80, blue:0.82, alpha:1.0)
    curtainForeground.strokeColor = .clear
    curtainSprite.addChild(curtainForeground)

    //Stagger curtain for shadow effect
    curtainForeground.position = CGPoint(x: 0, y: -13)
    curtainSprite.position = CGPoint(x: 0, y: -10)

    rainDropBanner = childNode(withName: "banner") as! RainDropBanner
    rainDropBanner.setup(maskNode: maskNode)

    maskNode.addChild(lcdCatSprite)
    curtainForeground.zPosition = 50

    lcdCatSprite.physicsBody = nil
    lcdCatSprite.zPosition = 100

    //Add in floor physics body
    physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: 20), to: CGPoint(x: size.width, y: 20))
    physicsBody?.categoryBitMask = FloorCategory
    physicsBody?.contactTestBitMask = RainDropCategory
    physicsBody?.restitution = 0.3

    catSprite.position = CGPoint(x: size.width / 2, y: size.height / 2)
    addChild(catSprite)

    let creditsButton = childNode(withName: "button-credits") as! TextButtonSprite
    creditsButton.set(text: "credits", fontSize: 35, autoResize: true)

    creditsButton.position = CGPoint(x: creditsButton.size.width / 2,
                                     y: creditsButton.size.height / 2)


    let titleReference = childNode(withName: "title-reference")

    titleNode = titleReference?.children[0].childNode(withName: "group-title") as! TitleMenuNode
    titleNode.setup()

    let creditsReference = childNode(withName: "menu-reference")
    creditsNode = creditsReference?.children[0].childNode(withName: "group-credits") as! CreditsNode
    creditsNode.setup(navigation: self)

    setupSoundButton(maskNode: maskNode)

    backButton = childNode(withName: "button-back") as! TwoPaneButton
    backButton.zPosition = 300

    let singlePlayerLabel = childNode(withName: "label-singleplayer") as! ShadowLabelNode
    maskNode.addChild(singlePlayerLabel.getLCDVersion())

    let lcdScoreNode = childNode(withName: "lcd-score") as! LCDScoreNode!
    let classicScoreNode = childNode(withName: "classic-score") as! LCDScoreNode!

    lcdScoreNode?.setup()
    classicScoreNode?.setup()

    lcdScoreNode?.updateDisplay(score: 100)
    classicScoreNode?.updateDisplay(score: 100)

    lcdScoreNode?.removeFromParent()
    classicScoreNode?.removeFromParent()

    maskNode.addChild(lcdScoreNode!)
    maskNode.addChild(classicScoreNode!)
  }

  func setupSoundButton(maskNode : SKNode) {
    soundButtonSprite = SKAControlSprite(color: .clear, size: CGSize(width: 100, height: 65))
    soundButtonSprite.position = CGPoint(x: size.width - soundButtonSprite.size.width / 2, y: soundButtonSprite.size.height / 2)
    soundButtonSprite.zPosition = 300
    addChild(soundButtonSprite)

    soundButtonSprite.addTarget(self, selector: #selector(soundButtonTouched(_:)), forControlEvents: [.TouchDown, .DragEnter])
    soundButtonSprite.addTarget(self, selector: #selector(soundButtonReleased(_:)), forControlEvents: [.DragExit, .TouchCancelled])
    soundButtonSprite.addTarget(self, selector: #selector(soundButtonPressed(_:)), forControlEvents: [.TouchUpInside])

    soundMask = SoundButtonSprite(size: soundButtonSprite.size)
    soundMask.position = soundButtonSprite.position

    soundForegroundSprite = SoundButtonSprite(size: soundButtonSprite.size)
    soundForegroundSprite.position = soundButtonSprite.position

    maskNode.addChild(soundMask)
    addChild(soundForegroundSprite)

    
  }

  override func attachedToScene() {
    curtainSprite.position.x = size.width
    curtainMask.position.x = size.width


    let slidingAction = SKAction.repeatForever(SKAction.sequence([
      SKAction.move(by: CGVector(dx: -size.width - curtainPadding / 2, dy: 0), duration: 15.55),
      SKAction.move(by: CGVector(dx: size.width + curtainPadding / 2, dy: 0), duration: 15.55)]))

    curtainMask.run(slidingAction)
    curtainSprite.run(slidingAction)


    //    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(5000)) {
    //      if let parent = self.parent as? Router {
    //        parent.navigate(to: .Logo)
    //      }
    //    }
  }

  override func detachedFromScene() {

  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first {

      if catSprite.contains(touch.location(in: self)) {
        SoundManager.sharedInstance.meow(node: catSprite)

        switch catSprite.xScale {
        case 1:
          catSprite.run(SKAction.scale(to: 2, duration: 0.05))
        case 2:
          catSprite.run(SKAction.scale(to: 3, duration: 0.05))
        case 0...1:
          catSprite.run(SKAction.scale(to: 1, duration: 0.05))
          rainDropBanner.makeItRain()
        default:
          catSprite.run(SKAction.scale(to: 0.5, duration: 0.05))
        }
      } else {
        rainDropBanner.touchBegan(touch: touch)
      }
    }
  }

  func navigateToUrl(url: String) {
    UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
  }

  override func update(dt: TimeInterval) {
    lcdCatSprite.position = catSprite.position
    lcdCatSprite.zRotation = catSprite.zRotation
    lcdCatSprite.setScale(catSprite.xScale)

    rainDropBanner.update(size: size)
  }

  func soundButtonTouched(_ sender : SKAControlSprite) {
    soundForegroundSprite.setPressed()
    soundMask.setPressed()
  }

  func soundButtonReleased(_ sender : SKAControlSprite) {
    soundForegroundSprite.setReleased(toggleState: false)
    soundMask.setReleased(toggleState: false)
  }

  func soundButtonPressed(_ sender : SKAControlSprite) {
    soundForegroundSprite.setReleased(toggleState: true)
    soundMask.setReleased(toggleState: true)
  }

  func didBegin(_ contact: SKPhysicsContact) {
    //TODO will start game here!
  }

  deinit {
    print("menu scene destroyed")
  }
}
