//
//  MenuScene.swift
//  RainCat
//
//  Created by Marc Vandehey on 9/6/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

class MenuSceneNode : SceneNode, MenuNavigation, SKPhysicsContactDelegate, MenuNodeAnimation {
  private let catSprite = CatSprite.newInstance()
  private let lcdCatSprite = SKSpriteNode(imageNamed: "cat_two")
  private var rainDropBanner : RainDropBanner!

  private var curtainMask : CurtainSprite!
  private var curtainSprite: CurtainSprite!
  private let curtainPadding : CGFloat = 100

  private var soundButtonSprite : SKAControlSprite!
  private var soundForegroundSprite : SoundButtonSprite!
  private var soundMask : SoundButtonSprite!

  private var backButton : TwoPaneButton!
  private var creditsButton : TextButtonSprite!

  private var titleNode : TitleMenuNode!
  private var creditsNode : CreditsNode!
  private var multiplayerNode : MultiplayerNode!
  private var playerSelectNode : PlayerSelectNode!

  private weak var currentNode : MenuNodeAnimation!

  //Single player menu elements
  private var classicHighScoreNode : SKLabelNode!
  private var lcdHighScoreNode : SKLabelNode!
  private var classicScoreNode : LCDScoreNode!
  private var lcdScoreNode : LCDScoreNode!
  private var singlePlayerLabel : ShadowLabelNode!
  private var singlePlayerMaskLabel : SKLabelNode!
  private var buttonClassic : TwoPaneButton!
  private var buttonLCD : TwoPaneButton!

  private var curtainReference : AnimationReference!
  private var singlePlayerTextReference : AnimationReference!
  private var buttonClassicReference : AnimationReference!
  private var buttonLCDReference : AnimationReference!
  private var classicScoreReference : AnimationReference!
  private var lcdScoreReference : AnimationReference!
  private var classicLEDScoreReference : AnimationReference!
  private var lcdLEDScoreReference : AnimationReference!
  private var backButtonReference : AnimationReference!
  private var creditsButtonReference : AnimationReference!

  private var navigationItem : Location?

