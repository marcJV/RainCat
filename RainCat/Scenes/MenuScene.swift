//
//  MenuScene.swift
//  RainCat
//
//  Created by Marc Vandehey on 9/6/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

class MenuScene : SKScene, SKPhysicsContactDelegate {
  let soundButtonTexture = SKTexture(imageNamed: "speaker_on")
  let soundButtonTextureOff = SKTexture(imageNamed: "speaker_off")

  let catSprite = CatSprite.newInstance()
  var soundButton : AlphaButton! = nil
  var creditsButton : AlphaButton! = nil

  var selectedButton : SKNode?

  let creditsNode = CreditsNode()
  let menuNode = MenuNode()
  let playerSelectNode = PlayerSelectNode()

  let rainDropBanner = RainDropBanner()

  var currentNode : SKNode!

  private var showingPlayerSelectScreen = false

  override func sceneDidLoad() {
    backgroundColor = BACKGROUND_COLOR
    let edgeMargin : CGFloat = 25
    let bannerHeight : CGFloat = 100

    rainDropBanner.setup(size: CGSize(width: frame.width, height: bannerHeight))
    rainDropBanner.position = CGPoint(x: 0, y: size.height - bannerHeight - edgeMargin * 2)
    addChild(rainDropBanner)

    currentNode = menuNode

    //Menu Setup
    menuNode.position = CGPoint(x: frame.midX, y: rainDropBanner.position.y - bannerHeight - edgeMargin * 2)
    menuNode.setup()
    addChild(menuNode)

    playerSelectNode.setup(width: frame.width)
    playerSelectNode.alpha = 0
    playerSelectNode.position = CGPoint(x: frame.maxX, y: rainDropBanner.position.y - bannerHeight - edgeMargin * 2)
    addChild(playerSelectNode)

    //Setup sound button
    let baseSoundButton = SKSpriteNode(texture: (SoundManager.sharedInstance.isMuted ? soundButtonTextureOff : soundButtonTexture))

    soundButton = AlphaButton(baseNode: baseSoundButton, size: soundButtonTexture.size(), margin: edgeMargin)
    soundButton.position = CGPoint(x: size.width - soundButton.size.width / 2 - edgeMargin,
                                   y: edgeMargin)

    soundButton.buttonClickAction = {
      if SoundManager.sharedInstance.toggleMute() {
        //Is muted
        (self.soundButton.baseNode as! SKSpriteNode).texture = self.soundButtonTextureOff
      } else {
        //Is not muted
        (self.soundButton.baseNode as! SKSpriteNode).texture = self.soundButtonTexture
      }
    }

    addChild(soundButton)

    //Add in floor physics body
    physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: -size.width / 2, y: 20), to: CGPoint(x: size.width, y: 20))
    physicsBody?.categoryBitMask = FloorCategory
    physicsBody?.contactTestBitMask = RainDropCategory
    physicsBody?.restitution = 0.3

    physicsWorld.contactDelegate = self

    let questionMarkLabel = SKLabelNode(fontNamed: BASE_FONT_NAME)
    questionMarkLabel.text = "?"
    questionMarkLabel.verticalAlignmentMode = .center
    questionMarkLabel.horizontalAlignmentMode = .center

    creditsButton = AlphaButton(baseNode: questionMarkLabel, size: CGSize(width: 22, height: 22), margin: 22)
    creditsButton.position = CGPoint(x: edgeMargin, y: edgeMargin)
    creditsButton.buttonClickAction = {
      let fadeOut = SKAction.fadeAlpha(to: 0, duration: 0.25)
      let fadeIn = SKAction.fadeAlpha(to: 1, duration: 0.25)

      if self.currentNode != self.creditsNode {
        self.menuNode.run(fadeOut)
        self.playerSelectNode.run(fadeOut)

        self.creditsNode.run(fadeIn)

        self.currentNode = self.creditsNode
      } else {
        self.creditsNode.run(fadeOut)
        self.menuNode.run(fadeIn)
        self.playerSelectNode.run(fadeIn)

        self.currentNode = self.showingPlayerSelectScreen ? self.playerSelectNode : self.menuNode
      }
    }

    addChild(creditsButton)

    creditsNode.position = CGPoint(x: frame.midX, y: size.height / 2 + 100)
    creditsNode.setup()

    addChild(creditsNode)

    catSprite.position = menuNode.position
    addChild(catSprite)

    menuNode.startGameAction = {
      self.handleStartButtonClick()
    }

    menuNode.versusAction = {
      self.handleVersesButtonClick()
    }

    playerSelectNode.backAction = {
      self.handleBackButtonClick()
    }

    playerSelectNode.startAction = {
      self.handleStartVerses()
    }
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first {
      if let touchableNode = currentNode as? Touchable {
        touchableNode.touchBegan(touch: touch)
      }

      if catSprite.contains(touch.location(in: self)) {
        SoundManager.sharedInstance.meow(node: catSprite)

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
        rainDropBanner.touchBegan(touch: touch)
      }
    }
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first {
      if let touchableNode = currentNode as? Touchable {
        touchableNode.touchMoved(touch: touch)
      }

      if selectedButton == soundButton {
        handleSoundButtonHover(isHovering: (soundButton.contains(touch.location(in: self))))
      }else if selectedButton == creditsButton {
        creditsButton.alpha = (creditsButton.contains(touch.location(in: self))) ? 0.75 : 1.0
      }
    }
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first {
      if let touchableNode = currentNode as? Touchable {
        touchableNode.touchEnded(touch: touch)
      }
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
    rainDropBanner.makeItRain()
  }

  func handleVersesButtonClick() {
    showingPlayerSelectScreen = true
    currentNode = playerSelectNode

    playerSelectNode.position.x = frame.maxX

    let translateAction = SKAction.moveBy(x: -frame.width, y: 0, duration: 0.25)
    menuNode.run(translateAction)
    playerSelectNode.run(translateAction)

    menuNode.run(SKAction.fadeOut(withDuration: 0.25))
    playerSelectNode.run(SKAction.fadeIn(withDuration: 0.25))
  }

  func handleBackButtonClick() {
    showingPlayerSelectScreen = false
    currentNode = menuNode

    let translateAction = SKAction.moveBy(x: frame.width, y: 0, duration: 0.25)
    menuNode.run(translateAction)
    playerSelectNode.run(translateAction)

    menuNode.run(SKAction.fadeIn(withDuration: 0.25))
    playerSelectNode.run(SKAction.fadeOut(withDuration: 0.25))
  }

  func handleStartVerses() {
    rainDropBanner.makeItRain()
  }

  var didContact = false
  func didBegin(_ contact: SKPhysicsContact) {

    var rainContact = false
    var rainScale : CGFloat = 1
    if contact.bodyA.categoryBitMask == RainDropCategory {
      rainScale = (contact.bodyA.node?.xScale)!
      rainContact = true
    } else if contact.bodyB.categoryBitMask == RainDropCategory {
      rainScale = (contact.bodyB.node?.xScale)!
      rainContact = true
    }

    if !didContact && rainContact {
      didContact = true

      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        let transition = SKTransition.reveal(with: .down, duration: 0.75)
        transition.pausesOutgoingScene = false
        transition.pausesIncomingScene = false

        var scene : SKScene?

        if self.currentNode == self.menuNode {
          scene = GameScene(size: self.size, catScale: self.catSprite.xScale, rainScale: rainScale)
        } else {

//          scene = SKScene(fileNamed: "LCDScene")

                    scene = PingPongScene(size: self.size,
                                          player1ColorPalette: self.playerSelectNode.playerOnePalette(),
                                          player2ColorPalette: self.playerSelectNode.playerTwoPalette(),
                                          catScale: self.catSprite.xScale,
                                          rainScale: rainScale)
        }

        if let scene = scene {
          scene.scaleMode = self.scaleMode

          self.view?.presentScene(scene, transition: transition)
        }
        
        self.clearButtonActions()
      }
    }
  }
  
  // Clean up all closures to remove circular references
  private func clearButtonActions() {
    soundButton.buttonClickAction = nil
    creditsButton.buttonClickAction = nil
    
    menuNode.clearActions()
    playerSelectNode.clearActions()
  }

  public static func presentMenuScene(currentScene : SKScene) {
    let transition = SKTransition.reveal(with: .up, duration: 0.75)
    transition.pausesOutgoingScene = false
    transition.pausesIncomingScene = false

    let gameScene = MenuScene(size: currentScene.size)
    gameScene.scaleMode = currentScene.scaleMode

    currentScene.view?.presentScene(gameScene, transition: transition)
  }

  deinit {
    print("menu scene destroyed")
  }
}
