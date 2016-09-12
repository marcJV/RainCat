//
//  MenuScene.swift
//  RainCat
//
//  Created by Marc Vandehey on 9/6/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

class MenuScene : SKScene, SKPhysicsContactDelegate {
  let startButtonTexture = SKTexture(imageNamed: "button_start")
  let startButtonPressedTexture = SKTexture(imageNamed: "button_start_pressed")
  let soundButtonTexture = SKTexture(imageNamed: "speaker_on")
  let soundButtonTextureOff = SKTexture(imageNamed: "speaker_off")

  let logoSprite = SKSpriteNode(imageNamed: "logo")
  let catSprite = CatSprite.newInstance()
  var startButton : SKSpriteNode! = nil
  var soundButton : SKSpriteNode! = nil
  var creditsButton = SKLabelNode(fontNamed: "PixelDigivolve")

  let highScoreNode = SKLabelNode(fontNamed: "PixelDigivolve")
  var soundCreditNode = SKLabelNode(fontNamed: "PixelDigivolve")

  var selectedButton : SKNode?

  var rainDrops = [SKSpriteNode]()

  var showingCredits = false

  let creditsNode = SKNode()

  override func sceneDidLoad() {

    backgroundColor = SKColor(red:0.30, green:0.81, blue:0.89, alpha:1.0)

    //Setup logo - sprite initialized earlier
    logoSprite.position = CGPoint(x: size.width / 2, y: size.height / 2 + 100)
    
    addChild(logoSprite)

    //Setup start button
    startButton = SKSpriteNode(texture: startButtonTexture)
    startButton.position = CGPoint(x: size.width / 2,
                                   y: size.height / 2 - startButton.size.height / 2)
    addChild(startButton)

    let edgeMargin : CGFloat = 25
    //Setup sound button
    soundButton = SKSpriteNode(texture: (SoundManager.sharedInstance.isMuted ? soundButtonTextureOff : soundButtonTexture))
    soundButton.position = CGPoint(x: size.width - edgeMargin,
                                   y: edgeMargin)
    addChild(soundButton)

    //Setup high score node
    let defaults = UserDefaults.standard

    let highScore = defaults.integer(forKey: ScoreKey)

    highScoreNode.text = "\(highScore)"
    highScoreNode.fontSize = 90
    highScoreNode.verticalAlignmentMode = .top
    highScoreNode.position = CGPoint(x: size.width / 2,
                                     y: startButton.position.y - startButton.size.height / 2 - 50)
    highScoreNode.zPosition = 1

    addChild(highScoreNode)

    setupRaindrops(size.height - (logoSprite.position.y + logoSprite.size.height / 2))


    //Add in floor physics body
    physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: -size.width / 2, y: 20), to: CGPoint(x: size.width, y: 20))
    physicsBody?.categoryBitMask = FloorCategory
    physicsBody?.contactTestBitMask = RainDropCategory
    physicsBody?.restitution = 0.3


    catSprite.position = highScoreNode.position
    addChild(catSprite)

    physicsWorld.contactDelegate = self

    creditsButton = SKLabelNode(fontNamed: "PixelDigivolve")
    creditsButton.text = "?"
    creditsButton.verticalAlignmentMode = .center
    creditsButton.horizontalAlignmentMode = .center

    creditsButton.position = CGPoint(x: edgeMargin, y: edgeMargin)
    addChild(creditsButton)

    setupCredits()
  }

  //Quick attempt to make credits
  private func setupCredits() {
    let developerTitle = SKLabelNode(fontNamed: "PixelDigivolve")
    developerTitle.text = "development:"
    developerTitle.horizontalAlignmentMode = .center

    let developer = SKLabelNode(fontNamed: "PixelDigivolve")
    developer.text = "Marc Vandehey"
    developer.horizontalAlignmentMode = .center

    let designerTitle = SKLabelNode(fontNamed: "PixelDigivolve")
    designerTitle.text = "design:"
    designerTitle.horizontalAlignmentMode = .center

    let designCathryn = SKLabelNode(fontNamed: "PixelDigivolve")
    designCathryn.text = "Cathryn Rowe"
    designCathryn.horizontalAlignmentMode = .center

    let designMorgan = SKLabelNode(fontNamed: "PixelDigivolve")
    designMorgan.text = "Morgan Wheaton"
    designMorgan.horizontalAlignmentMode = .center

    let soundTitle = SKLabelNode(fontNamed: "PixelDigivolve")
    soundTitle.text = "MUSIC:"
    soundTitle.horizontalAlignmentMode = .center

    soundCreditNode.text = "Bensound.com"
    soundCreditNode.horizontalAlignmentMode = .center

    let sectionMargin : CGFloat = 40

    let xPos = size.width / 2
    developerTitle.position = CGPoint(x: xPos, y: logoSprite.position.y - logoSprite.size.height / 2 - sectionMargin - 10)
    developer.position = CGPoint(x: xPos, y: developerTitle.position.y - developerTitle.fontSize)

    designerTitle.position = CGPoint(x: xPos, y: developer.position.y - developer.fontSize - sectionMargin)
    designCathryn.position = CGPoint(x: xPos, y: designerTitle.position.y - designerTitle.fontSize)
    designMorgan.position = CGPoint(x: xPos, y: designCathryn.position.y - designCathryn.fontSize)

    soundTitle.position = CGPoint(x: xPos, y: designMorgan.position.y - designMorgan.fontSize - sectionMargin)
    soundCreditNode.position = CGPoint(x: xPos, y: soundTitle.position.y - soundTitle.fontSize)
    soundCreditNode.fontColor = SKColor(red:0.99, green:0.92, blue:0.55, alpha:1.0)

    creditsNode.addChild(developerTitle)
    creditsNode.addChild(developer)
    creditsNode.addChild(designerTitle)
    creditsNode.addChild(designCathryn)
    creditsNode.addChild(designMorgan)
    creditsNode.addChild(soundTitle)
    creditsNode.addChild(soundCreditNode)

    creditsNode.zPosition = 1000
    addChild(creditsNode)

    creditsNode.alpha = 0
  }

  //This is an ugly method that would benefit greatly from loading it from a .sks file
  private func setupRaindrops(_ height : CGFloat) {
    let margin : CGFloat = 60
    let lowerLimit = size.height - height + margin
    let upperLimit = size.height - margin
    let centerLine : CGFloat = (upperLimit + lowerLimit) / 2.0

    let rainTexture = SKTexture(imageNamed: "rain_drop")

    let rainDrop = SKSpriteNode(texture: rainTexture)
    rainDrop.position = CGPoint(x: size.width / 2, y: centerLine)

    rainDrop.zPosition = 10

    addChild(rainDrop)
    rainDrops.append(rainDrop)

    //Generate left side
    var xPosition = rainDrop.position.x
    var index = 0
    let innerMargin = 10 * UIScreen.main.nativeScale
    let offsetAmount = rainDrop.size.width / 2 + innerMargin

    xPosition -= offsetAmount

    while xPosition > margin {
      let rainDrop = SKSpriteNode(texture: rainTexture)
      var yPosition = centerLine

      if index % 6 == 0 {
        yPosition = centerLine - rainDrop.size.height
      } else if index % 3 == 0 {
        yPosition = centerLine - innerMargin
      } else if index % 2 == 0 {
        yPosition = centerLine + rainDrop.size.height
      }

      rainDrop.position = CGPoint(x: xPosition, y: yPosition)
      rainDrop.zPosition = 10

      addChild(rainDrop)
      rainDrops.append(rainDrop)

      xPosition -= offsetAmount
      index += 1
    }

    //Generate right side
    index = 8 //Hack to have the pattern line up correctly
    xPosition = rainDrop.position.x + offsetAmount
    while xPosition < size.width - margin {
      var yPosition = centerLine

      if index % 6 == 0 {
        yPosition = centerLine - rainDrop.size.height
      } else if index % 3 == 0 {
        yPosition = centerLine - innerMargin
      } else if index % 2 == 0 {
        yPosition = centerLine + rainDrop.size.height
      }

      let rainDrop = SKSpriteNode(texture: rainTexture)
      rainDrop.position = CGPoint(x: xPosition, y: yPosition)
      rainDrop.zPosition = 10

      addChild(rainDrop)
      rainDrops.append(rainDrop)

      xPosition += offsetAmount
      index += 1
    }
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first {
      if selectedButton != nil {
        handleStartButtonHover(isHovering: false)
        handleSoundButtonHover(isHovering: false)
      }

      if showingCredits {
        if soundCreditNode.contains(touch.location(in: self)) {
          selectedButton = soundCreditNode

          soundCreditNode.alpha = 0.75
        }
      }

      if creditsButton.contains(touch.location(in: self)) {
        selectedButton = creditsButton
        creditsButton.alpha = 0.75
      } else if !showingCredits && startButton.contains(touch.location(in: self)) {
        selectedButton = startButton
        handleStartButtonHover(isHovering: true)
      } else if soundButton.contains(touch.location(in: self)) {
        selectedButton = soundButton
        handleSoundButtonHover(isHovering: true)
      } else if catSprite.contains(touch.location(in: self)) {
        catSprite.meow()

        switch catSprite.xScale {
        case 1:
          catSprite.setScale(2)
        case 2:
          catSprite.setScale(3)
        case 0...1:
          catSprite.setScale(1)
        default:
          catSprite.setScale(0.5)
        }
      } else {
        for rainDrop in rainDrops {
          if rainDrop.contains(touch.location(in: self)) {

            if rainDrop.xScale < 3 {
              rainDrop.setScale(rainDrop.xScale + 1)
            }
          }
        }
      }
    }
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first {
      if selectedButton == startButton {
        handleStartButtonHover(isHovering: (startButton.contains(touch.location(in: self))))
      } else if selectedButton == soundButton {
        handleSoundButtonHover(isHovering: (soundButton.contains(touch.location(in: self))))
      } else if selectedButton == soundCreditNode {
        soundCreditNode.alpha = (soundCreditNode.contains(touch.location(in: self))) ? 0.75 : 1.0
      } else if selectedButton == creditsButton {
        creditsButton.alpha = (creditsButton.contains(touch.location(in: self))) ? 0.75 : 1.0
      }
    }
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first {

      if selectedButton == startButton {
        handleStartButtonHover(isHovering: false)

        if (startButton.contains(touch.location(in: self))) {
          handleStartButtonClick()
        }

      } else if selectedButton == soundButton {
        handleSoundButtonHover(isHovering: false)

        if (soundButton.contains(touch.location(in: self))) {
          handleSoundButtonClick()
        }
      } else if selectedButton == soundCreditNode {
        soundCreditNode.alpha = 1

        if (soundCreditNode.contains(touch.location(in: self))) {
          // link to music credits
          if let url = URL(string: "http://www.bensound.com/") {
            UIApplication.shared.open(url, options: [:], completionHandler: { (completion) in
              // dont do anything with this currently
            })
          }
        }
      } else if selectedButton == creditsButton {
        creditsButton.alpha = 1

        showingCredits = !showingCredits
        let fadeOut = SKAction.fadeAlpha(to: 0, duration: 0.25)
        let fadeIn = SKAction.fadeAlpha(to: 1, duration: 0.25)
        if showingCredits {
          creditsNode.run(fadeIn)

          startButton.run(fadeOut)
          highScoreNode.run(fadeOut)
        } else {
          creditsNode.run(fadeOut)

          startButton.run(fadeIn)
          highScoreNode.run(fadeIn)
        }
      }
    }

    selectedButton = nil
  }

  func handleStartButtonHover(isHovering : Bool) {
    if isHovering {
      startButton.texture = startButtonPressedTexture
    } else {
      startButton.texture = startButtonTexture
    }
  }

  func handleSoundButtonHover(isHovering : Bool) {
    if isHovering {
      soundButton.alpha = 0.5
    } else {
      soundButton.alpha = 1.0
    }
  }

  func handleStartButtonClick() {
    for rainDrop in rainDrops {
      rainDrop.physicsBody = SKPhysicsBody(circleOfRadius: 10 * rainDrop.xScale)
      rainDrop.physicsBody?.categoryBitMask = RainDropCategory

      //Makes all of the raindrops fall at different rates
      rainDrop.physicsBody?.linearDamping = CGFloat(arc4random()).truncatingRemainder(dividingBy: 100) / 100
      rainDrop.physicsBody?.mass = CGFloat(arc4random()).truncatingRemainder(dividingBy: 100) / 100
    }
  }

  func handleSoundButtonClick() {
    if SoundManager.sharedInstance.toggleMute() {
      //Is muted
      soundButton.texture = soundButtonTextureOff
    } else {
      //Is not muted
      soundButton.texture = soundButtonTexture
    }
  }

  var didContact = false
  func didBegin(_ contact: SKPhysicsContact) {
    if !didContact {
      didContact = true

      var rainScale : CGFloat = 1
      if contact.bodyA.categoryBitMask == RainDropCategory {
        rainScale = (contact.bodyA.node?.xScale)!
      } else if contact.bodyB.categoryBitMask == RainDropCategory {
        rainScale = (contact.bodyB.node?.xScale)!
      }

      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        let transition = SKTransition.reveal(with: .down, duration: 0.75)
        let gameScene = GameScene(size: self.size, catScale: self.catSprite.xScale, rainScale: rainScale)

        gameScene.scaleMode = self.scaleMode

        self.view?.presentScene(gameScene, transition: transition)
      }
    }
  }
}