  override func layoutScene(size : CGSize, extras menuExtras: MenuExtras?) {
    anchorPoint = CGPoint(x: 0, y: 0)
    color = BACKGROUND_COLOR
    isUserInteractionEnabled = true

    var scene : SKScene

    if UIDevice.current.userInterfaceIdiom == .phone {
      scene = SKScene(fileNamed: "MainMenu")!//Todo make iphone variant
    } else {
      scene = SKScene(fileNamed: "MainMenu")!
    }

    for child in scene.children {
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

    creditsButton = childNode(withName: "button-credits") as! TextButtonSprite
    creditsButton.set(text: "credits", fontSize: 35, autoResize: true)
    creditsButton.addTarget(self, selector: #selector(menuToCredits), forControlEvents: .TouchUpInside)

    creditsButton.position = CGPoint(x: creditsButton.size.width / 2,
                                     y: creditsButton.size.height / 2)

    let titleReference = childNode(withName: "title-reference")

    titleNode = titleReference?.children[0].childNode(withName: "group-title") as! TitleMenuNode
    currentNode = titleNode
    titleNode.setup(sceneSize: size)
    titleNode.menuNavigation = self

    let creditsReference = childNode(withName: "menu-reference")
    creditsNode = creditsReference?.children[0].childNode(withName: "group-credits") as! CreditsNode
    creditsNode.setup(sceneSize: size)
    creditsNode.menuNavigation = self

    let playerSelectReference = childNode(withName: "catpong-reference")
    playerSelectNode = playerSelectReference?.children[0].childNode(withName: "group-playerselect") as! PlayerSelectNode
    playerSelectNode.setup(sceneSize: size)
    playerSelectNode.menuNavigation = self

    let multiplayerReference = childNode(withName: "multiplayer-reference")
    multiplayerNode = multiplayerReference?.children[0].childNode(withName: "group-multiplayer") as! MultiplayerNode
    multiplayerNode.setup(sceneSize: size)
    multiplayerNode.menuNavigation = self
    multiplayerNode.umbrella1LeftPosition = playerSelectNode.umbrellaLeftPositions.umbrella1Left
    multiplayerNode.umbrella2LeftPosition = playerSelectNode.umbrellaLeftPositions.umbrella2Left

    setupSoundButton(maskNode: maskNode)

    backButton = childNode(withName: "button-back") as! TwoPaneButton
    backButton.addTarget(self, selector: #selector(menuBack), forControlEvents: .TouchUpInside)
    backButton.zPosition = 300

    //Single player node needs to be managed locally to support the masking effect
    singlePlayerLabel = childNode(withName: "label-singleplayer") as! ShadowLabelNode!
    singlePlayerMaskLabel = singlePlayerLabel.getLCDVersion()
    maskNode.addChild(singlePlayerMaskLabel)

    buttonClassic = childNode(withName: "button-classic") as! TwoPaneButton!
    buttonLCD = childNode(withName: "button-lcd") as! TwoPaneButton!

    let classicScore = UserDefaultsManager.sharedInstance.getClassicHighScore()
    let lcdScore = UserDefaultsManager.sharedInstance.getLCDHighScore()

    classicHighScoreNode = childNode(withName: "label-classic-highscore") as! SKLabelNode
    lcdHighScoreNode = childNode(withName: "label-lcd-highscore") as! SKLabelNode

    classicHighScoreNode.text = "\(classicScore)"
    lcdHighScoreNode.text = "\(lcdScore)"

    lcdScoreNode = childNode(withName: "lcd-score") as! LCDScoreNode!
    classicScoreNode = childNode(withName: "classic-score") as! LCDScoreNode!

    lcdScoreNode.setup()
    classicScoreNode.setup()

    lcdScoreNode.updateDisplay(score: lcdScore)
    classicScoreNode.updateDisplay(score: classicScore)

    lcdScoreNode.removeFromParent()
    classicScoreNode.removeFromParent()

    maskNode.addChild(lcdScoreNode!)
    maskNode.addChild(classicScoreNode)

    setup(sceneSize: size)
  }

  func setupSoundButton(maskNode : SKNode) {
    soundButtonSprite = SKAControlSprite(color: .clear, size: CGSize(width: 100, height: 65))
    soundButtonSprite.position = CGPoint(x: size.width - soundButtonSprite.size.width / 2, y: soundButtonSprite.size.height / 2)
    soundButtonSprite.zPosition = 300
    addChild(soundButtonSprite)

    soundButtonSprite.addTarget(self, selector: #selector(soundButtonTouchDown), forControlEvents: [.TouchDown, .DragEnter])
    soundButtonSprite.addTarget(self, selector: #selector(soundButtonTouchUp), forControlEvents: [.DragExit, .TouchCancelled])
    soundButtonSprite.addTarget(self, selector: #selector(soundButtonTouchUpInside), forControlEvents: [.TouchUpInside])

    soundMask = SoundButtonSprite(size: soundButtonSprite.size)
    soundMask.position = soundButtonSprite.position

    soundForegroundSprite = SoundButtonSprite(size: soundButtonSprite.size)
    soundForegroundSprite.position = soundButtonSprite.position

    maskNode.addChild(soundMask)
    addChild(soundForegroundSprite)

    if UserDefaultsManager.sharedInstance.isMuted {
      soundForegroundSprite.setMuted()
      soundMask.setMuted()
    }
  }

  override func attachedToScene() {
    curtainSprite.position.x = size.width
    curtainMask.position.x = size.width
  }

  override func detachedFromScene() {}

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
        default:
          catSprite.run(SKAction.scale(to: 0.5, duration: 0.05))
        }
      } else {
        rainDropBanner.touchBegan(touch: touch)
      }
    }
  }

  func navigateToUrl(url: String) {
    if !isNavigating {
      if #available(iOS 10.0, *) {
        UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
      } else {
        UIApplication.shared.openURL(URL(string: url)!)
      }
    }
  }

  func getName() -> String {
    return "menu"
  }

  func navigateToSinglePlayerClassic() {
    if !isNavigating {
      curtainMask.run(SKActionHelper.moveToEaseInOut(x: curtainReference.offscreenRight, duration: 1.0))
      curtainSprite.run(SKActionHelper.moveToEaseInOut(x: curtainReference.offscreenRight, duration: 1.0))

      navigationItem = .Classic
      rainDropBanner.makeItRain()
    }

    backButton.isUserInteractionEnabled = false
    tempDisableButton(duration: 1)
  }

  func navigateToSinglePlayerLCD() {
    if !isNavigating {
      curtainMask.run(SKActionHelper.moveToEaseInOut(x: curtainReference.offscreenLeft, duration: 1.0))
      curtainSprite.run(SKActionHelper.moveToEaseInOut(x: curtainReference.offscreenLeft, duration: 1.0))

      navigationItem = .LCD
      rainDropBanner.makeItRain()
    }

    backButton.isUserInteractionEnabled = false
    tempDisableButton(duration: 1)
  }

  func navigateToMultiplerClassic() {
    if !isNavigating {
      navigationItem = .ClassicMulti
      rainDropBanner.makeItRain()
    }


    backButton.isUserInteractionEnabled = false
    tempDisableButton(duration: 1)
  }

  func navigateToMultiplayerCatPong() {
    if !isNavigating {
      navigationItem = .CatPong
      rainDropBanner.makeItRain()
    }

    backButton.isUserInteractionEnabled = false
    tempDisableButton(duration: 1)
  }

  func menuToSinglePlayer() {    
    if !isNavigating {
      backButton.moveTo(y: backButtonReference.zeroPosition)
      creditsButton.run(SKActionHelper.moveToEaseInOut(y: creditsButtonReference.offscreenLeft, duration: 0.5))

      currentNode.navigateOutToLeft(duration: 1.0)

      navigateInFromRight(duration: 1.0)

      currentNode = self
    }

    tempDisableButton(duration: 1)
  }

  func menuToMultiplayer() {
    if !isNavigating {
      backButton.moveTo(y: backButtonReference.zeroPosition)
      creditsButton.run(SKActionHelper.moveToEaseInOut(y: creditsButtonReference.offscreenLeft, duration: 0.5))

      currentNode.navigateOutToLeft(duration: 1.0)
      multiplayerNode.navigateInFromRight(duration: 1.0)

      currentNode = multiplayerNode
    }

    tempDisableButton(duration: 1)
  }

  func menuToPlayerSelect() {
    if !isNavigating {
      currentNode.navigateOutToLeft(duration: 1.0)
      playerSelectNode.navigateInFromRight(duration: 1.0)

      currentNode = playerSelectNode
    }

    tempDisableButton(duration: 1)
  }

  func menuBack() {
    if !isNavigating {
      currentNode.navigateOutToRight(duration: 1.0)

      if currentNode.getName() == playerSelectNode.getName() {
        multiplayerNode.navigateInFromLeft(duration: 1.0)
        currentNode = multiplayerNode
      } else {
        backButton.moveTo(y: backButtonReference.offscreenLeft)
        creditsButton.run(SKActionHelper.moveToEaseInOut(y: creditsButtonReference.zeroPosition, duration: 0.5))

        titleNode.navigateInFromLeft(duration: 1.0)
        currentNode = titleNode
      }
    }

    tempDisableButton(duration: 1)
  }

  func menuToCredits() {
    if !isNavigating {
      backButton.moveTo(y: backButtonReference.zeroPosition)
      creditsButton.run(SKActionHelper.moveToEaseInOut(y: creditsButtonReference.offscreenLeft, duration: 0.5))

      currentNode.navigateOutToLeft(duration: 1.0)
      creditsNode.navigateInFromRight(duration: 1.0)

      currentNode = creditsNode
    }

    backButton.isUserInteractionEnabled = false
    tempDisableButton(duration: 1)
  }

  func navigateToTutorial() {
    if !isNavigating {
      if let parent = parent as? Router {
        parent.navigate(to: .Directions,
                        extras: MenuExtras(rainScale: 1,
                                           catScale: 1,
                                           transition: TransitionExtras(transitionType: TransitionType.ScaleInChecker)))
      }
    }
  }

  override func update(dt: TimeInterval) {
    lcdCatSprite.position = catSprite.position
    lcdCatSprite.zRotation = catSprite.zRotation
    lcdCatSprite.setScale(catSprite.xScale)

    rainDropBanner.update(size: size)
  }

  func soundButtonTouchDown() {
    if !isNavigating {
      soundForegroundSprite.setPressed()
      soundMask.setPressed()
    }
  }

  func soundButtonTouchUp() {
    if !isNavigating {
      soundForegroundSprite.setReleased(toggleState: false)
      soundMask.setReleased(toggleState: false)
    }
  }

  func soundButtonTouchUpInside() {
    if !isNavigating {
      soundForegroundSprite.setReleased(toggleState: false)
      soundMask.setReleased(toggleState: false)

      if(SoundManager.sharedInstance.toggleMute()) {
        soundForegroundSprite.setMuted()
        soundMask.setMuted()
      } else {
        soundForegroundSprite.setPlaying()
        soundMask.setPlaying()
      }
    }
  }

  var isNavigating = false

  func didBegin(_ contact: SKPhysicsContact) {
    if !isNavigating &&
      (contact.bodyA.categoryBitMask == CatCategory || contact.bodyB.categoryBitMask == CatCategory) &&
      (contact.bodyA.categoryBitMask != FloorCategory && contact.bodyB.categoryBitMask != FloorCategory) {
      isNavigating = true

      var rainScale : CGFloat = 0.33
      if contact.bodyA.categoryBitMask == RainDropCategory {
        rainScale = contact.bodyA.node!.xScale
      } else if contact.bodyB.categoryBitMask == RainDropCategory {
        rainScale = contact.bodyB.node!.xScale
      }

      switch rainScale {
      case 0...0.34:
        rainScale = 1
      case 0.34...0.99:
        rainScale = 2
      default:
        rainScale = 3
      }

      let extras = MenuExtras(rainScale: rainScale,
                              catScale: catSprite.xScale,
                              transition: TransitionExtras(transitionType: .ScaleInCircular(fromPoint: contact.contactPoint),
                                                           toColor: self.navigationItem! == .LCD ? .black : RAIN_COLOR))

      if let parent = parent as? Router, navigationItem != nil {
        parent.navigate(to: self.navigationItem!, extras: extras)
      }
    }
  }

  func setup(sceneSize: CGSize) {
    buttonClassic.addTarget(self, selector: #selector(navigateToSinglePlayerClassic), forControlEvents: .TouchUpInside)
    buttonLCD.addTarget(self, selector: #selector(navigateToSinglePlayerLCD), forControlEvents: .TouchUpInside)

    curtainReference = AnimationReference(zeroPosition: size.width / 2 - 24, offscreenLeft: -50, offscreenRight: size.width * 1.1)

    singlePlayerTextReference = AnimationReference(zeroPosition: singlePlayerLabel.position.x,
                                                   offscreenLeft: singlePlayerLabel.position.x - size.width,
                                                   offscreenRight: size.width + singlePlayerLabel.position.x)

    buttonClassicReference = AnimationReference(zeroPosition: buttonClassic.position.x,
                                                offscreenLeft: buttonClassic.position.x - size.width,
                                                offscreenRight: size.width + buttonClassic.position.x)

    buttonLCDReference = AnimationReference(zeroPosition: buttonLCD.position.x,
                                            offscreenLeft: buttonLCD.position.x - size.width,
                                            offscreenRight: size.width + buttonLCD.position.x)

    classicScoreReference = AnimationReference(zeroPosition: classicHighScoreNode.position.x,
                                               offscreenLeft: classicHighScoreNode.position.x - size.width,
                                               offscreenRight: size.width + classicHighScoreNode.position.x)

    lcdScoreReference = AnimationReference(zeroPosition: lcdHighScoreNode.position.x,
                                           offscreenLeft: lcdHighScoreNode.position.x - size.width,
                                           offscreenRight: size.width + lcdHighScoreNode.position.x)

    classicLEDScoreReference = AnimationReference(zeroPosition: classicScoreNode.position.x,
                                                  offscreenLeft: classicScoreNode.position.x - size.width,
                                                  offscreenRight: size.width + classicScoreNode.position.x)

    lcdLEDScoreReference = AnimationReference(zeroPosition: lcdScoreNode.position.x,
                                              offscreenLeft: lcdScoreNode.position.x - size.width,
                                              offscreenRight: size.width + lcdScoreNode.position.x)

    backButtonReference = AnimationReference(zeroPosition: backButton.position.y,
                                             offscreenLeft: backButton.position.y + 200,
                                             offscreenRight: backButton.position.y + 200)

    creditsButtonReference = AnimationReference(zeroPosition: creditsButton.position.y,
                                                offscreenLeft: creditsButton.position.y - 200,
                                                offscreenRight: creditsButton.position.y - 200)

    backButton.moveTo(y: backButtonReference.offscreenLeft, duration: 0)
    navigateOutToRight(duration: 0)
  }

  func navigateOutToLeft(duration: TimeInterval) {
    //TODO implement maybe
  }

  func navigateInFromLeft(duration: TimeInterval) {

  }

  func navigateOutToRight(duration: TimeInterval) {
    curtainMask.run(SKActionHelper.moveToEaseInOut(x: curtainReference.offscreenRight, duration: duration))
    curtainSprite.run(SKActionHelper.moveToEaseInOut(x: curtainReference.offscreenRight, duration: duration))

    singlePlayerLabel.run(SKActionHelper.moveToEaseInOut(x: singlePlayerTextReference.offscreenRight, duration: duration))
    singlePlayerMaskLabel.run(SKActionHelper.moveToEaseInOut(x: singlePlayerTextReference.offscreenRight, duration: duration))

    buttonClassic.run(SKActionHelper.moveToEaseInOut(x: buttonClassicReference.offscreenRight, duration: duration * 0.95))
    buttonLCD.run(SKActionHelper.moveToEaseInOut(x: buttonLCDReference.offscreenRight, duration: duration * 1.05))

    lcdScoreNode.run(SKActionHelper.moveToEaseInOut(x: lcdLEDScoreReference.offscreenRight, duration: duration * 1.05))
    lcdHighScoreNode.run(SKActionHelper.moveToEaseInOut(x: lcdScoreReference.offscreenRight, duration: duration * 1.05))

    classicScoreNode.run(SKActionHelper.moveToEaseInOut(x: classicLEDScoreReference.offscreenRight, duration: duration * 1.1))
    classicHighScoreNode.run(SKActionHelper.moveToEaseInOut(x: classicScoreReference.offscreenRight, duration: duration * 1.1))
  }

  func navigateInFromRight(duration: TimeInterval) {
    curtainMask.run(SKActionHelper.moveToEaseInOut(x: curtainReference.zeroPosition, duration: duration))
    curtainSprite.run(SKActionHelper.moveToEaseInOut(x: curtainReference.zeroPosition, duration: duration))

    singlePlayerLabel.run(SKActionHelper.moveToEaseInOut(x: singlePlayerTextReference.zeroPosition, duration: duration))
    singlePlayerMaskLabel.run(SKActionHelper.moveToEaseInOut(x: singlePlayerTextReference.zeroPosition, duration: duration))

    buttonClassic.run(SKActionHelper.moveToEaseInOut(x: buttonClassicReference.zeroPosition, duration: duration * 0.95))
    buttonLCD.run(SKActionHelper.moveToEaseInOut(x: buttonLCDReference.zeroPosition, duration: duration * 1.05))

    lcdScoreNode.run(SKActionHelper.moveToEaseInOut(x: lcdLEDScoreReference.zeroPosition, duration: duration * 1.05))
    lcdHighScoreNode.run(SKActionHelper.moveToEaseInOut(x: lcdScoreReference.zeroPosition, duration: duration * 1.05))

    classicScoreNode.run(SKActionHelper.moveToEaseInOut(x: classicLEDScoreReference.zeroPosition, duration: duration * 1.1))
    classicHighScoreNode.run(SKActionHelper.moveToEaseInOut(x: classicScoreReference.zeroPosition, duration: duration * 1.1))
  }

  func tempDisableButton(duration : TimeInterval) {
    buttonClassic.isUserInteractionEnabled = false
    buttonLCD.isUserInteractionEnabled = false
    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
      self.buttonClassic.isUserInteractionEnabled = true
      self.buttonLCD.isUserInteractionEnabled = true
      self.backButton.isUserInteractionEnabled = true
    }
  }

  override func pauseNode() {
    catSprite.isPaused = true
    catSprite.physicsBody?.isDynamic = false
    catSprite.speed = 0
    
    rainDropBanner.pause()
    
    soundButtonSprite.isPaused = true
    soundForegroundSprite.isPaused = true
    soundMask.isPaused = true
    
    backButton.isPaused = true
    creditsButton.isPaused = true
    
    titleNode.isPaused = true
    creditsNode.isPaused = true
    multiplayerNode.isPaused = true
    playerSelectNode.isPaused = true
  }
  
  deinit {
    print("menu scene destroyed")
  }
}
