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

  let highScoreNode = SKLabelNode(fontNamed: "PixelDigivolve")

  var selectedButton : SKSpriteNode?

  var rainDrops = [SKSpriteNode]()

  override func sceneDidLoad() {

    backgroundColor = SKColor(red:0.30, green:0.81, blue:0.89, alpha:1.0)

    //Setup logo - sprite initialized earlier
    logoSprite.position = CGPoint(x: size.width / 2, y: size.height / 2 + 100)
    
    addChild(logoSprite)

    //Setup start button
    startButton = SKSpriteNode(texture: startButtonTexture)
    startButton.position = CGPoint(x: size.width / 2, y: size.height / 2 - startButton.size.height / 2)
    addChild(startButton)

    let edgeMargin : CGFloat = 25
    //Setup sound button
    soundButton = SKSpriteNode(texture: (SoundManager.sharedInstance.isMuted ? soundButtonTextureOff : soundButtonTexture))
    soundButton.position = CGPoint(x: size.width - soundButton.size.width / 2 - edgeMargin, y: soundButton.size.height / 2 + edgeMargin)
    addChild(soundButton)

    //Setup high score node
    let defaults = UserDefaults.standard

    let highScore = defaults.integer(forKey: ScoreKey)

    highScoreNode.text = "\(highScore)"
    highScoreNode.fontSize = 90
    highScoreNode.verticalAlignmentMode = .top
    highScoreNode.position = CGPoint(x: size.width / 2, y: startButton.position.y - startButton.size.height / 2 - 50)
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

      if startButton.contains(touch.location(in: self)) {
        selectedButton = startButton
        handleStartButtonHover(isHovering: true)
      } else if soundButton.contains(touch.location(in: self)) {
        selectedButton = soundButton
        handleSoundButtonHover(isHovering: true)
      } else if catSprite.contains(touch.location(in: self)) {
        catSprite.meow()

        if catSprite.xScale < 2 {
          catSprite.setScale(catSprite.xScale + 0.25)
        } else {
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
